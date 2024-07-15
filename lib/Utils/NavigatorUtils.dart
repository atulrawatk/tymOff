import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/CommentBloc.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/AppOTPScreenChecker.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Account/LoginOtpValidation.dart';
import 'package:tymoff/Screens/Account/LoginViaMobile.dart';
import 'package:tymoff/Screens/Account/SelectUserName.dart';
import 'package:tymoff/Screens/Account/TempOtp.dart';
import 'package:tymoff/Screens/CardDetail/CardDetailPage.dart';
import 'package:tymoff/Screens/CardDetail/CommentFullScreen.dart';
import 'package:tymoff/Screens/CardDetail/FullScreenDialogForText.dart';
import 'package:tymoff/Screens/DiscoverScreens/DiscoverCommonUI.dart';
import 'package:tymoff/Screens/DiscoverScreens/DiscoverPageViewUI.dart';
import 'package:tymoff/Screens/Home/Dashboard.dart';
import 'package:tymoff/Screens/Others/Settings.dart';
import 'package:tymoff/Screens/Others/ViewFullScreenImage.dart';
import 'package:tymoff/Screens/Others/ViewFullScreenProfileImage.dart';
import 'package:tymoff/Screens/ProfileScreen/EditProfile.dart';
import 'package:tymoff/Screens/QR/QRScan.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterVideoMeta.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/PhotoFilterUtils/MultiplePhotoFilters.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Screen/UploadViewFullScreenVideo.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Screen/ViewFullScreenImageWithFilter.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadContentScreen.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilDraftUpload.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';

import 'OpenArticleWebView.dart';
import 'OpenWebView.dart';

class NavigatorUtils {
  static LoginViaMobile getLoginScreen({isNeedToFinish: true}) {
    return LoginViaMobile(
      isNeedToFinish: false,
    );
  }

