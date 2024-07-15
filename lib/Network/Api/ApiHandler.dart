import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:tymoff/Network/Requests/DescriptionAlgoApi.dart';
import 'package:tymoff/Network/Requests/FeedbackRequest.dart';
import 'package:tymoff/Network/Requests/ProfilePutRequest.dart';
import 'package:tymoff/Network/Requests/ReportRequest.dart';
import 'package:tymoff/Network/Requests/RequestCommentPushContent.dart';
import 'package:tymoff/Network/Requests/RequestEditProfile.dart';
import 'package:tymoff/Network/Requests/RequestFetchContent.dart';
import 'package:tymoff/Network/Requests/RequestFilterContent.dart';
import 'package:tymoff/Network/Requests/UploadContentRequest.dart';
import 'package:tymoff/Network/Response/ActionContentListResponseTemp.dart';
import 'package:tymoff/Network/Response/ClearHistoryResponse.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Network/Response/CommonResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Network/Response/DeletePostResponse.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Network/Response/FeedbackResponse.dart';
import 'package:tymoff/Network/Response/IpCountryResponse.dart';
import 'package:tymoff/Network/Response/LogOutResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Network/Response/NotificationResponse.dart';
import 'package:tymoff/Network/Response/PutActionCommentResponse.dart';
import 'package:tymoff/Network/Response/PutActionLikeResponse.dart';
import 'package:tymoff/Network/Response/SearchHintResponse.dart';
import 'package:tymoff/Network/Response/UploadContentResponse.dart';
import 'package:tymoff/SharedPref/SPModels/SyncUploadContentRequestToServer.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilServerSyncUpload.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
import 'package:tymoff/Utils/DialogUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SecurityUtils.dart';
import 'package:tymoff/main.dart';

import 'ApiHandlerUtils.dart';
import 'NetworkCallInterceptor.dart';

class ApiHandler {
  static final String _ContentTypeJson = "application/json";

  static final String _DEVELOPMENT_URL = "http://192.241.250.169:9896";

  // static final String _PRODUCTION_URL = "https://apis.tymoff.com:8443";//OLD URL,
  static final String _PRODUCTION_URL = "https://server-end.tymoff.com:8443";
  static final String _IP_URL = "https://forapp.live/IpPoolAPI";

  static final String _ACTIVE_URL = _PRODUCTION_URL;

  static final String BASE_URL = "$_ACTIVE_URL/aintertain/api/v1";

  static final Duration _reqTimeOut = new Duration(seconds: 60);
  static final Duration _resTimeOut = new Duration(seconds: 60);

  static const String _progressMessage = "Please wait ...";
  static ApiHandler _instance;
  static Dio _api;

  static const String KEY_AUTHORIZATION = "Authorization";
  static const String KEY_X_AUTH_TOKEN = "x-auth-token";
  static const String KEY_X_UDID = "udid";
  static const String KEY_X_QR_CODE = "QrCode";

  static ApiHandler getInstance() {
    if (_instance == null) _instance = new ApiHandler();

    return _instance;
  }

