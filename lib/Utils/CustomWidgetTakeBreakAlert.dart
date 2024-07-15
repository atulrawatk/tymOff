import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomWidgetTakeABreak  extends StatefulWidget {
  @override
  _CustomWidgetTakeABreakState createState() => _CustomWidgetTakeABreakState();
}

class _CustomWidgetTakeABreakState extends State<CustomWidgetTakeABreak> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class CustomWidgetTakeBreakAlert {
  AppTakeBreakReminder _timePopupDetail = AppTakeBreakReminder();

  Future _getTakeABreakData() async {
    var appBreakTimerObject = await SharedPrefUtil.getAppTakeBreakReminder();
    if(appBreakTimerObject == null) {
      appBreakTimerObject = AppTakeBreakReminder(hour: 0, minutes: 15);
    }
    if(appBreakTimerObject.hour == null) {
      appBreakTimerObject.hour = 0;
    }
    if(appBreakTimerObject.minutes == null) {
      appBreakTimerObject.minutes = 15;
    }

    this._timePopupDetail = appBreakTimerObject;
  }

  Future<AppTakeBreakReminder> asyncShowTakeBreakDialog(
      BuildContext context) async {
    await _getTakeABreakData();

    return showDialog<AppTakeBreakReminder>(
      context: context,
      builder: (BuildContext context) {
        return _getTakeBreakDialogUI(context);
      },
    );
  }

  Widget middlePartUI(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomWidget.getText("Hours",style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0)),
            SizedBox(height: 6.0,),
            _numberPicker(
                initialValue: _timePopupDetail.hour,
                min: 0,
                max: 23,
                steps: 1,
                setValue: _setHourPicker),

          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomWidget.getText("Minutes",style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0)),
            SizedBox(height: 6.0,),
            _numberPicker(
                initialValue: _timePopupDetail.minutes,
                min: 0,
                max: 55,
                steps: 5,
                setValue: _setMinutesPicker),
      ],
        ),
    ],
    );
  }

  AlertDialog _getTakeBreakDialogUI(BuildContext context) {
    return AlertDialog(
      contentPadding : EdgeInsets.all(10.0),
      title: CustomWidget.getText("Reminder frequency",
          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w400,fontSize: 18.0),
      ),
      content: middlePartUI(context),
      actions: <Widget>[
        FlatButton(
          child: CustomWidget.getText("CANCEL",style: Theme.of(context).textTheme.title.copyWith(color:ColorUtils.pinkColor,fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: CustomWidget.getText("OK",style: Theme.of(context).textTheme.title.copyWith(color:ColorUtils.pinkColor,fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.of(context).pop(_timePopupDetail);
          },
        )
      ],
    );
  }

  Widget _numberPicker(
      {int initialValue, int min, int max, int steps, Function setValue}) {
    return NumberPicker.integer(
        listViewWidth : 60.0,
      highlightSelectedValue: true,
      zeroPad: true,
      decoration: ShapeDecoration.fromBoxDecoration(
          BoxDecoration(
              border: Border(
              top: BorderSide(style: BorderStyle.solid,color: ColorUtils.iconGreyColor,width: 1.4),
              bottom:  BorderSide(style: BorderStyle.solid,color: ColorUtils.iconGreyColor,width: 1.4)
            ),
          )
      ),
     //itemExtent: 80.0,
     //zeroPad: true,
      minValue: min,
      maxValue: max,
      initialValue: initialValue,
      step: steps,
      infiniteLoop: true,
      onChanged: (value){
        initialValue = value;
        setValue(value);
      },
    );
  }


  void _setHourPicker(int selectedValue) {
    _timePopupDetail.hour = selectedValue;
  }

  void _setMinutesPicker(int selectedValue) {
    _timePopupDetail.minutes = selectedValue;
  }
}
