import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Response/AppOTPScreenChecker.dart';
import 'package:tymoff/Network/Response/AppSetContentScrollTimer.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/Network/Response/CacheApiHandler.dart';
import 'package:tymoff/Network/Response/ContentDefault.dart';
import 'package:tymoff/Network/Response/IpCountryResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Network/Response/ResponseAppMetaData.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

const String _TAG_CONTENT_UPLOAD = "ContentUpload -> ";

enum AppMetaDataType { MetaData, IpData }

class SharedPrefUtil {
  static const String _KEY_LOGIN_DATA = "loginData";
  static const String _KEY_META_DATA = "metaData";
  static const String _KEY_CONTENT_DATA = "contentData";
  static const String KEY_UPLOAD_CONTENT_DRAFT_DATA = "uploadContentDraftData";
  static const String KEY_UPLOAD_CONTENT_SERVER_SYNC_DATA =
      "uploadContentServerSyncData";
  static const String _KEY_APP_META_DATA = "appMetaData";
  static const String _KEY_CACHE_API_HANDLER = "appCacheApiHandler";
  static const String _KEY_APP_UDID = "appUDID";
  static const String _KEY_APP_IP_DATA = "appIPData";
  static const String _KEY_DYNAMIC_LINKS = "dynamicLinks";

  static const String THEME = "theme";

  static const String USER_BREAK_TIME = "userbreaktime";
  static const String USER_BREAK_TIME_TOGGLE = "userbreaktimetoggle";
  static const String KEY_RESTRICTED_MODE = "restrictedModeToggle";

  static List<String> alSpKeysToRemove = {
    _KEY_LOGIN_DATA,
    _KEY_CONTENT_DATA,
    KEY_UPLOAD_CONTENT_DRAFT_DATA,
    KEY_UPLOAD_CONTENT_SERVER_SYNC_DATA,
    _KEY_APP_META_DATA,
    _KEY_CACHE_API_HANDLER,
    USER_BREAK_TIME,
    USER_BREAK_TIME_TOGGLE,
    KEY_RESTRICTED_MODE,
    _KEY_DYNAMIC_LINKS
  }.toList();

  ///
  /// Common Methods - START
  ///

  static Future<bool> isMetaDataSync(AppMetaDataType appMetaDataType) async {
    var isMetaDataSync = false;
    switch (appMetaDataType) {
      case AppMetaDataType.MetaData:
        {
          var spAppMetaData = await getAppMetaData();
          isMetaDataSync =
              isAppMetaDataValid(spAppMetaData?.dateMetaDataLastSyncFromServer);
          break;
        }
      case AppMetaDataType.IpData:
        {
          var spAppIpData = await getAppIPData();
          isMetaDataSync = isAppMetaDataValid(spAppIpData?.lastUpdatedTime);
          break;
        }
    }

    return isMetaDataSync;
  }

  static bool isAppMetaDataValid(int syncDate) {
    try {
      var savedDateTime = DateTime.fromMillisecondsSinceEpoch(syncDate);
      var nowDateTime = DateTime.now();

      if (savedDateTime.year < nowDateTime.year) {
        return false;
      }
      if (savedDateTime.month < nowDateTime.month) {
        return false;
      }
      if (savedDateTime.day < nowDateTime.day) {
        return false;
      }
      return true;
    } catch (e) {
      print("isAppMetaDataValid() -> $e");
    }
    return false;
  }

  static void setCurrentAppMetaDateSync(AppMetaDataType appMetaDataType) async {
    switch (appMetaDataType) {
      case AppMetaDataType.MetaData:
        {
          var spAppMetaData = await getAppMetaData();

          if (spAppMetaData != null) {
            saveAppMetaData(spAppMetaData);
          } else {
            saveAppMetaData(ResponseAppMetaData());
          }
          break;
        }
      case AppMetaDataType.IpData:
        {
          var spAppIpData = await getAppIPData();

          if (spAppIpData != null) {
            saveAppIPData(spAppIpData);
          } else {
            saveAppIPData(IpCountryResponse());
          }
          break;
        }
    }
  }

  ///
  /// Common Methods - END
  ///

  static Future<bool> getUserBreakTimeState() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(USER_BREAK_TIME_TOGGLE);

    if (name == null) return false;

