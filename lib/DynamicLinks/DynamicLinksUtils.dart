
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/DialogUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class DynamicLinksUtils {

  final _URL_KEY_CONTENT = "content";
  final _URL_KEY_DISCOVER = "discover";
  final _URL_KEY_LOGIN_OTP = "loginOtp";

  void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          final String deepLinkString = deepLink.toString();

          if(deepLinkString.contains(_URL_KEY_CONTENT)) {
            handleContentFound(context, deepLinkString);
          } else if(deepLinkString.contains(_URL_KEY_DISCOVER)) {
            handleDiscoverFound(context, deepLinkString);
          } else if(deepLinkString.contains(_URL_KEY_LOGIN_OTP)) {
            _handleLoginViaOtpFound(context, deepLinkString);
          }

        }, onError: (OnLinkErrorException e) async {
      PrintUtils.printLog('onLinkError');
      PrintUtils.printLog(e.message);
    });
  }

  void _handleLoginViaOtpFound(BuildContext context, String deepLinkString) async {
    try {
      String otpEncryptedString = deepLinkString.substring(deepLinkString.indexOf(_URL_KEY_LOGIN_OTP) + (_URL_KEY_LOGIN_OTP?.length ?? 0) + 1);
      if (deepLinkString != null) {
        var otpResponse = await ApiHandler.validateOTPEncrypted(context, otpEncryptedString);

        _handleLoginResponse(context, otpResponse);
      }
    } catch(e){
      PrintUtils.printLog("Exception -> handleContentFound() ${e.toString()}");
    }
  }

  void _handleLoginResponse(BuildContext context, LoginResponse parsedResponse) {

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var accountBloc = ApplicationBlocProvider.ofAccountBloc(context);

    accountBloc.handleLoginResponseMobileOtpFlow(
      context,
      parsedResponse,
      scaffoldKey: _scaffoldKey,
      otpVerificationFlow: OtpVerificationFlow.login,
      isNeedToFinish: true,
    );
  }

  void handleContentFound(BuildContext context, String deepLinkString) {
    try {
      String contentId = deepLinkString.substring(deepLinkString.indexOf(_URL_KEY_CONTENT) + (_URL_KEY_CONTENT?.length ?? 0) + 1);
      if (deepLinkString != null) {
        NavigatorUtils.handleContentCardWithId(context, contentId);

        //Navigator.pushNamed(context, deepLink.path);
      }
    } catch(e){
      PrintUtils.printLog("Exception -> handleContentFound() ${e.toString()}");
    }
  }

  void handleDiscoverFound(BuildContext context, String deepLinkString) {
    try {
      String discoverId = deepLinkString.substring(deepLinkString.indexOf(_URL_KEY_DISCOVER) + (_URL_KEY_DISCOVER?.length ?? 0) + 1);

    } catch(e){
      PrintUtils.printLog("Exception -> handleContentFound() ${e.toString()}");
    }
  }

  void _shareFile(String textToShare, String fileUrl, String mimeType, String fileExtension, {BuildContext context}) async {
    DialogUtils.showProgress(context, msg: "Sharing");
    try {
      var request = await HttpClient().getUrl(Uri.parse(fileUrl));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      await Share.file('Tymoff', 'tymoff.$fileExtension', bytes, mimeType, text: textToShare);
    } catch(e) {
      print("Munish Thakur -> shareTemp() -> Exception: ${e.toString()}");

      shareMedia(textToShare, context: context);
    }

    DialogUtils.hideProgress(context);
  }

  void shareContent(ActionContentData _contentData, {BuildContext context}) async {

    String textToShare = await getSharingText(_contentData);

    //shareText(textToShare);

    try {
      var typeId = _contentData.typeId;
      var type = ContentTypeUtils.getType(typeId);
      var contentUrls = _contentData.contentUrl;
      if (type == AppContentType.image) {
        if(isGif(contentUrls)) {
          shareMedia(textToShare, fileUrl: contentUrls[0].url, mime: "image/gif", context: context);
        } else {
          shareMedia(
              textToShare, fileUrl: getContentUrl(contentUrls), context: context);
        }
      } else if (type == AppContentType.video) {
        shareMedia(textToShare, fileUrl: getContentUrl(contentUrls), context: context);
      } else if (type == AppContentType.text) {
        shareMedia(textToShare, context: context);
      } else if (type == AppContentType.article) {
        shareMedia(textToShare, fileUrl: contentUrls[0].thumbnailImage, context: context);
      } else if (type == AppContentType.gif) {
        shareMedia(textToShare, fileUrl: contentUrls[0].url, context: context);
      }
    } catch(e){
      print("Munish Thakur -> shareContent() -> ${e.toString()}");
      shareMedia(textToShare, context: context);
    }
  }


  bool isGif(List<ContentUrlData> contentUrls) {
    var contentIsGif = false;
    if ((contentUrls?.length ?? 0) > 0) {
      if (getContentUrl(contentUrls).contains(".gif")) {
        contentIsGif = true;
      } else {
        contentIsGif = false;
      }
    }
    return contentIsGif;
  }

  String getContentUrl(List<ContentUrlData> contentUrls) {
    String contentUrl = "";
    try {
      contentUrl = contentUrls[0].thumbnailImage;
      if(contentUrl == null) {
        contentUrl = contentUrls[0].url;
      } else if((contentUrl?.trim()?.length ?? 0) <= 0) {
        contentUrl = contentUrls[0].url;
      }
    } catch(e){

    }

    return contentUrl;
  }

  Future<void> copyLinkToClipboard(BuildContext context, ActionContentData _contentData) async {
    String textToShare = await getSharingText(_contentData);
    await Clipboard.setData(ClipboardData(text: textToShare));

    Navigator.pop(context);
    ToastUtils.show(Strings.linkIsCopied);
    AnalyticsUtils?.analyticsUtils?.eventCopylinkButtonClicked();
  }

  Future<String> getSharingText(ActionContentData _contentData) async {
    String sharingUrl = "";
    if((_contentData?.sharingUrl?.length ?? 0) > 0) {
      sharingUrl = _contentData.sharingUrl;
      PrintUtils.printLog("Munish -> shareContent() -> Already Link Available (Will Not Take Time)");
    } else {

      /*Future.delayed(Duration(seconds: 1), () {
        DialogUtils.showProgress(context, msg: "Content getting ready..");
      });*/

      sharingUrl = await getShortDynamicUrlFromContent(_contentData);
      PrintUtils.printLog("Munish -> shareContent() -> Link Generated On the Go (Take Time)");
    }

    String shareContentTitle = _contentData?.contentTitle ?? "";

    String textToShare = "Let's take some tymoff\n$shareContentTitle\n$sharingUrl";
    return textToShare;
  }

  String getShareContentLink(ActionContentData contentData) => 'https://www.tymoff.com/$_URL_KEY_CONTENT/${contentData?.id?.toString() ?? 0}';

  // TEMP CODE - MUNISH THAKUR (Needs to remove and uncomment above getShareContentLink() method)
  //String getShareContentLink(ActionContentData contentData) => 'https://www.tymoff.com/$_URL_KEY_LOGIN_OTP/l4qvCdZLzCYaFu-MROZUgg==}';

  void shareDiscover(String discoverName) async {
    String linkUrl = 'https://www.tymoff.com/discover/$discoverName';
    String sharingUrl = await createDynamicLink(linkUrl, isShort: true);

    shareMedia(sharingUrl);
    //Share.share("Munish Sharing tymoff URL -> $sharingUrl", "");
  }

  void shareMedia(String textToShare, {String fileUrl, String mime, BuildContext context}) async {

    if(fileUrl != null) {
      _shareFile(textToShare, fileUrl, _getMimeType(mime, "image/jpg"), _getFileType(fileUrl), context: context);
    } else {
      Share.text('tymoff', textToShare, _getMimeType(mime, "text/plain"));
    }
  }

  String _getMimeType(String mimeToCheck, String defaultMime) {
    return ((mimeToCheck?.trim()?.length ?? 0) > 0) ? mimeToCheck : defaultMime;
  }

  String _getFileType(String fileUrl) {
    String fileExtension = "jpg";
    try {
      fileExtension = fileUrl.substring(fileUrl.lastIndexOf(".") + 1, fileUrl.length);
    } catch(e) {
      PrintUtils.printLog("Munish Thakur -> _getFileType() -> Exception -> $e");
    }
    return fileExtension;
  }

  Future<String> getShortDynamicUrlFromContent(ActionContentData _contentData) async {

    try {
      String linkUrl = getShareContentLink(_contentData);
      String sharingUrl = await createDynamicLink(linkUrl, isShort: true);

      return sharingUrl;
    } catch(e){
      PrintUtils.printLog("Munish -> getShortDynamicUrlFromContent() -> ID: ${_contentData.id}, error: ${e.toString()}");
      return null;
    }
  }

  Future<String> createDynamicLink(String linkUrl, {bool isShort = false}) async {

    var dynamicLinkFromSP = await SharedPrefUtil.getDynamicLinksFromCache(linkUrl);

    if(dynamicLinkFromSP != null) {
      //PrintUtils.printLog("Got Dynamic link from SP -> \n\t\tlinkUrl -> $linkUrl, \n\t\tdynamicLink -> $dynamicLinkFromSP");
      return dynamicLinkFromSP;
    }

    final _androidFallbackUri =  getAndroidCallback();
    final _iosFallbackUri =  getIosCallback();

    final _mobileFallbackUri = Uri.parse(linkUrl);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://dl.tymoff.com',
      link: Uri.parse(linkUrl),
      androidParameters: AndroidParameters(
        packageName: 'com.tymoff',
        minimumVersion: 0,
        fallbackUrl: _mobileFallbackUri,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tymoff',
        minimumVersion: '0',
        appStoreId: '1486021014',
        fallbackUrl: _mobileFallbackUri
      ),
    );

    var dynamicLink = await dynamicLinkUrl(isShort, parameters);
    await SharedPrefUtil.saveDynamicLinksCacheMap(linkUrl, dynamicLink);

    return dynamicLink;
  }

  Uri getIosCallback() {
    final _authorityAndroid = "play.google.com";
    final _pathAndroid = "/store/apps/details";
    final _paramsAndroid = { "id" : "com.tymoff" };
    return Uri.https(_authorityAndroid, _pathAndroid, _paramsAndroid);
  }

  Uri getAndroidCallback() {
    final _authorityIos = "apps.apple.com";
    final _pathIos = "/cn/app/týmoff/id1486021014";
    return Uri.https(_authorityIos, _pathIos);
  }


  Uri getIosToWebUrlCallback() {
    final _authorityAndroid = "play.google.com";
    final _pathAndroid = "/store/apps/details";
    final _paramsAndroid = { "id" : "com.tymoff" };
    return Uri.https(_authorityAndroid, _pathAndroid, _paramsAndroid);
  }

  Uri getAndroidToWebUrlCallback() {
    final _authorityIos = "apps.apple.com";
    final _pathIos = "/cn/app/týmoff/id1486021014";
    return Uri.https(_authorityIos, _pathIos);
  }

  Future<String> dynamicLinkUrl(bool isShort, DynamicLinkParameters parameters) async {


    // TEMP CODE - MUNISH THAKUR (isShort = false;) should be removed
    //isShort = false;

    Uri url;
    if (isShort) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    //PrintUtils.printLog("Dynamic Link Generated -> ${url.toString()}");
    return url.toString();
  }
}