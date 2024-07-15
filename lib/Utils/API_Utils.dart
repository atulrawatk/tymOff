import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Dialogs/ChangeProfileDialog.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';

import 'AppUtils.dart';
import 'ToastUtils.dart';


class API_Utils {

  static Future<LoginResponse> editUserProfilePic(BuildContext context, ImageSource source) async {
    File imageFile = await ImagePicker.pickImage(
        source: source, maxHeight: 2000.0, maxWidth: 2000.0);

    File croppedImage = await AppUtils.cropImage(imageFile);

    if (croppedImage != null) {
      await updateProfilePic(context, croppedImage);
    }

    return await SharedPrefUtil.getLoginData();
  }

  static Future<LoginResponse> updateProfilePic(
      BuildContext context, File imageToUpdate) async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse =
          await ApiHandler.updateProfileImage(context, imageToUpdate);

      handleProfileUpdateResponse(editLoginResponse);
    } catch (e) {
      print("Munish Thakur 1 -> ${e.toString()}");
    }

    return editLoginResponse;
  }

  static Future<LoginResponse> removeProfilePic(BuildContext context) async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse = await ApiHandler.removeProfileImage(context);

      handleProfileUpdateResponse(editLoginResponse);
    } catch (e) {
      print("Munish Thakur 2 -> ${e.toString()}");
    }

    return editLoginResponse;
  }

  static void handleProfileUpdateResponse(
      LoginResponse editLoginResponse) async {
    try {
      if (editLoginResponse.isSuccess()) {
        ToastUtils.show("Details are edited successfully");

        //SnackBarUtil.showSnackBar(context, "Details are edited successfully");
        //Navigator.pop(context);
        print("edit profile Image api hit successfully");
      } else if (editLoginResponse?.message != null) {
        ToastUtils.show(editLoginResponse?.message);
      } else {
        ToastUtils.show("Something went wrong! Try Again");
      }
    } catch (e) {
      print("Munish Thakur -> handleProfileUpdateResponse() -> ${e.toString()}");
    }
  }
}
