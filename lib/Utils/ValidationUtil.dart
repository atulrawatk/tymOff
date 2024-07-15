
import 'dart:collection';

import 'package:tymoff/Network/Response/MetaDataResponse.dart';

import 'ToastUtils.dart';

class ValidationUtil {

  static String isEmpty(String value , String fieldName){
    if(value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String validateMobile(String value, String fieldName){
    if(value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String validateCountryCode(String value, String fieldName){
    if(value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String validateEmail(String value){
    Pattern pattern =  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.isEmpty){
      return "Email is required";
    } else if(!regex.hasMatch(value.trim())){
      return "Enter valid email";
    }

    else return null;
  }

  static bool isValidUrl(String value){
    Pattern pattern =  r"^(?:(ftp|http|https):\/\/)?(?:[\w-]+\.)+[a-z]{2,6}";
    RegExp regex = new RegExp(pattern);
    if(value == null){
      return false;
    } else if(!regex.hasMatch(value.trim())){
      return false;
    }
    return true;
  }

  static bool isGenreLanguageValidInUploadFlow(HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsGenre, HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsLanguage) {

    int errorCount = 0;
    if((_hmSelectedItemsGenre?.length ?? 0) <= 0) {
      ToastUtils.show("Please select genre");
      errorCount++;
    } else if((_hmSelectedItemsLanguage?.length ?? 0) <= 0) {
      ToastUtils.show("Please select Language");
      errorCount++;
    }

    return errorCount <= 0;
  }
}