import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

class DialogUtils {
  static AlertDialog _progress;

  static void showProgress(context, {String msg = "Please wait"}) {
    if (context == null) {
      return;
    }
    if (_progress == null) {
      var bodyProgress = new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new CircularProgressIndicator(
            backgroundColor: ColorUtils.greyColor.withOpacity(0.5),
            value: null,
            valueColor: new AlwaysStoppedAnimation<Color>(ColorUtils.greyColor.withOpacity(0.5)),
            strokeWidth: 2.0,
          ),
          new Container(
            margin: const EdgeInsets.only(left: 25.0),
            child: new Text(
              msg,
              style: new TextStyle(color: ColorUtils.greyColor),
            ),
          ),
        ],
      );
      _progress = new AlertDialog(
        content: bodyProgress,
      );
    }
    showDialog(context: context, child: _progress, barrierDismissible: true);
  }

  static void hideProgress(context) {
    if (context == null) {
      return;
    }
    if (_progress != null) {
      Navigator.pop(context);
      _progress = null;
    }
  }

  static void showMessageDialog(BuildContext context, String msg) {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
        msg,
        style: new TextStyle(color: Colors.blue),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text("OK", style: new TextStyle(color: Colors.blue)))
      ],
    );
    showDialog(context: context, child: dialog);
  }
}
