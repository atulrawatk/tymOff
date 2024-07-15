import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:tymoff/Network/Response/AppSetContentScrollTimer.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

import 'AppUtils.dart';

class CustomWidgetScrollTimerAlert {
  showPickerNumberFormatValue(
      BuildContext context,
      AppSetContentScrollTimer _timeContentScrollTimerPopupDetail,
      DialogPickerSingleCallback onConfirm) {
    Picker(
        backgroundColor : Theme.of(context).backgroundColor,
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              // jump: 5,
              initValue: _timeContentScrollTimerPopupDetail?.seconds ?? 0,
              begin: 00,
              end: 59),
        ]),
        columnPadding: EdgeInsets.only(left: 55.0, right: 55.0),
        hideHeader: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomWidget.getText(
              "Content Scroll Timer",
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomWidget.getText("Seconds",
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: 14.0)),
                ],
              ),
            ),
          ],
        ),
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
        onConfirm: (Picker picker, List value) {
          print("Munish Thakur -> value -> ${value.toString()}");
          print(
              "Munish Thakur -> picker.getSelectedValues() -> ${picker.getSelectedValues()}");

          onConfirm(value[0]);
        }).showDialog(context);
  }
}