  static Future<Dio> getApiFromUrl(String url) async {
    Dio _api = new Dio();

    _api.options.baseUrl = url;
    //_api.options.contentType = ContentType.parse("application/json");
    _api.options.contentType = _ContentTypeJson;
    _api.interceptors.add(NetworkCallInterceptor());
    _api.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));

    return _api;
  }

  /// dio instance method.
  static Future<Dio> getApi() async {
    if (_api == null) {
      _api = new Dio();

      _api.options.baseUrl = BASE_URL;
      //_api.options.contentType = ContentType.parse("application/json");
      _api.options.contentType = _ContentTypeJson;
      _api.interceptors.add(NetworkCallInterceptor());
      _api.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }

    if (_api != null) {
      var isLogin = await SharedPrefUtil.isLogin();
      var loginData = await SharedPrefUtil.getLoginData();
      if (isLogin && loginData?.data?.token != null) {
        if (_api.options.headers.containsKey(KEY_AUTHORIZATION)) {
          _api.options.headers.remove(KEY_AUTHORIZATION);
        }
        _api.options.headers[KEY_X_AUTH_TOKEN] = loginData?.data?.token;
      } else {
        if (_api.options.headers.containsKey(KEY_X_AUTH_TOKEN)) {
          _api.options.headers.remove(KEY_X_AUTH_TOKEN);
        }
      }

      var appUdid = await SharedPrefUtil.getAppUDID();
      _api.options.headers[KEY_X_UDID] = appUdid;
      _api.options.headers["Access-Control-Allow-Origin"] = "No";

      return _api;
    }

    return _api;
  }

  static Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = HashMap();

    var isLogin = await SharedPrefUtil.isLogin();
    var loginData = await SharedPrefUtil.getLoginData();
    if (isLogin && loginData?.data?.token != null) {
      headers[KEY_X_AUTH_TOKEN] = loginData?.data?.token;
    }

    var appUdid = await SharedPrefUtil.getAppUDID();
    var appUdidEncrypted = await SecurityUtils.encryptCombinedUdid(appUdid);

    headers[KEY_X_UDID] = appUdidEncrypted;

    print("Munish Thakur -> getApiHeaders() -> ${headers.toString()}");

    return headers;
  }

  /// Simple Login Api Method
  static Future<LoginResponse> doSimpleLogin(
      BuildContext context, String username, String password) async {
    try {
      DialogUtils.showProgress(context);

      var dio = await getApi();
      var str = username + ':' + password;
      var bytes = utf8.encode(str);
      var base64encodedData = base64.encode(bytes);
      PrintUtils.printLog("base64encodedData -> $base64encodedData");
      dio.options.headers = {KEY_AUTHORIZATION: 'Basic ' + base64encodedData};
      //or works once
      Response response = await dio.get("/user/login");

      var responseLogin = handleLoginResponse(response);

      DialogUtils.hideProgress(context);

      return responseLogin;
    } catch (e) {
      PrintUtils.printLog(e);
    }

    DialogUtils.hideProgress(context);
    return null;
  }

  /// Email Verification Api Method
  static Future<LoginResponse> doVerifiedEmail(BuildContext context,
      String email, String flowType, String socialType) async {
    try {
      DialogUtils.showProgress(context);
      var dio = await getApi();
      //or works once
      var req = {
        "email": email,
        "flowType": flowType,
        "socialType": socialType
      };
      Response response = await dio.put("/user/email/validate", data: req);
      var responseLogin = handleLoginResponse(response);
      DialogUtils.hideProgress(context);
      return responseLogin;
    } catch (e) {
      PrintUtils.printLog(e);
    }

    DialogUtils.hideProgress(context);
    return null;
  }

  static LoginResponse handleLoginResponse(Response responseLogin) {
    try {
      var headers = responseLogin.headers;
      var xAuthToken = headers.value(KEY_X_AUTH_TOKEN);

      String parsedLoginResponse = responseLogin.toString();

      Map<String, dynamic> user = json.decode(parsedLoginResponse);

      LoginResponse loginResponse = LoginResponse.fromJson(user);
      loginResponse.data?.token = xAuthToken;

      return loginResponse;
    } catch (e) {
      PrintUtils.printLog(e);
    }

    return null;
  }

  /// Otp Validation Api Method
  static Future<CommonResponse> sendOtpMobile(
      BuildContext context, String countryCode, String phone) async {
    DialogUtils.showProgress(context, msg: "Please wait...");

    try {
      var dio = await getApi();
      //or works once
      var req = {
        "phone": phone,
        "countryCode": countryCode,
        "socialType": "app",
        "flowType": "login"
      };
      Response response = await dio.put("/user/otp", data: req);

      String parseResponse = response.toString();

      Map<String, dynamic> responseMap = json.decode(parseResponse);

      var responseOtpSend = CommonResponse.fromJson(responseMap);
      DialogUtils.hideProgress(context);
      return responseOtpSend;
    } catch (e) {
      PrintUtils.printLog(e);
    }
    DialogUtils.hideProgress(context);
    return null;
  }

  /// Otp Validation Api Method
  static Future<LoginResponse> validateOTPEmail(
      BuildContext context, String email, String otp,
      {String password = ""}) async {
    DialogUtils.showProgress(context, msg: "Please wait...");

    try {
      var dio = await getApi();
      //or works once
      var req = {"email": email, "otp": otp, "password": password};
      Response response = await dio.put("/user/otp/validate", data: req);
      var responseLogin = handleLoginResponse(response);
      DialogUtils.hideProgress(context);
      return responseLogin;
    } catch (e) {
      PrintUtils.printLog(e);
    }
    DialogUtils.hideProgress(context);
    return null;
  }

  /// Otp Validation Api Method
  static Future<LoginResponse> validateOTPMobile(
      BuildContext context, String phone, String otp) async {
    DialogUtils.showProgress(context, msg: "Please wait...");

    try {
      var dio = await getApi();
      //or works once
      var req = {"phone": phone, "otp": otp};
      Response response = await dio.put("/user/otp/validate", data: req);
      var responseLogin = handleLoginResponse(response);
      DialogUtils.hideProgress(context);
      return responseLogin;
    } catch (e) {
      PrintUtils.printLog(e);
    }
    DialogUtils.hideProgress(context);
    return null;
  }

  /// Otp Validation Api Method
  static Future<LoginResponse> validateOTPEncrypted(
      BuildContext context, String otpEncryptedString) async {
    DialogUtils.showProgress(context, msg: "Please wait...");

    try {
      var dio = await getApi();
      Response response = await dio.get("/user/otp/validate/$otpEncryptedString");
      var responseLogin = handleLoginResponse(response);
      DialogUtils.hideProgress(context);
      return responseLogin;
    } catch (e) {
      PrintUtils.printLog(e);
    }
    DialogUtils.hideProgress(context);
    return null;
  }

  static void loadAfterLoginData(BuildContext context) async {
    getMetaData(context, isForceRefresh: true);
  }

  /// Meta Data Api Method
  static Future<MetaDataResponse> getMetaData(BuildContext context,
      {bool isForceRefresh = false}) async {
    //DialogUtils.showProgress(context, msg: "Please wait...");

    bool isMetaCanLoad = false;
    if (isForceRefresh) {
      isMetaCanLoad = isForceRefresh;
    } else {
      var isSync =
          await SharedPrefUtil.isMetaDataSync(AppMetaDataType.MetaData);
      isMetaCanLoad = !isSync;
    }

    if (isMetaCanLoad) {
      try {
        var dio = await getApi();

        Response response = await dio.get("/data");
        String responseOfApi = response.toString();

        Map<String, dynamic> user = json.decode(responseOfApi);

        MetaDataResponse objectResponse = MetaDataResponse.fromJson(user);

        SharedPrefUtil.saveMetaData(objectResponse);

        DialogUtils.hideProgress(context);
        return objectResponse;
      } catch (e) {
        PrintUtils.printLog(e);
      }
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Search Hint Api Method
  static Future<SearchHintResponse> getSearchHint(
      BuildContext context, String query, {CancelToken cancelToken}) async {
    try {
      var dio = await getApi();

      Response response =
          await dio.get("/data/content/search/hint/$query?page=0&size=20", cancelToken: cancelToken);
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      SearchHintResponse objectResponse = SearchHintResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getSearchHint() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getSearchHint() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Comment Post Api Method
  static Future<PutActionCommentResponse> putComment(
      BuildContext context, RequestCommentPushContent request1) async {
    try {
      var dio = await getApi();

      Response response = await dio.put("/data/comment", data: request1);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      PutActionCommentResponse objectResponse =
          PutActionCommentResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Feedback Post Api Method
  static Future<FeedbackResponse> putFeedback(
      BuildContext context, FeedbackRequest request1) async {
    try {
      var dio = await getApi();

      Response response = await dio.put("/data/feedback", data: request1);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      FeedbackResponse objectResponse = FeedbackResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error putfeedback() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error putfeedback() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Restricted Mode Api Method
  static Future<FeedbackResponse> putRestrictedAdultContent(
      BuildContext context, bool isRestrictedMode) async {
    try {
      var dio = await getApi();
      var request = {"isAdultContentHide": isRestrictedMode};
      PrintUtils.printLog("Restricted Mode request : -> $request");

      Response response = await dio.put("/user/settings", data: request);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      FeedbackResponse objectResponse = FeedbackResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error putRestrictedAdultContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error putRestrictedAdultContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Edit Profile Api Method
  static Future<LoginResponse> putEditProfile(
      BuildContext context, RequestEditProfile request1) async {
    try {
      var dio = await getApi();

      print("Munish Thakur -> SelectUserName Screen -> API Request -> \n${request1.toJson()}");
      Response response = await dio.put("/user/profile", data: request1);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      LoginResponse objectResponse = LoginResponse.fromJson(user);

      if (objectResponse.isSuccess()) {
        await SharedPrefUtil.saveLoginData(objectResponse);
      }
      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Profile Action Api Method (for my post, like, most like etc)...
  static Future<PutActionLikeResponse> putProfile(
      BuildContext context, ProfilePutRequest request2) async {
    try {
      var dio = await getApi();

      Response response = await dio.put("/user/profile", data: request2);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      PutActionLikeResponse objectResponse =
          PutActionLikeResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Upload Profile Pic Api Method
  static Future<LoginResponse> updateProfileImage(
      BuildContext context, File profilePic,
      {CancelToken cancelToken}) async {
    try {
      DialogUtils.showProgress(context);
      var dio = await getApi();

      String fileNameWithExtension =
          "${DateTimeUtils().currentMillisecondsSinceEpoch()}.jpg";

      var uploadFilesData = MultipartFile.fromBytes(profilePic.readAsBytesSync(), filename: fileNameWithExtension);

      FormData formData;
      if (uploadFilesData != null) {

        formData = new FormData.fromMap({
          // Pass multiple files within an Array
          "image": uploadFilesData
        });
      }

      if (formData != null) {
        Response response = await dio.put("/user/profile/image",
            data: formData,
            onSendProgress: (int sent, int total) {},
            cancelToken: cancelToken);
        DialogUtils.hideProgress(context);
        String responseOfApi = response.toString();

        Map<String, dynamic> user = json.decode(responseOfApi);

        LoginResponse objectResponse = LoginResponse.fromJson(user);
        if (objectResponse.isSuccess()) {
          await SharedPrefUtil.saveLoginData(objectResponse);
        }
        return objectResponse;
      }
    } catch (e) {
      PrintUtils.printLog("Munish Error updateProfileImage() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error updateProfileImage() END");
    }
    return null;
  }

  /// Delete Profile Pic Api Method
  static Future<LoginResponse> removeProfileImage(BuildContext context) async {
    try {
      DialogUtils.showProgress(context);
      var dio = await getApi();

      Response response = await dio.delete("/user/profile/image");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      CommonResponse objectResponse = CommonResponse.fromJson(user);

      LoginResponse objectResponseLogin = await SharedPrefUtil.getLoginData();
      if (objectResponse.isSuccess()) {
        objectResponseLogin.data.picUrl = "";
        await SharedPrefUtil.saveLoginData(objectResponseLogin);
      }

      DialogUtils.hideProgress(context);
      return objectResponseLogin;
    } catch (e) {
      PrintUtils.printLog("Munish Error updateProfileImage() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error updateProfileImage() END");
    }
    return null;
  }

  static Future<String> getContent(
      RequestFilterContent request, int page) async {
    try {
      var dio = await getApi();

      String jsonFinalObject = json.encode(request);

      PrintUtils.printLog(
          "Hash Code of Content -> Page $page: ${jsonFinalObject.hashCode}");

      Response response = await dio.post(ApiHandlerUtils.getContentUrl(page),
          data: jsonFinalObject);
      String responseOfApi = response.toString();

      return responseOfApi;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Content Detail Api Method
  static Future<ContentDetailResponse> getContentDetailData(
      BuildContext context, int contentId) async {
    try {
      var dio = await getApi();

      Response response = await dio.get("/data/content/$contentId");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      ContentDetailResponse objectResponse =
          ContentDetailResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<String> getProfileContent(int page, String actionType) async {
    try {
      var dio = await getApi();

      Response response =
          await dio.get(ApiHandlerUtils.getProfileContentUrl(page, actionType));
      String responseOfApi = response.toString();

      return responseOfApi;
    } catch (e) {
      PrintUtils.printLog("Munish Error getProfileContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getProfileContent() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Get All Comments Api Method
  static Future<CommentPullResponse> getCommentPull(
      BuildContext context, int page, String contentId) async {
    try {
      var dio = await getApi();

      Response response =
          await dio.get("/data/comment/content/$contentId?page=$page&size=10");
      //Response response = await dio.get("/data/comment/content/$contentId");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      CommentPullResponse objectResponse = CommentPullResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getcommentPull() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getcommentPull() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Action (like , favorite ,  dislike , etc) Api Method
  static Future<ContentDetailResponse> putAction(
      BuildContext context, String actionType, int contentId) async {
    try {
      var dio = await getApi();

      Response response =
          await dio.put("/data/action/$actionType/content/$contentId");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      ContentDetailResponse objectResponse =
          ContentDetailResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContentTemp() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContentTemp() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<ActionContentListResponseTemp> getContentTemp(
      BuildContext context, int page) async {
    try {
      var dio = await getApi();
      dio.options.baseUrl = "http://dev-api-chatello.exitest.com/api/User";

      RequestFetchContent request = RequestFetchContent();
      request.pagination =
          RequestFetchContentPagination(page: page, pageSize: 10);

      Response response = await dio.post("/getusers", data: request);
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      ActionContentListResponseTemp objectResponse =
          ActionContentListResponseTemp.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContentTemp() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContentTemp() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<DescriptionAlgoApi> postDescriptionAlgoApi(
      BuildContext context, String url, {CancelToken cancelToken}) async {
    try {
      var dio = new Dio();
      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
      dio.options.baseUrl = "https://api.algorithmia.com/v1/";
      dio.options.headers = {
        KEY_AUTHORIZATION: 'Simple simnxB3dwTN8kds9p6SGMpGoOJC1 '
      };

      Response response = await dio
          .post("web/algo/outofstep/MegaAnalyzeURL/0.1.6/", data: "\"$url\"", cancelToken: cancelToken);
      String responseOfApi = response.toString();
      print("weblink response -> $responseOfApi");
      Map<String, dynamic> user = json.decode(responseOfApi);
      DescriptionAlgoApi objectResponse = DescriptionAlgoApi.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getContentTemp() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getContentTemp() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static getFormattedString(String value, [String formattedValue = "NA"]) {
    if (value == null) {
      return formattedValue;
    } else if (value.trim().length == 0) {
      return formattedValue;
    } else {
      return value;
    }
  }

  /// Get Profile Detail Api Method
  static Future<LoginResponse> getProfilePull(
    BuildContext context,
  ) async {
    try {
      //DialogUtils.showProgress(context);
      var dio = await getApi();

      Response response = await dio.get("/user/profile");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      LoginResponse objectResponseLogin = LoginResponse.fromJson(user);
      if (objectResponseLogin.isSuccess()) {
        await SharedPrefUtil.saveLoginData(objectResponseLogin);
      }

      return objectResponseLogin;
    } catch (e) {
      PrintUtils.printLog("Munish Error getcommentPull() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getcommentPull() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<DiscoverListResponse> getDiscoverLikeDownloadResponse(
    BuildContext context,
  ) async {
    try {
      //DialogUtils.showProgress(context);
      var dio = await getApi();
      var url = ApiHandlerUtils.getDiscoverUrl();

      Response response = await dio.get(url);
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      DiscoverListResponse objectResponse = DiscoverListResponse.fromJson(user);

      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error getcommentPull() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getcommentPull() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  /// Discover List Api Method
  static Future<String> getDiscoverListResponse(
    BuildContext context,
    String url,
  ) async {
    try {
      var dio = await getApi();

      Response response = await dio.get(url);
      String responseOfApi = response.toString();
/*

      Map<String, dynamic> user = json.decode(responseOfApi);

      DiscoverListResponse objectResponse = DiscoverListResponse.fromJson(user);
*/

      DialogUtils.hideProgress(context);
      return responseOfApi;
    } catch (e) {
      PrintUtils.printLog("Munish Error getcommentPull() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error getcommentPull() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<UploadContentResponse> createContent(
      BuildContext context, UploadContentRequest request) async {
    try {
      var dio = await getApi();

      String jsonFinalObject = json.encode(request);

      Response response =
          await dio.post("/data/content/upload", data: jsonFinalObject);

      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      UploadContentResponse objectResponse =
          UploadContentResponse.fromJson(user);

      DialogUtils.hideProgress(context);

      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error createContent() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error createContent() END");
    }
    return null;
  }

  static Future<void> uploadContentNew(RequestUploadDataToServer requestUploadDataToServer) async {

    var contentId = requestUploadDataToServer?.contentId ?? -1;
    var serverUrl = "$BASE_URL/data/content/$contentId/upload";
    var uniqueUploadTag = contentId.toString() + Random().nextInt(1000).toString();
    var listOfFilesToUpload = requestUploadDataToServer?.requestDraftUploadData?.mapOfMediaMetaData?.values?.map((_fileInfo) {
      return _fileInfo;
    });

    List<FileItem> fileItems = List();
    listOfFilesToUpload?.forEach((_fileInfo) {
      var image = File(_fileInfo.mediaFilePath);
      if(image != null) {
        final String filename = basename(image.path);
        final String savedDir = dirname(image.path);
        var fileItem = FileItem(
          filename: filename,
          savedDir: savedDir,
          fieldname: "files",
        );

        fileItems.add(fileItem);
      }
    });

    var apiHeaders = await getHeaders();

    print("File Uploading -----Started------");
    print("serverUrl -> $serverUrl");
    var taskId = await appUploader.enqueue(
      url: serverUrl,
      files: fileItems,
      method: UploadMethod.POST,
      headers: apiHeaders,
      tag: uniqueUploadTag,
      showNotification: true,
    );

    requestUploadDataToServer.taskId = taskId;
    print("File Uploading -----END------");

    await SharedPrefUtilServerSyncUpload.updateUploadingTask(requestUploadDataToServer);
    print("");
  }

  /// Upload Content Api Method
  static Future<void> uploadContentStories(String contentId, String descriptionRichText,
      {CancelToken cancelToken}) async {
    try {
      var dio = await getApi();

      FormData formData = FormData.fromMap({
        // Pass multiple files within an Array
        "descriptions": descriptionRichText
      });


      if (formData != null) {
        Response response = await dio.post(
            "/data/content/$contentId/upload",
            data: formData, onSendProgress: (int sent, int total) {
          try {

          } catch (e) {
            PrintUtils.printLog("Exception -> $e");
          }
        }, cancelToken: cancelToken);

        String responseOfApi = response.toString();

        Map<String, dynamic> user = json.decode(responseOfApi);

        UploadContentResponse objectResponse =
        UploadContentResponse.fromJson(user);

        //DialogUtils.hideProgress(context);
        return objectResponse;
      }
    } catch (e) {

    }
    return null;
  }

  /// Report/ Hide Content Api Method
  static Future<ContentDetailResponse> reportContentHide(BuildContext context,
      String contentId, String reportId, String reportText) async {
    try {
      DialogUtils.showProgress(context);
      ReportRequest reportRequest = ReportRequest(
          contentId: contentId, reportId: reportId, reportText: "");

      var dio = await getApi();
      Response response =
          await dio.put("/data/content/report/hide", data: reportRequest);
      String responseOfApi = response.toString();
      Map<String, dynamic> user = json.decode(responseOfApi);

      ContentDetailResponse objectResponse =
          ContentDetailResponse.fromJson(user);
      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog(e);
    }
    DialogUtils.hideProgress(context);
    return null;
  }

  /// Post Call
  void postCall<T>(String subUrl, T t, onError(),
      {bool isCom = true,
      String msg = "Please wait ...",
      BuildContext context,
      onResult(Map<String, dynamic> res)}) async {
    if (isCom && context != null) {
      DialogUtils.showProgress(context, msg: msg);
    }
    String url = BASE_URL + subUrl;
    PrintUtils.printLog("Request url: $url : ");

    await http
        .post(
          url,
          body: t,
        )
        .timeout(_reqTimeOut)
        .catchError(() {}, test: (obj) {
      PrintUtils.printLog("error -> " + obj.toString());
      onError();
      return false;
    }).whenComplete(() {
      if (isCom && context != null) DialogUtils.hideProgress(context);
    }).then((response) {
      PrintUtils.printLog("Response Status: ${response.body}");
      Map<String, dynamic> user = json.decode(response.body);
      onResult(user);
    }).timeout(_resTimeOut);
  }

  void postResponseObject(String subUrl, Map<String, dynamic> requestData,
      {bool isProgressToShow = true,
      String msg = _progressMessage,
      BuildContext context,
      onResult(Map<String, dynamic> res),
      onError(e)}) async {
    _showProgressDialog(isProgressToShow, context, msg);

    var response;
    try {
      PrintUtils.printLog("requestData -> ${requestData.toString()}");
      var dio = await getApi();

      response = dio.post(subUrl, data: requestData);
    } on DioError catch (e) {
      onError(e);
    }

    _handleResponse(response, context, onResult);
  }

  void postResponseFormData(String subUrl, FormData formData,
      {bool isProgressToShow = true,
      String msg = _progressMessage,
      BuildContext context,
      onResult(Map<String, dynamic> res),
      onError(e)}) async {
    _showProgressDialog(isProgressToShow, context, msg);

    var response;
    try {
      var dio = await getApi();
      response = dio.post(subUrl, data: formData);
    } on DioError catch (e) {
      onError(e);
    }

    _handleResponse(response, context, onResult);
  }

  void getResponse(String subUrl,
      {bool isProgressToShow = true,
      String msg = _progressMessage,
      BuildContext context,
      onResult(Map<String, dynamic> res),
      onError(e)}) async {
    _showProgressDialog(isProgressToShow, context, msg);

    var response;
    try {
      var dio = await getApi();
      response = dio.get(subUrl);
    } on DioError catch (e) {
      onError(e);
    }

    _handleResponse(response, context, onResult);
  }

  void _handleResponse(
      response, BuildContext context, onResult(Map<String, dynamic> res)) {
    response.whenComplete(() {
      _hideProgressDialog(context);
    }).then((response) {
      onResult(response.data);
    });
  }

  void _showProgressDialog(
      bool isProgressToShow, BuildContext context, String msg) {
    if (isProgressToShow && context != null) {
      DialogUtils.showProgress(context, msg: msg);
    }
  }

  void _hideProgressDialog(BuildContext context) {
    if (context != null) {
      DialogUtils.hideProgress(context);
    }
  }

  /* log out api */

  static Future<LogOutResponse> getUserLogOut(
    BuildContext context,
  ) async {
    try {
      var dio = await getApi();

      Response response = await dio.get("/user/logout");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      LogOutResponse objectResponse = LogOutResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error LogOut() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error LogOut() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  //Clear History
  static Future<ClearHistoryResponse> getClearHistory(
    BuildContext context,
  ) async {
    try {
      var dio = await getApi();

      Response response =
          await dio.get("/data/content/history/clean?isVerified=true");
      String responseOfApi = response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      ClearHistoryResponse objectResponse = ClearHistoryResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error LogOut() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error LogOut() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  //Notification
  static Future<NotificationResponse> getNotification(
    BuildContext context,
  ) async {
    try {
      var dio = await getApi();
      Response response = await dio.get("/data/content/notifications/all");
      String responseOfApi = response.toString();
      Map<String, dynamic> user = json.decode(responseOfApi);
      NotificationResponse objectResponse = NotificationResponse.fromJson(user);

      DialogUtils.hideProgress(context);
      return objectResponse;
    } catch (e) {
      PrintUtils.printLog("Munish Error LogOut() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error LogOut() END");
    }
    //DialogUtils.hideProgress(context);
    return null;
  }

  static Future<DeletePostResponse> getDeletePost(
      BuildContext context, int contentId) async {
    DialogUtils.showProgress(context);
    try {
      var dio = await getApi();
      Response response = await dio.delete("/data/content/$contentId");
      String responseOfApi = response.toString();
      Map<String, dynamic> user = json.decode(responseOfApi);
      DeletePostResponse objectResponse = DeletePostResponse.fromJson(user);

      DialogUtils.hideProgress(context);

      return objectResponse;
    } catch (e) {

      DialogUtils.hideProgress(context);

      PrintUtils.printLog("Munish Error deletePost() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error deletePost() END");
    }
    return null;
  }

  /// Get IP Details from Server
  static Future<IpCountryResponse> getIpResponse({bool isForceRefresh = false}) async {

    bool isMetaCanLoad = false;
    if (isForceRefresh) {
      isMetaCanLoad = isForceRefresh;
    } else {
      var isSync = await SharedPrefUtil.isMetaDataSync(AppMetaDataType.IpData);
      isMetaCanLoad = !isSync;
    }

    if (isMetaCanLoad) {
      try {
        var dio = await getApiFromUrl(_IP_URL);

        Response response = await dio.get("/Request");

        String parseResponse = response.toString();

        Map<String, dynamic> user = json.decode(parseResponse);

        IpCountryResponse responseObject = IpCountryResponse.fromJson(user);

        await SharedPrefUtil.saveAppIPData(responseObject);

        return responseObject;
      } catch (e) {
        PrintUtils.printLog(e);
      }
    } else {
      return await SharedPrefUtil.getAppIPData();
    }
    return null;
  }


  static Future<CommonResponse> verifyQrCode(String qrCode, {BuildContext context}) async {
    //DialogUtils.showProgress(context);
    try {
      var dio = await getApi();
      _api.options.headers[KEY_X_QR_CODE] = qrCode;

      Response response = await dio.get("/user/QR/code/verify");
      String responseOfApi = response.toString();
      Map<String, dynamic> user = json.decode(responseOfApi);
      CommonResponse objectResponse = CommonResponse.fromJson(user);

      //DialogUtils.hideProgress(context);

      return objectResponse;
    } catch (e) {

      //DialogUtils.hideProgress(context);

      PrintUtils.printLog("Munish Error deletePost() START");
      PrintUtils.printLog(e);
      PrintUtils.printLog("Munish Error deletePost() END");
    }
    return null;
  }

}
