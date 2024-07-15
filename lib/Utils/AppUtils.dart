import 'dart:async';
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:screen/screen.dart';
import 'package:tymoff/Network/Response/AppSetContentScrollTimer.dart';
import 'package:tymoff/Network/Response/AppTakeBreakReminder.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:url_launcher/url_launcher.dart';

typedef DialogPickerSingleCallback = void Function(int selecteds);
typedef DialogPickerDoubleCallback = void Function(
    int selecteds1, int selecteds2);

class AppUtils {
  static void refreshCurrentState(State state) {
    state.setState(() {});
  }

  static Future<bool> configApp() async {
    Timer.periodic(Duration(seconds: 10), (_timer) {
      _timer.cancel();
      _setAppData();
    });
    return true;
  }

  static Future _setAppData() async {
    await _setAppTakeABreakTime();
    await _setContentScrollTimer();
  }

  static Future _setAppTakeABreakTime() async {
    var appTakeABreakTime = await SharedPrefUtil.getAppTakeBreakReminder();
    if (appTakeABreakTime?.isReminderSet == null) {
      await SharedPrefUtil.saveAppTakeBreakReminder(
          AppTakeBreakReminder(hour: 0, minutes: 15));
    }
  }

  static Future _setContentScrollTimer() async {
    var appContentScrollTimer = await SharedPrefUtil.getAppContentScrollTimer();
    if (appContentScrollTimer?.seconds == null) {
      await SharedPrefUtil.saveAppContentScrollTimer(AppSetContentScrollTimer(
          seconds: Constant.DEFAULT_DETAIL_CARD_SCROLL_TIME));
    }
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if ((result?.length ?? 0) > 0 &&
          ((result[0].rawAddress?.length ?? 0) > 0)) {
        return true;
      }
    } on SocketException catch (_) {
      PrintUtils.printLog('not connected');
    }

    return false;
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void handleLoginFlowResponse(
      BuildContext context,
      LoginResponse loginResponse,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    if (loginResponse.data != null) {
      _moveToOTPScreen(context, loginResponse);
    } else if (loginResponse.data == null) {
      SnackBarUtil.show(_scaffoldKey,
          loginResponse?.message ?? "Invalid Username or Password.");
    }
  }

  static void verfiyOTPLoginFlow(
      BuildContext context,
      LoginResponse loginResponse,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    if (loginResponse.data != null) {
      handleAutoLoginResponse(context);
    } else if (loginResponse.data == null) {
      SnackBarUtil.show(_scaffoldKey,
          loginResponse?.message ?? "Invalid Username or Password.");
    }
  }

  static void handleAutoLoginResponse(BuildContext context) async {
//    var loginResponse = await SharedPrefUtil.getLoginData();
//
//    if (loginResponse != null && loginResponse.data != null) {
//      if (loginResponse.data.success != null &&
//          loginResponse.data.success) {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (BuildContext context) => Home()));
//      } else {
//        _moveToLoginScreen(context);
//      }
//    } else {
//      _moveToLoginScreen(context);
//    }
  }

  static void _moveToOTPScreen(
      BuildContext context, LoginResponse loginResponse) {
    //Navigator.push(context, MaterialPageRoute(
    //  builder: (BuildContext context) => EnterOtp()));
  }

  static bool isValid(bool value, {bool defaultReturn}) {
    if (value != null) {
      return value;
    }
    if (defaultReturn != null) {
      return defaultReturn;
    }
    return false;
  }

  static int getValue(int value, {int defaultReturn}) {
    if (value != null) {
      return value;
    }
    if (defaultReturn != null) {
      return defaultReturn;
    }
    return 0;
  }

  static String getFormattedInt(int numberToFormat) {
    String _formattedNumber = "$numberToFormat";
    try {
      // In this you won't have to worry about the symbol of the currency.
      _formattedNumber = NumberFormat.compact().format(numberToFormat);

      String _separator = ".";
      if (_formattedNumber.contains(_separator)) {
        String beforeDecimalString =
            _formattedNumber.substring(0, _formattedNumber.indexOf(_separator));
        String afterDecimalString = _formattedNumber.substring(
            _formattedNumber.indexOf(_separator) + _separator.length,
            _formattedNumber.length);

        String digit = afterDecimalString.substring(0, 1);
        String countNotation = afterDecimalString.substring(
            afterDecimalString.length - 1, afterDecimalString.length);

        String afterDecimalFormattedString = "$digit $countNotation";

        _formattedNumber =
            "$beforeDecimalString$_separator$afterDecimalFormattedString";
      }
    } catch (e) {}

    return _formattedNumber;
  }

  static void screenKeepOn(bool isKeptOn) async {
    bool isOn = await Screen.isKeptOn;
    if (isOn != isKeptOn) {
      // Prevent screen from going into sleep mode:
      Screen.keepOn(isKeptOn);
    }
  }

  static bool isDiscoverNeedLogin(int discoverId) {
    return (discoverId != null && (discoverId == 3 || discoverId == 4));
  }

  static Future<File> cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.black,
          toolbarWidgetColor: ColorUtils.greyColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    return croppedImage;
  }

  static int checkFileSizes(List<File> assetFiles) {
    int totalSize = 0;
    if (assetFiles != null) {
      assetFiles?.forEach((file) {
        int fileSize = (file?.lengthSync() ?? 0);
        totalSize += fileSize;
      });

      PrintUtils.printLog("Munish Thakur -> Total File Size -> $totalSize");
    }
    return totalSize;
  }

  static int checkFileSize(File assetFile) {
    int totalSize = 0;
    if (assetFile != null) {
      int fileSize = (assetFile?.lengthSync() ?? 0);
      totalSize += fileSize;

      PrintUtils.printLog("Munish Thakur -> Total File Size -> $totalSize");
    }
    return totalSize;
  }

  static bool isTotalFileSizesValidToUpload(List<int> fileSizes) {
    int _totalFileSizes = 0;
    
    fileSizes?.takeWhile((_totalFileSizes) => _isTotalFileSizeValid(_totalFileSizes))?.forEach((_fileSize) {
      _totalFileSizes += _fileSize;
    });

    bool _isValidToUpload = _isTotalFileSizeValid(_totalFileSizes);
    print("Munish Thakur -> isTotalFileSizesValidToUpload(): $_isValidToUpload (Total Files Size: ${filesize(_totalFileSizes, 1)})");
    return _isValidToUpload;
  }

  static bool _isTotalFileSizeValid(int totalFileSizes) => Constant.maxFileSize > totalFileSizes;
}