    return name.toLowerCase() == "true" ? true : false;
  }

  static Future<bool> saveUserBreakTimeState(String breakState) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_BREAK_TIME_TOGGLE, breakState);
    return true;
  }

  static Future<String> getUserBreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(USER_BREAK_TIME);

    print("userbreaktime");
    print(name);
    if (name == null) return "0";

    return Future.value(name);
  }

  static Future<bool> saveUserBreakTime(String breaktime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_BREAK_TIME, breaktime);

    print("setbreaktime: " + breaktime);

    String name = prefs.getString(USER_BREAK_TIME);

    print("userbreaktime----");
    print(name);

    getUserBreakTime();

    return true;
  }

  Future<bool> saveTheme(String themeName) async {
    try {
      if (themeName != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(THEME, themeName);
        EventBusUtils.eventAppThemeChange();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String name = prefs.getString(THEME);
      return name;
    } catch (e) {}
    return ThemeModel.THEME_LIGHT;
  }

  static Future<bool> _saveLoginDataJson(String loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_LOGIN_DATA, loginData);
    return true;
  }

  static Future<bool> _saveMetaDataJson(String metaDataJson) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_META_DATA, metaDataJson);

    setCurrentAppMetaDateSync(AppMetaDataType.MetaData);
    return true;
  }

  static Future<bool> _saveContentJson(String contentDefault) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_CONTENT_DATA, contentDefault);
    return true;
  }

  static Future<bool> saveLoginData(LoginResponse loginData) async {
    Map<String, dynamic> res = loginData.toJson();
    String jsonLogin = json.encode(res);
    if (loginData != null) {
      _saveLoginDataJson(jsonLogin);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> saveMetaData(MetaDataResponse objectToSave) async {
    Map<String, dynamic> res = objectToSave.toJson();
    String jsonLogin = json.encode(res);
    if (objectToSave != null) {
      _saveMetaDataJson(jsonLogin);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> saveContentData(ContentDefault contentDefault) async {
    Map<String, dynamic> res = contentDefault.toJson();
    String jsonLogin = json.encode(res);
    if (contentDefault != null) {
      _saveContentJson(jsonLogin);
      return true;
    } else {
      return false;
    }
  }

  static Future<LoginResponse> getLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String loginData = prefs.getString(_KEY_LOGIN_DATA);

      Map<String, dynamic> user = json.decode(loginData);

      LoginResponse loginRes = new LoginResponse.fromJson(user);
      return loginRes;
    } catch (e) {}
    return null;
  }

  static Future<MetaDataResponse> getMetaData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String loginData = prefs.getString(_KEY_META_DATA);

      Map<String, dynamic> user = json.decode(loginData);

      MetaDataResponse savedObject = new MetaDataResponse.fromJson(user);
      return savedObject;
    } catch (e) {}
    return null;
  }

  static Future<String> getLoggedInUserId() async {
    try {
      final loginRes = await getLoginData();
      return loginRes.data.id.toString();
    } catch (e) {}

    return "";
  }

  static Future<bool> isLogin() async {
    try {
      final loginRes = await getLoginData();
      if (loginRes.statusCode == 200) {
        return true;
      }
    } catch (e) {}

    return false;
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    for (int index = 0; index < (alSpKeysToRemove?.length ?? 0); index++) {
      String spKeysToRemove = alSpKeysToRemove[index];
      await prefs.remove(spKeysToRemove);
    }

    EventBusUtils.eventTakeABreak_Set();
  }

  ///
  ///App Meta Data Related Methods - START
  ///

  static Future<bool> saveAppMetaData(
      ResponseAppMetaData responseAppMetaData) async {
    try {
      Map<String, dynamic> res = responseAppMetaData.toJson();
      String dataToSavae = json.encode(res);
      if (responseAppMetaData != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_KEY_APP_META_DATA, dataToSavae);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<ResponseAppMetaData> getAppMetaData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String loginData = prefs.getString(_KEY_APP_META_DATA);

      Map<String, dynamic> user = json.decode(loginData);

      ResponseAppMetaData loginRes = new ResponseAppMetaData.fromJson(user);
      return loginRes;
    } catch (e) {}
    return ResponseAppMetaData();
  }

  static void setIsOnboardingShowed(bool isShowed) async {
    var spAppMetaData = await getAppMetaData();

    if (spAppMetaData == null) {
      spAppMetaData = ResponseAppMetaData();
    }

    if (isShowed != null) {
      spAppMetaData.isOnBoardingAlreadyShowed = isShowed;
    }

    saveAppMetaData(spAppMetaData);
  }

  static Future<bool> isOnboardingShowed() async {
    try {
      var spAppMetaData = await getAppMetaData();

      if (spAppMetaData != null &&
          spAppMetaData.isOnBoardingAlreadyShowed != null) {
        return spAppMetaData.isOnBoardingAlreadyShowed;
      }
    } catch (e) {}

    return false;
  }

  static void setIsFirstContentCardClickEventCompleted(bool isCompleted) async {
    var spAppMetaData = await getAppMetaData();

    if (spAppMetaData == null) {
      spAppMetaData = ResponseAppMetaData();
    }

    if (isCompleted != null) {
      spAppMetaData.isFirstTimeContentCardClickEventCompleted = isCompleted;
    }

    await saveAppMetaData(spAppMetaData);
  }

  static Future<bool> isFirstTimeContentCardClickEventCompleted() async {
    try {
      var spAppMetaData = await getAppMetaData();

      if (spAppMetaData != null &&
          spAppMetaData.isFirstTimeContentCardClickEventCompleted != null) {
        return spAppMetaData.isFirstTimeContentCardClickEventCompleted;
      }
    } catch (e) {}

    return false;
  }

  static Future<void> setIsFirstContentCardScrollEventCompleted(
      bool isCompleted) async {
    var spAppMetaData = await getAppMetaData();

    if (spAppMetaData == null) {
      spAppMetaData = ResponseAppMetaData();
    }

    if (isCompleted != null) {
      spAppMetaData.isFirstTimeContentCardScrollEventCompleted = isCompleted;
    }

    await saveAppMetaData(spAppMetaData);
  }

  static Future<bool> isFirstTimeContentCardScrollEventCompleted() async {
    try {
      var spAppMetaData = await getAppMetaData();

      if (spAppMetaData != null &&
          spAppMetaData.isFirstTimeContentCardScrollEventCompleted != null) {
        return spAppMetaData.isFirstTimeContentCardScrollEventCompleted;
      }
    } catch (e) {}

    return false;
  }

  ///
  ///App Meta Data Related Methods - END
  ///

  ///
  /// App Break Reminder Related Methods - START
  ///

  static Future<bool> saveAppTakeBreakReminder(
      AppTakeBreakReminder toSaveData) async {
    try {
      var appMetaData = await getAppMetaData();
      appMetaData.appTakeBreakReminder = toSaveData;

      await saveAppMetaData(appMetaData);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<AppTakeBreakReminder> getAppTakeBreakReminder() async {
    try {
      var appMetaData = await getAppMetaData();
      return appMetaData.appTakeBreakReminder;
    } catch (e) {}
    return AppTakeBreakReminder();
  }

  ///
  /// App Break Reminder Related Methods - END
  ///

  ///
  /// App Show OTP Related Methods - START
  ///

  static Future<bool> saveShowOTPScreenMeta(
      AppOTPScreenChecker toSaveData) async {
    try {
      var appMetaData = await getAppMetaData();
      appMetaData.appOTPScreenChecker = toSaveData;

      await saveAppMetaData(appMetaData);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<AppOTPScreenChecker> getShowOTPScreenMeta() async {
    try {
      var appMetaData = await getAppMetaData();
      return appMetaData.appOTPScreenChecker;
    } catch (e) {}
    return null;
  }

  ///
  /// App Show OTP Related Methods - END
  ///

  ///
  /// Content Scroll Timer Related Methods - START
  ///

  static Future<bool> saveAppContentScrollTimer(
      AppSetContentScrollTimer toSaveData) async {
    try {
      var appMetaData = await getAppMetaData();
      appMetaData.appSetContentScrollTimer = toSaveData;

      await saveAppMetaData(appMetaData);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<AppSetContentScrollTimer> getAppContentScrollTimer() async {
    try {
      var appMetaData = await getAppMetaData();
      return appMetaData.appSetContentScrollTimer;
    } catch (e) {}
    return AppSetContentScrollTimer();
  }

  ///
  /// Content Scroll Timer Related Methods - END
  ///

  ///
  /// App Restricted Mode Methods - START
  ///

  static Future<bool> saveRestrictedMode(bool isRestrictedModeOn) async {
    try {
      if (isRestrictedModeOn != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool(KEY_RESTRICTED_MODE, isRestrictedModeOn);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getRestrictedMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var isRestrictedMode = prefs.getBool(KEY_RESTRICTED_MODE);
      return isRestrictedMode;
    } catch (e) {}
    return false;
  }

  ///
  /// APP Cache Related Methods - START
  ///

  static Future<bool> saveApiHandleCacheMap(
      Map<String, String> hashMapOfCacheRequest) async {
    try {
      var savedCache = await getApiHandleCache();
      if (savedCache != null && savedCache.hashMapOfCacheRequest != null) {
        savedCache.hashMapOfCacheRequest = hashMapOfCacheRequest;
      } else {
        if (savedCache == null) {
          savedCache = CacheApiHandler();
        }
        savedCache.hashMapOfCacheRequest = hashMapOfCacheRequest;
      }
      return saveApiHandleCache(savedCache);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveApiHandleCache(CacheApiHandler toSaveData) async {
    try {
      Map<String, dynamic> res = toSaveData.toJson();
      String dataToSave = json.encode(res);
      if (dataToSave != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_KEY_CACHE_API_HANDLER, dataToSave);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<CacheApiHandler> getApiHandleCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String spData = prefs.getString(_KEY_CACHE_API_HANDLER);

      Map<String, dynamic> dynamicData = json.decode(spData);

      CacheApiHandler objectResponse =
          new CacheApiHandler.fromJson(dynamicData);
      return objectResponse;
    } catch (e) {}
    return CacheApiHandler();
  }

  static Future<bool> setAppUDID() async {
    try {
      String dataToSave = await FlutterUdid.consistentUdid;
      if (dataToSave != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_KEY_APP_UDID, dataToSave);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String> getAppUDID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String spData = prefs.getString(_KEY_APP_UDID);

      return spData;
    } catch (e) {}
    return await FlutterUdid.consistentUdid;
  }

  ///
  /// APP Cache Related Methods - END
  ///

  ///
  /// APP Dynamic Links Related Methods - START
  ///

  static Future<bool> _saveDynamicLinksCache(CacheApiHandler toSaveData) async {
    try {
      Map<String, dynamic> res = toSaveData.toJson();
      String dataToSave = json.encode(res);
      if (dataToSave != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_KEY_DYNAMIC_LINKS, dataToSave);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<CacheApiHandler> _getDynamicLinksCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String spData = prefs.getString(_KEY_DYNAMIC_LINKS);

      Map<String, dynamic> dynamicData = json.decode(spData);

      CacheApiHandler objectResponse =
          new CacheApiHandler.fromJson(dynamicData);
      return objectResponse;
    } catch (e) {}
    return CacheApiHandler();
  }

  static Future<bool> saveDynamicLinksCacheMap(
      String contentUrlOfDynamicLink, String contentDynamicLinkToSave) async {
    try {
      var savedCache = await _getDynamicLinksCache();

      if (savedCache == null) {
        savedCache = CacheApiHandler();
      }
      if (savedCache.hashMapOfCacheRequest == null) {
        savedCache.hashMapOfCacheRequest = HashMap();
      }

      savedCache.hashMapOfCacheRequest[contentUrlOfDynamicLink] =
          contentDynamicLinkToSave;

      var isSaved = await _saveDynamicLinksCache(savedCache);
      return isSaved;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getDynamicLinksFromCache(
      String contentUrlOfDynamicLink) async {
    try {
      var savedCache = await _getDynamicLinksCache();
      var hashMapOfCacheRequest = savedCache.hashMapOfCacheRequest;
      return hashMapOfCacheRequest[contentUrlOfDynamicLink];
    } catch (e) {
      PrintUtils.printLog(
          "Munish Thakur -> getDynamicLinksFromCache() -> Error: ${e.toString()}");
    }
    return null;
  }

  ///
  /// APP Dynamic Links Related Methods - END
  ///

  ///
  ///App IP Related Methods - START
  ///
  static Future<MetaDataCountryResponseDataCommon> getCountryDataByIp(
      String isoCode) async {
    MetaDataCountryResponseDataCommon metaDataCountryResponseDataCommon;

    try {
      if (isoCode == null) {
        return null;
      }

      MetaDataResponse metaDataResponse = await SharedPrefUtil.getMetaData();
      metaDataResponse?.data?.countries?.forEach((_country) {
        if (_country != null &&
            isoCode != null &&
            _country.isoCode == isoCode) {
          metaDataCountryResponseDataCommon = _country;
        }
      });
    } catch (e) {
      print("Munish Thakur -> getCountryDataByIp() -> ${e.toString()}");
    }

    return metaDataCountryResponseDataCommon;
  }

  static Future<bool> saveAppIPData(IpCountryResponse responseAppIPData) async {
    try {
      responseAppIPData.setLastUpdatedTime();
      Map<String, dynamic> res = responseAppIPData.toJson();
      String dataToSavae = json.encode(res);
      if (responseAppIPData != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_KEY_APP_IP_DATA, dataToSavae);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<IpCountryResponse> getAppIPData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String loginData = prefs.getString(_KEY_APP_IP_DATA);

      Map<String, dynamic> user = json.decode(loginData);

      IpCountryResponse jsonRes = new IpCountryResponse.fromJson(user);
      return jsonRes;
    } catch (e) {}
    return IpCountryResponse();
  }

  ///
  ///App IP Related Methods - END
  ///

}
