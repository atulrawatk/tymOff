import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

class ToastUtils {

  static void show(String msg) {
    try {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: ColorUtils.toastBackgroundColor,
          textColor: Colors.white,
          fontSize: 10.0
      );
    } catch(e) {
      PrintUtils.printLog("Exception in showing Toast -> ${e.toString()}");
    }
  }
}