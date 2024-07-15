import 'package:flutter/material.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

class SnackBarUtil {

  static void show(GlobalKey<ScaffoldState> key, String msg) {
    try {
      if (key == null || msg == null) {
        return;
      }
      key.currentState.showSnackBar(SnackBar(content: Text(msg)));
    } catch(e) {
      PrintUtils.printLog("Exception in showing SnackBar -> ${e.toString()}");
    }
  }

  static void showSnackBar(BuildContext context, String msg) {
    try {
      if (context == null || msg == null) {
        return;
      }
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg),duration: Duration(milliseconds: 1000)));
    } catch(e) {
      PrintUtils.printLog("Exception in showing SnackBar -> ${e.toString()}");
    }
  }
}