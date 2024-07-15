import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventTakeABreak.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

import '../main.dart';

class BaseState extends StatefulWidget {
  final Widget child;

  BaseState({this.child});

  @override
  _BaseStateState createState() => new _BaseStateState();
}

class _BaseStateState extends State<BaseState> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setTakeABreakTimer();
    triggerObservers();
  }

  void triggerObservers() {
    WidgetsBinding.instance.addObserver(this);
    setTakeBreakTriggerObserver();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //alertDialog(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  AppLifecycleState _appLifecycleState;

  // TODO: DID_CHANGE_APP_LIFE_CYCLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
      if (_appLifecycleState == AppLifecycleState.paused ||
          _appLifecycleState == AppLifecycleState.inactive) {
        print("IF timer---fired: $_appLifecycleState");
        if (_timerTakeABreak?.isActive ?? false) {
          _timerTakeABreak.cancel();
        }
      } else {
        print("ELSE timer---fired: $_appLifecycleState");
        _setTakeABreakTimer();
      }
    });
  }

  void _setTakeABreakTimer() {
    _timerTakeABreak?.cancel();
    _initializeTimer();
  }

  void setTakeBreakTriggerObserver() {
    eventBus.on<EventTakeABreak>().listen((event) {
      if (event.eventStatus == TAKE_A_BREAK_STATUS.BREAK_SET) {
        _setTakeABreakTimer();
      }
    });
  }

  Timer _timerTakeABreak;
  AppTakeBreakReminder appBreakTimerObject;

  void _initializeTimer() async {
    try {
      appBreakTimerObject = await SharedPrefUtil.getAppTakeBreakReminder();

      if (appBreakTimerObject.hour > 0 || appBreakTimerObject.minutes > 0) {
        _timerTakeABreak = Timer.periodic(
            Duration(
                hours: appBreakTimerObject.hour,
                minutes: appBreakTimerObject.minutes),
                (_) => _timerWorkCompleted());
      }
    } catch (e) {
      print("Exception in showing take a break timer set -> $e");
    }
  }

  bool isTakeABreakAlertDialogVisible = false;

  _timerWorkCompleted() {
    print("Timer Triggered");
    if (!isTakeABreakAlertDialogVisible) {
      EventBusUtils.eventTakeABreak_Break();

      final context = MyApp.navKey.currentState.overlay.context;
      try {
        var _alertDialog = getAlertDialog(context);
        if (_alertDialog != null) {
          isTakeABreakAlertDialogVisible = true;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => _alertDialog,
          );
        }
      } catch (e) {
        print("Munish Thakur -> _timerWorkCompleted() -> ${e.toString()}");
      }
    }
  }

  Widget contentOfDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CustomWidget.getText('Time to Take a break?',
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.w300, fontSize: 17.0)),
        SizedBox(
          height: 10.0,
        ),
        CustomWidget.getText(
            'You have been using tymoff for ${appBreakTimerObject.isHoursValid() ? "${appBreakTimerObject.hour} Hours" : ""}${appBreakTimerObject.isHoursValid() ? "," : ""}${appBreakTimerObject.isMinutesValid() ? "${appBreakTimerObject.minutes} Minutes" : ""} . Adjust or turn off this reminder in Settings',
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.w300, fontSize: 14.0)),
      ],
    );
  }

  AlertDialog getAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        'Reminder',
        style: TextStyle(fontSize: 22.0),
      ),
      content: contentOfDialog(),
      actions: [
        CustomWidget.getFlatBtn(context, "Settings",
            textColor: ColorUtils.pinkColor, onPressed: () {
          isTakeABreakAlertDialogVisible = false;
          Navigator.of(context, rootNavigator: true).pop();
          NavigatorUtils.moveToSettingsScreen(context);
        }),
        CustomWidget.getFlatBtn(context, "Resume",
            textColor: ColorUtils.pinkColor, onPressed: () {
          isTakeABreakAlertDialogVisible = false;
          Navigator.of(context, rootNavigator: true).pop();
          EventBusUtils.eventTakeABreak_Resume();
        }),
      ],
    );
  }
}
