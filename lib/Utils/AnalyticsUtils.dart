import 'dart:collection';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsUtils {
  static AnalyticsUtils analyticsUtils = AnalyticsUtils();
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);
  //static AppsflyerSdk appflyerSdk;


  static Map options = { "afDevKey": "GwaPpHPQcpTuyWBBrJb7vK",
    "afAppId": "com.collectcent.tymoff",
    "isDebug": false};

  static AppsflyerSdk appsflyerSdk = AppsflyerSdk(options);

  void init() {
    //initAppFlyer();
  }

  Map _getAppflyerMap({HashMap values}) {
    if (values == null) {
      values = HashMap();
      values["dummyKey1"] = "dummyValue1";
    }
    return values;
  }

  void logAppOpen() {
    try {
      _analytics?.logAppOpen();
    } catch (e) {}
  }

  void _loginInButtonClicked({String loginMethod}) {
    try {
      _analytics?.logLogin(loginMethod: loginMethod);
      appsflyerSdk?.trackEvent(loginMethod, _getAppflyerMap());
    } catch (e) {}
  }

  void _signUpButtonClicked({String signUpMethod}) {
    try {
      _analytics?.logSignUp(signUpMethod: signUpMethod);

      appsflyerSdk?.trackEvent(signUpMethod, _getAppflyerMap());
    } catch (e) {}
  }

  void _eventButtonClicked({String eventMethod, HashMap values}) {
    try {
      _analytics?.logEvent(name: eventMethod);

      appsflyerSdk?.trackEvent(eventMethod, _getAppflyerMap(values: values));

      print("Analytics _eventButtonClicked -> $eventMethod");
    } catch (e) {}
  }

  void loginInGoogleButtonClicked() {
    _loginInButtonClicked(loginMethod: "Google Social Login");
  }

  void loginInFacebookButtonClicked() {
    _loginInButtonClicked(loginMethod: "Facebook Social Login");
  }

  void loginInSimpleButtonClicked() {
    _loginInButtonClicked(loginMethod: "Simple Login");
  }

  void signUpSimpleButtonClicked() {
    _signUpButtonClicked(signUpMethod: "Simple Signup");
  }

  void eventShareButtonClicked() {
    _eventButtonClicked(eventMethod: " Share");
  }

  void eventReportButtonClicked() {
    _eventButtonClicked(eventMethod: " Reporting the Content");
  }

  void eventDownloadButtonClicked() {
    _eventButtonClicked(eventMethod: " Downloading the Content");
  }

  void eventCopylinkButtonClicked() {
    _eventButtonClicked(eventMethod: " Copy link");
  }

  void eventHidepostButtonClicked() {
    _eventButtonClicked(eventMethod: "Hide Post");
  }

  void eventlikeButtonClicked() {
    _eventButtonClicked(eventMethod: "like Post");
  }

  void eventSuperlikeButtonClicked() {
    _eventButtonClicked(eventMethod: "Superlike Post");
  }

  void eventContentdetailscreenButtonClicked() {
    _eventButtonClicked(eventMethod: "Content detail screen");
  }

  void eventSearchButtonClicked() {
    _eventButtonClicked(eventMethod: "Search");
  }

  void eventUploadButtonClicked() {
    _eventButtonClicked(eventMethod: "Upload button");
  }

  void eventUploadtextButtonClicked() {
    _eventButtonClicked(eventMethod: "Upload text");
  }

  void eventUploadvideoButtonClicked() {
    _eventButtonClicked(eventMethod: "Upload Video");
  }

  void eventUploadweblinkButtonClicked() {
    _eventButtonClicked(eventMethod: "Upload Weblink");
  }

  void eventUploadimagesButtonClicked() {
    _eventButtonClicked(eventMethod: "Upload Images");
  }

  void eventGenreButtonClicked() {
    _eventButtonClicked(eventMethod: "Genre");
  }

  void eventLanguageButtonClicked() {
    _eventButtonClicked(eventMethod: "Language");
  }

  void eventDiscovercontentButtonClicked() {
    _eventButtonClicked(eventMethod: "Discover Content");
  }

  void eventEditprofileButtonClicked() {
    _eventButtonClicked(eventMethod: "Edit profile");
  }

  void eventProfilesettingButtonClicked() {
    _eventButtonClicked(eventMethod: "Edit profile");
  }

  void eventSaveEditProfileButtonClicked() {
    _eventButtonClicked(eventMethod: " Save Edit profile");
  }

  void eventClearhistoryButtonClicked() {
    _eventButtonClicked(eventMethod: " Clear history");
  }

  void eventClearhistoryOkButtonClicked() {
    _eventButtonClicked(eventMethod: " Clear history ok button");
  }

  void eventClearhistorycancelButtonClicked() {
    _eventButtonClicked(eventMethod: " Clear history cancel");
  }

  void eventAboutButtonClicked() {
    _eventButtonClicked(eventMethod: " About");
  }

  void eventPrivacyPolicyButtonClicked() {
    _eventButtonClicked(eventMethod: "Privacy policy");
  }

  void eventFeedbackButtonClicked() {
    _eventButtonClicked(eventMethod: "Feedback");
  }

  void eventFeedbackSubmitButtonClicked() {
    _eventButtonClicked(eventMethod: "Feedback Submit");
  }

  void eventTermsandConditionButtonClicked() {
    _eventButtonClicked(eventMethod: "Terms and Condition");
  }

  void eventUseragreementButtonClicked() {
    _eventButtonClicked(eventMethod: "User agreement");
  }

  void eventEnterOTPProceedButtonClicked() {
    _eventButtonClicked(eventMethod: "Enter OTP Proceed Button");
  }

  void eventResendOTPButtonClicked() {
    _eventButtonClicked(eventMethod: "Resend OTP");
  }

  void eventForgotPasswordButtonClicked() {
    _eventButtonClicked(eventMethod: "Forgot Password");
  }

  void eventSendOTPButtonClicked() {
    _eventButtonClicked(eventMethod: "Send otp in email id");
  }
}
