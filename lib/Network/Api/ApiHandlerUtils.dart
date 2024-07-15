import 'dart:convert';

import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

class ApiHandlerUtils {
  ///
  ///  Content Url Listing with Search And filters - START
  ///

  static final String contentUrlPrefix = "/data/content";
  static final int CONTENT_LOADING_SIZE = 20;
  static String getContentUrl(int page) {
    return "$contentUrlPrefix?page=$page&size=$CONTENT_LOADING_SIZE";
  }

  static String getContentListResponseInString(
      ActionContentListResponse response) {
    try {
      var dynamicMap = response.toJson();
      var jsonResponse = json.encode(dynamicMap);

      return jsonResponse;
    } catch (e) {}

    return null;
  }

  static ActionContentListResponse getContentListResponse(
      String responseOfApi) {
    Map<String, dynamic> user = json.decode(responseOfApi);
    ActionContentListResponse objectResponse =
        ActionContentListResponse.fromJson(user);

    filterContentData(objectResponse);
    return objectResponse;
  }

  ///
  ///  Content Url Listing with Search And filters - END
  ///

  ///
  ///  Discover Url Listing - START
  ///

  static final String _discoverUrl = "/data/discover/size/10";
  static final String _userSpecificDiscoverUrl = "/data/user/discover/size/2";

  static String getDiscoverUrl() {
    return _discoverUrl;
  }

  static String getUserSpecificDiscoverUrl() {
    return _userSpecificDiscoverUrl;
  }

  static String getDiscoverListResponseInString(DiscoverListResponse response) {
    try {
      var dynamicMap = response.toJson();
      var jsonResponse = json.encode(dynamicMap);

      return jsonResponse;
    } catch (e) {}

    return null;
  }

  static DiscoverListResponse getDiscoverListResponse(String responseOfApi) {
    Map<String, dynamic> user = json.decode(responseOfApi);
    DiscoverListResponse objectResponse = DiscoverListResponse.fromJson(user);

    return objectResponse;
  }

  ///
  ///  Discover Url Listing - END
  ///

  ///
  ///  Profile Url Listing - START
  ///
  static String getProfileContentUrl(int page, String actionType) {
    return "${getProfileContentUrlPrefix(actionType)}?page=$page&size=10";
  }

  static String getProfileContentUrlPrefix(String actionType) {
    return "/data/action/$actionType/user/content";
  }

  ///
  ///  Profile Url Listing - END
  ///

  static void filterContentData(ActionContentListResponse objectResponse) {
    objectResponse?.data?.removeWhere((content) => _isContentNotValid(content));
  }

  static bool _isContentNotValid(ActionContentData content) {
    try {
      var typeId = content.typeId;
      var contentType = ContentTypeUtils.getType(typeId);
      if (contentType == AppContentType.image ||
          contentType == AppContentType.video ||
          contentType == AppContentType.article ||
          contentType == AppContentType.gif) {
        if ((content?.contentUrl?.length ?? 0) <= 0) {
          return true;
        }
      }
    } catch (e) {
      PrintUtils.printLog(e);
    }
    return false;
  }

  static final contentFeedCacheExpireTimeInMinutes = 30;
  static final contentFeedRefreshTimeInMinutes = 20;
  static final showOTPScreenCacheExpireTimeInMinutes = 10;

  static bool isContentListingCacheExpired(int oldMillisecondsSinceEpoch) {
    bool isExpired = true;
    try {
      int currentMilliseconds = DateTimeUtils().currentMillisecondsSinceEpoch();

      var oldDateTime =
      DateTime.fromMillisecondsSinceEpoch(oldMillisecondsSinceEpoch);
      var currentDateTime =
      DateTime.fromMillisecondsSinceEpoch(currentMilliseconds);
      var durationDiff = currentDateTime.difference(oldDateTime);
      isExpired = durationDiff.inMinutes > contentFeedCacheExpireTimeInMinutes;
    } catch (e) {
      PrintUtils.printLog("Munish Thakur -> isContentListingCacheExpired() -> ${e.toString()}");
    }
    return isExpired;
  }

  static bool isShowOtpCacheExpired(int oldMillisecondsSinceEpoch) {
    bool isExpired = true;
    try {
      int currentMilliseconds = DateTimeUtils().currentMillisecondsSinceEpoch();

      var oldDateTime =
      DateTime.fromMillisecondsSinceEpoch(oldMillisecondsSinceEpoch);
      var currentDateTime =
      DateTime.fromMillisecondsSinceEpoch(currentMilliseconds);
      var durationDiff = currentDateTime.difference(oldDateTime);
      isExpired = durationDiff.inMinutes > showOTPScreenCacheExpireTimeInMinutes;
    } catch (e) {
      PrintUtils.printLog("Munish Thakur -> isContentListingCacheExpired() -> ${e.toString()}");
    }
    return isExpired;
  }

  static bool isContentListingRefreshNeeded(DateTime oldDateTime) {
    bool isExpired = false;
    try {
      int currentMilliseconds = DateTimeUtils().currentMillisecondsSinceEpoch();
      var currentDateTime = DateTime.fromMillisecondsSinceEpoch(currentMilliseconds);

      var durationDiff = currentDateTime.difference(oldDateTime);
      isExpired = durationDiff.inMinutes > contentFeedRefreshTimeInMinutes;


      PrintUtils.printLog("Munish Thakur -> checkNewFeedAndShow() -> isContentListingRefreshNeeded() -> isExpired: $isExpired, (oldDateTime: $oldDateTime, currentDateTime: $currentDateTime)");

    } catch (e) {
      PrintUtils.printLog("Munish Thakur -> isContentListingRefreshNeeded() -> ${e.toString()}");
    }
    return isExpired;
  }
}