  static void moveToLoginScreen(BuildContext context,
      {bool isForceResetOtpFlowScreen}) async {
    if (isForceResetOtpFlowScreen != null && isForceResetOtpFlowScreen) {
      await SharedPrefUtil.saveShowOTPScreenMeta(null);
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginViaMobile()));
  }

  static void moveToOTPValidationScreen(BuildContext context,
      {LoginResponse loginResponse, OtpVerificationFlow otpVerificationFlow}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EnterOtpTemp(
                loginResponse: loginResponse,
                otpVerificationFlow: OtpVerificationFlow.forgot_password)));
  }

  static void moveToLoginOTPValidationScreen(
      BuildContext context, String countryCode, String loginNumber) async {
    var otpScreenMeta = AppOTPScreenChecker(loginNumber, countryCode);
    await SharedPrefUtil.saveShowOTPScreenMeta(otpScreenMeta);

    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginOtpValidation(countryCode, loginNumber)));
  }

  static void moveToDashBoard(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  static void pushNamedDashBoard(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  static void moveToDashBoardTemp(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
  }

  static void navigateToWebPage(
      BuildContext context, String title, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OpenWebPage(contentTitle: title, url: url)));
  }

  static void handleContentCardWithId(BuildContext context, String contentId) {
    final List<ActionContentData> content = List();

    ActionContentData actionContentData =
        ActionContentData(id: int.parse(contentId));
    content.add(actionContentData);

    NavigatorUtils.moveToContentDetailScreen(context, null, content, 0);
  }

  static void handleContentCardWithData(
      BuildContext context, ActionContentData contentData) {
    final List<ActionContentData> content = List();

    content.add(contentData);

    NavigatorUtils.moveToContentDetailScreen(context, null, content, 0);
  }

  static void moveToContentDetailScreen(BuildContext context,
      ContentBloc _blocContent, List<ActionContentData> content, int index) {
   /* Navigator.push(context,
        ScaleRoute(page: CardDetailPage(_blocContent, content, index)));*/
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                CardDetailPage(_blocContent, content, index)));
  }

  static void moveToContentDiscoverScreen(
      BuildContext context, int discoverId, String discoverTitle) async {
    bool isLoginRequire = AppUtils.isDiscoverNeedLogin(discoverId);
    bool _isLogin = await SharedPrefUtil.isLogin();

    if (isLoginRequire && !_isLogin) {
      moveToLoginScreen(context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DiscoverCommonUI(discoverTitle, discoverId)));
    }
  }

  static void moveToPagerContentDiscoverScreen(
      BuildContext context,
      int discoverId,
      List<DiscoverListData> discoverListAllDiscoverList) async {
    bool isLoginRequire = AppUtils.isDiscoverNeedLogin(discoverId);
    bool _isLogin = await SharedPrefUtil.isLogin();

    if (isLoginRequire && !_isLogin) {
      moveToLoginScreen(context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DiscoverPageViewUI(discoverId, discoverListAllDiscoverList)));
    }
  }

  static void moveToSettingsScreen(BuildContext context) async {

    var timeTakeABreakPopupDetail = await SharedPrefUtil.getAppTakeBreakReminder();
    var timeContentScrollTimerPopupDetail = await SharedPrefUtil.getAppContentScrollTimer();

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Settings(timeTakeABreakPopupDetail: timeTakeABreakPopupDetail, timeContentScrollTimerPopupDetail: timeContentScrollTimerPopupDetail,)));
  }

  static void moveToCommentsScreen(
      BuildContext context, String cardDetailDataId, CommentBloc _commentBloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              CommentFullScreen(cardDetailDataId, _commentBloc),
        ));
  }

  static void moveToImageFullScreen(BuildContext context, String imageFileUrl) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                ViewFullScreenImage(imageFileUrl)));
  }

  static void moveToProfileImageFullScreen(
      BuildContext context, String imageFileUrl) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                ViewFullScreenProfileImage(imageFileUrl)));
  }

  static void moveToEditUserScreen(BuildContext context) {
    Navigator.push(context,
        CupertinoPageRoute(builder: (BuildContext context) => EditProfile()));
  }

  static void moveToEditUserScreenLoginFlow(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => SelectedUserName()));
  }

  static void moveToFullScreenDialogForText(
      BuildContext context, ActionContentData cardDetailData) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                FullScreenDialogForText(cardDetailData)));
  }

  static void moveToOpenWebView(
      BuildContext context, ActionContentData cardDetailData) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                OpenArticleWebView(cardDetailData)));
  }

  static Future<List<FilterImageMeta>> navigateToPhotoFilterSingle(
      BuildContext context, FilterImageMeta _imageMetaData) async {
    Map<String, FilterImageMeta> imagesMetaData = Map();
    imagesMetaData[_imageMetaData.mediaFileName] = (_imageMetaData);

    return navigateToPhotoFilter(context, imagesMetaData);
  }

  static Future<List<FilterImageMeta>> navigateToPhotoFilter(
      BuildContext context, Map<String, FilterImageMeta> imagesMetaData) async {
    Map imageFilesReturned = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) =>
            MultiplePhotoFilters.getPhotoFilter(imagesMetaData),
      ),
    );

    return _handleFilteredImageMap(imageFilesReturned);
  }

  static Future<List<FilterImageMeta>> navigateToFillScreenWithFilterOption(
      BuildContext context, FilterImageMeta _imageMetaData) async {
    Map imageFilesReturned = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                ViewFullScreenImageWithFilter(_imageMetaData)));

    return _handleFilteredImageMap(imageFilesReturned);
  }

  static List<FilterImageMeta> _handleFilteredImageMap(Map imageFilesReturned) {
    if (imageFilesReturned != null &&
        imageFilesReturned
            .containsKey(MultiplePhotoFilters.KEY_RESPONSE_FILTERED_IMAGES)) {
      List<FilterImageMeta> imageFiles =
          imageFilesReturned[MultiplePhotoFilters.KEY_RESPONSE_FILTERED_IMAGES];

      return imageFiles;
    } else {
      return null;
    }
  }

  static void navigateToVideoFullScreen(
      BuildContext context, FilterVideoMeta _mediaMetaData) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                UploadViewFullScreenVideo(_mediaMetaData)));
  }

  static void saveUploadDataToDraftAndNavigateToDraftUploadContentScreen(
      BuildContext context, RequestDraftUploadData requestUploadDataToServer) async {
    if(requestUploadDataToServer != null) {
      await SharedPrefUtilDraftUpload.queueDraftUploadContent(requestUploadDataToServer);
    }

    navigateToDraftUploadContentScreen(context);
  }

  static void navigateToDraftUploadContentScreen(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => UploadContentScreen()));
  }

  static void navigateToWidget(BuildContext context, Widget widget) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => widget));
  }

  static void navigateToQrScan(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => QRScan()));
  }

}
