import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';


class CustomWidgetTakeBreakAlertTemp {

  List selectedListValueOfHourAndMinute = List();

  showPickerNumberFormatValue(BuildContext context, AppTakeBreakReminder _timePopupDetail, DialogPickerDoubleCallback onConfirm) async{
    Picker(
        backgroundColor : Theme.of(context).backgroundColor,
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: 0,
              end: 23,
              initValue: (_timePopupDetail?.hour ?? 0),
              onFormatValue: (value) {
                return value < 10 ? "0$value" : "$value";
              }
          ),
          NumberPickerColumn(
              jump: 5,
              begin: 00,
              initValue: (_timePopupDetail?.minutes ?? 0),
              end: 59
          ),
        ]),
        textStyle: Theme.of(context).textTheme.title,
        selectedTextStyle: TextStyle(
            color: ColorUtils.primaryColor,
            decorationStyle: TextDecorationStyle.solid),
        cancelTextStyle: TextStyle(
            color: ColorUtils.primaryColor,
            decorationStyle: TextDecorationStyle.solid),
        confirmTextStyle: TextStyle(
            color: ColorUtils.primaryColor,
            decorationStyle: TextDecorationStyle.solid),
        columnPadding: EdgeInsets.only(left: 16.0,right: 16.0),
        hideHeader: true,
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomWidget.getText("Reminder frequency",),
            Padding(
              padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CustomWidget.getText("Hours",style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0)),
                  ),
                  Expanded(
                    flex: 0,
                    child: CustomWidget.getText("Minutes",style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
        // selectedTextStyle: TextStyle(color: ColorUtils.pinkColor,fontWeight: FontWeight.w500),
        onConfirm: (Picker picker, List value) {
            //print(value.toString());
          print(picker.getSelectedValues());
          selectedListValueOfHourAndMinute = picker.getSelectedValues();
          _setSelectedHourMinuteValue(selectedListValueOfHourAndMinute, onConfirm);
        }
    ).showDialog(context);
  }

  void _setSelectedHourMinuteValue(List selectedValue, DialogPickerDoubleCallback onConfirm) {
    var hour = selectedValue[0];
    var minutes = selectedValue[1];

    onConfirm(hour, minutes);
  }


}
