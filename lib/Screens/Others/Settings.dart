/*import 'package:app_settings/app_settings.dart';*/
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
/*import 'package:qrscan/qrscan.dart' as scanner;*/
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/ThemeBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/AppSetContentScrollTimer.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/Others/CustomNumberPicker.dart';
import 'package:tymoff/Screens/Others/Feedback.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/CustomWidgetScrollTimerAlert.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';

class Settings extends StatefulWidget {
  AppTakeBreakReminder timeTakeABreakPopupDetail = AppTakeBreakReminder();
  AppSetContentScrollTimer timeContentScrollTimerPopupDetail =
      AppSetContentScrollTimer();

  Settings(
      {this.timeTakeABreakPopupDetail, this.timeContentScrollTimerPopupDetail});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AccountBloc accountBloc;
  ThemeBloc themeBloc;
  var restrictedMode = false;

  Future<bool> _permissionStatusFuture;

  AppTakeBreakReminder _timeTakeABreakPopupDetail = AppTakeBreakReminder();
  AppSetContentScrollTimer _timeContentScrollTimerPopupDetail =
      AppSetContentScrollTimer();

  @override
  void initState() {
    super.initState();
    triggerObservers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void triggerObservers() {
    if (widget.timeTakeABreakPopupDetail != null) {
      this._timeTakeABreakPopupDetail = widget.timeTakeABreakPopupDetail;
    }
    if (widget.timeContentScrollTimerPopupDetail != null) {
      this._timeContentScrollTimerPopupDetail =
          widget.timeContentScrollTimerPopupDetail;
    }

    WidgetsBinding.instance.addObserver(this);
    _permissionStatusFuture = getCheckNotificationPermStatus();
    _checkRestrictedModeState();
    _setUITakeABreak();
    _setUIScontentScrollTimer();
  }

  AppLifecycleState _appLifecycleState;

  // TODO: DID_CHANGE_APP_LIFE_CYCLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
      if (_appLifecycleState == AppLifecycleState.paused ||
          _appLifecycleState == AppLifecycleState.inactive) {
      } else if (state == AppLifecycleState.resumed) {
        setState(() {
          _permissionStatusFuture = getCheckNotificationPermStatus();
        });
      } else {}
    });
  }

  /// Checks the notification permission status
  Future<bool> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.granted:
          return true;
        default:
          return false;
      }
    });
  }

  var darkTheme = false;

  getThemeFromSharedPref() async {
    final appTheme = await SharedPrefUtil.getTheme();
    if (appTheme != null) {
      if (appTheme == ThemeModel.THEME_LIGHT) {
        setState(() {
          darkTheme = false;
        });
      } else {
        setState(() {
          darkTheme = true;
        });
      }
    }
  }

  _checkRestrictedModeState() async {
    var isRestrictedMode = await SharedPrefUtil.getRestrictedMode();
    if (isRestrictedMode != null) {
      if (isRestrictedMode) {
        setState(() {
          restrictedMode = true;
          PrintUtils.printLog("RestrictedMode is -> $restrictedMode");
        });
      } else {
        setState(() {
          restrictedMode = false;
          PrintUtils.printLog("RestrictedMode is -> $restrictedMode");
        });
      }
    }
  }

  // Clear History

  hitClearHistory(BuildContext context) async {
    var _getClearHistoryResponse = await ApiHandler.getClearHistory(context);
    if (_getClearHistoryResponse.statusCode == 200) {
      SnackBarUtil.show(
          _scaffoldKey, Strings.clearHistoryWhenApiIsSuccessfullyHit);
      PrintUtils.printLog("Clear History api hit successfully");
    } else {
      SnackBarUtil.show(_scaffoldKey, "Somthing went wrong");
    }
  }

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    themeBloc = ApplicationBlocProvider.ofThemeBloc(context);
    getThemeFromSharedPref();
    super.didChangeDependencies();
  }

  void _contentScrollTimerChangeEvent() {
    try {
      final AppTakeBreakReminder timePopupDetail =
          CustomWidgetScrollTimerAlert().showPickerNumberFormatValue(
              context, _timeContentScrollTimerPopupDetail, (selectedValue) {
        var appContentTimerSelection =
            AppSetContentScrollTimer(seconds: selectedValue);
        _handleContentScrollTimerSelection(appContentTimerSelection);
      });
      PrintUtils.printLog("Selected -> $timePopupDetail");
    } catch (e) {
      PrintUtils.printLog("Exception in take a break show dialog -> $e");
    }
  }

  Future _takeABreakClickEvent() async {
    try {
      final AppTakeBreakReminder timePopupDetail =
          await CustomWidgetTakeBreakAlertTemp().showPickerNumberFormatValue(
              context, _timeTakeABreakPopupDetail, (hour, minutes) {
        var appTakeBreakReminder =
            AppTakeBreakReminder(hour: hour, minutes: minutes);
        _handleTakeABreakSelection(appTakeBreakReminder);
      });
      _handleTakeABreakSelection(timePopupDetail);
      PrintUtils.printLog("Selected -> $timePopupDetail");
    } catch (e) {
      PrintUtils.printLog("Exception in take a break show dialog -> $e");
    }
  }

  String _getSubTitleAppTakeABreakReminderTimer() {
    String subTitle = "Off";

    if (_timeTakeABreakPopupDetail != null &&
        _timeTakeABreakPopupDetail.hour != null &&
        _timeTakeABreakPopupDetail.minutes != null &&
        (_timeTakeABreakPopupDetail.hour > 0 ||
            _timeTakeABreakPopupDetail.minutes > 0)) {
      subTitle =
          "Every ${_timeTakeABreakPopupDetail.hour} hours ${_timeTakeABreakPopupDetail.minutes} minutes";
    }
    return subTitle;
  }

  String _getSubTitleAppContentScrollTimer() {
    String subTitle = "Off";

    if ((_timeContentScrollTimerPopupDetail?.seconds ?? 0) > 0) {
      subTitle =
          "Content detail would scroll every ${_timeContentScrollTimerPopupDetail.seconds} seconds";
    }
    return subTitle;
  }

  void _handleTakeABreakSelection(AppTakeBreakReminder timePopupDetail) async {
    if (timePopupDetail != null) {
      await SharedPrefUtil.saveAppTakeBreakReminder(timePopupDetail);

      await _setUITakeABreak();

      EventBusUtils.eventTakeABreak_Set();
    }
  }

  void _setUITakeABreak() {
    SharedPrefUtil.getAppTakeBreakReminder().then((appBreakTimerObject) {
      appBreakTimerObject.notifyChange();
      this._timeTakeABreakPopupDetail = appBreakTimerObject;
      AppUtils.refreshCurrentState(this);
    });
  }

  void _handleContentScrollTimerSelection(
      AppSetContentScrollTimer timePopupDetail) async {
    if (timePopupDetail != null) {
      await SharedPrefUtil.saveAppContentScrollTimer(timePopupDetail);

      await _setUIScontentScrollTimer();
    }
  }

  void _setUIScontentScrollTimer() {
    SharedPrefUtil.getAppContentScrollTimer()
        .then((appContentScrollTimerObject) {
      appContentScrollTimerObject.notifyChange();
      this._timeContentScrollTimerPopupDetail = appContentScrollTimerObject;
      AppUtils.refreshCurrentState(this);
    });
  }

  Widget _rowItem(String text, onTap) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  CustomWidget.getText(text,
                      style: Theme.of(context).textTheme.title),
                ],
              ),
            ),
            Divider(
              height: 10.0,
              color: ColorUtils.dividerColor,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  /// Restricted Mode UI with functionality...
  Widget _commonSwitchUI(String title, String subTitle, bool switchValue,
      {onChanged}) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, top: 0.0, bottom: 0.0, right: 0.0),
      child: SwitchListTile(
          isThreeLine: false,
          title: getTitle(title),
          subtitle: getSubTitle(subTitle),
          value: switchValue == null ? false : switchValue,
          activeColor: ColorUtils.primaryColor,
          onChanged: onChanged),
    );
  }

  Future _restrictedModeClickEvent(bool value) async {
    setState(() {
      restrictedMode = value;
    });
    try {
      var response = await ApiHandler.putRestrictedAdultContent(context, value);
      if (response != null && response.statusCode == 200) {
        SharedPrefUtil.saveRestrictedMode(restrictedMode)
            .then((_isRestrictedModeSaved) {
          if (!_isRestrictedModeSaved) {
            restrictedMode = !restrictedMode;
            setState(() {});
            //AppUtils.
          }
        });
        PrintUtils.printLog("Restrict Adult Content Api Hit Successfully");
      } else {
        PrintUtils.printLog("Something went wrong");
      }
    } catch (e) {
      PrintUtils.printLog("Exception in restricted mode API -> $e");
    }
  }

  ///Log Out Confirmation dialog...
  AlertDialog _commonAlertDialog(
      BuildContext context, String title, String description,
      {String positiveButtonText,
      String negativeButtonText,
      positiveOnPressed,
      negativeOnPressed}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: getDialogTitle(title),
      content: getDialogContent(description),
      actions: <Widget>[
        _flatButtonDialog(context, negativeButtonText, negativeOnPressed),
        _flatButtonDialog(context, positiveButtonText, positiveOnPressed),
      ],
    );
  }

  Widget _flatButtonDialog(BuildContext context, String text, onPressed) {
    Widget buttonWidget = Container();
    if (text != null && text.trim().length > 0) {
      buttonWidget = FlatButton(
        splashColor: ColorUtils.splashColor,
        highlightColor: Colors.transparent,
        child: getDialogButtontext(text),
        onPressed: onPressed,
      );
    }
    return buttonWidget;
  }

  void _scan()  {

    NavigatorUtils.navigateToQrScan(context);
    //String barcode = await scanner.scan();
    //ApiHandler.verifyQrCode(barcode, context: context);
  }

  Widget getUI() {
    return Column(
      children: <Widget>[
        _rowItem(Strings.scanQR, _scan),
        _rowItem(Strings.clearHistory, () {
          AnalyticsUtils?.analyticsUtils?.eventClearhistoryButtonClicked();

          var _alertDialog = _commonAlertDialog(context, "Clear History?",
              "Your tymoff history will be cleared from all tymoff apps on all devices.",
              positiveButtonText: Strings.ok,
              positiveOnPressed: () async {
                AnalyticsUtils?.analyticsUtils
                    ?.eventClearhistoryOkButtonClicked();
                // hitClearHistory(context);
                await new Future.delayed(const Duration(milliseconds: 100));
                Navigator.of(context).pop(hitClearHistory(context));
              },
              negativeButtonText: Strings.cancel,
              negativeOnPressed: () async {
                AnalyticsUtils?.analyticsUtils
                    ?.eventClearhistorycancelButtonClicked();
                await new Future.delayed(const Duration(milliseconds: 100));
                Navigator.of(context).pop();
              });

          if (_alertDialog != null) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) => _alertDialog,
            );
          }
        }),
        _commonSwitchUI(
            Strings.contentScrollTimer,
            _getSubTitleAppContentScrollTimer(),
            (_timeContentScrollTimerPopupDetail?.isReminderSet ?? false),
            onChanged: (_changeValue) {
          _contentScrollTimerChangeEvent();
        }),
        Divider(
          height: 10.0,
          color: ColorUtils.dividerColor,
        ),
        _commonSwitchUI(
            Strings.reminderMeToTakeABreak,
            _getSubTitleAppTakeABreakReminderTimer(),
            (_timeTakeABreakPopupDetail?.isReminderSet ?? false),
            onChanged: (_changeValue) {
          _takeABreakClickEvent();
        }),
        Divider(
          height: 10.0,
          color: ColorUtils.dividerColor,
        ),
        darkThemeUI(),
        _commonSwitchUI(
            Strings.restrictedMode, Strings.restrictText, restrictedMode,
            onChanged: (bool value) {
          _restrictedModeClickEvent(value);
        }),
        Divider(
          height: 10.0,
          color: ColorUtils.dividerColor,
        ),
        _notificationUI(),
        Divider(
          height: 10.0,
          color: ColorUtils.dividerColor,
        ),
        _rowItem(Strings.privacyPolicy, _privacyPolicyClickEvent),
        _rowItem(Strings.feedback, _submitFeedbackClickEvent),
        _rowItem(Strings.termsAndCondition, _termsAndConditionsClickEvent),
        _rowItem(Strings.contact, _contactClickEvent),
        _rowItem(Strings.logOut, _logoutClickEvent),
      ],
    );
  }

  void _contactClickEvent() {
    AnalyticsUtils?.analyticsUtils?.eventUseragreementButtonClicked();
    NavigatorUtils.navigateToWebPage(
        context, Strings.contact, Strings.contactUrl);
  }

  void _termsAndConditionsClickEvent() {
    AnalyticsUtils?.analyticsUtils?.eventTermsandConditionButtonClicked();
    NavigatorUtils.navigateToWebPage(
        context, Strings.termsAndCondition, Strings.termsAndConditionUrl);
  }

  void _submitFeedbackClickEvent() {
    AnalyticsUtils?.analyticsUtils?.eventFeedbackButtonClicked();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SubmitFeedback()));
  }

  void _privacyPolicyClickEvent() {
    AnalyticsUtils?.analyticsUtils?.eventPrivacyPolicyButtonClicked();
    NavigatorUtils.navigateToWebPage(
        context, Strings.privacyPolicy, Strings.privacyPolicyUrl);
  }

  void _logoutClickEvent() {
    var _alertDialog = _commonAlertDialog(
        context, "Log out", "Are you sure you want to Logout?",
        positiveButtonText: Strings.ok,
        positiveOnPressed: _logoutClickEventTriggered,
        negativeButtonText: Strings.cancel,
        negativeOnPressed: _popupCurrentUI);
    if (_alertDialog != null) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => _alertDialog,
      );
    }
  }

  void _logoutClickEventTriggered() {
    themeBloc.updateTheme(ThemeModel.getTheme(ThemeModel.THEME_LIGHT));
    accountBloc.logOut(context, scaffoldKey: _scaffoldKey);
  }

  void _popupCurrentUI() {
    Navigator.of(context).pop();
  }

  StreamBuilder<ThemeModel> darkThemeUI() {
    return StreamBuilder(
      stream: themeBloc.getTheme,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: _commonSwitchUI(
                    "Dark Theme",
                    darkTheme
                        ? Strings.disabaledarktheme
                        : Strings.enableDarkTheme,
                    darkTheme, onChanged: (_changeValue) {
                  darkThemeOnClickEvent(_changeValue, snapshot);
                }),
              ),
              Divider(
                height: 10.0,
                color: ColorUtils.dividerColor,
              ),
            ],
          );
        } else {
          return ListTile(
            title: Text('......'),
          );
        }
      },
    );
  }

  void darkThemeOnClickEvent(bool value, AsyncSnapshot snapshot) {
    setState(() {
      darkTheme = !darkTheme;
      darkTheme = value;
      themeBloc.updateTheme(ThemeModel.getTheme(
          snapshot.data.name == ThemeModel.THEME_LIGHT
              ? ThemeModel.THEME_DARK
              : ThemeModel.THEME_LIGHT));
    });
  }

  String getOnOffUsingBoolean(bool isTrue) => isTrue ? "On" : "Off";

  Widget _notificationUI() {
    Widget notificationWidget = Container();
    notificationWidget = Container(
      child: FutureBuilder(
          future: _permissionStatusFuture,
          builder: (context, snapshot) {
            // if we are waiting for data, show a progress indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return _commonSwitchUI(
                  "Notification",
                  getOnOffUsingBoolean(snapshot.data),
                  snapshot.data, onChanged: (_changeValue) {
                //AppSettings.openAppSettings();
              });
            }
            return Text("No permission status yet");
          }),
    );

    return notificationWidget;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateOfAccount>(
        initialData: accountBloc.getAccountState(),
        stream: accountBloc.accountStateObservable,
        builder: (context, snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar().getAppBar(
              context: context,
              title: Strings.settings,
              leadingIcon: Icons.arrow_back_ios,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        getUI(),
                      ],
                    );
                  }, childCount: 1),
                ),
              ],
            ),
          );
        });
  }

  Widget getTitle(String title) =>
      CustomWidget.getTextTemp(title, style: Theme.of(context).textTheme.title);

  Widget getSubTitle(String subTitle) => CustomWidget.getTextTemp(subTitle,
      style: Theme.of(context).textTheme.subtitle);

  Widget getDialogTitle(String title) => CustomWidget.getText(
        title,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(fontWeight: FontWeight.w400, fontSize: 18.0),
      );

  Widget getDialogContent(String description) => CustomWidget.getText(
      description,
      style: Theme.of(context)
          .textTheme
          .title
          .copyWith(fontWeight: FontWeight.w400, color: ColorUtils.greyColor));

  Widget getDialogButtontext(String text) => CustomWidget.getText(text,
      style: Theme.of(context)
          .textTheme
          .title
          .copyWith(color: ColorUtils.pinkColor));
}
