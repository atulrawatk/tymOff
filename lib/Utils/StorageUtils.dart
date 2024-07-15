import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StorageUtils {

  static Future<String> _findLocalPathTemp(BuildContext context) async {

    final platform = Theme.of(context).platform;

    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> _findLocalPath(BuildContext context) async {

    final platform = Theme.of(context).platform;
    String path = "";
    if(platform == TargetPlatform.android) {
      path = await getAndroidFilePath();
    } else {
      path = await getIosFilePath();
    }

    return path;
  }

  static Future<String> getAndroidFilePath() async {
    var directory = await getExternalStorageDirectory();
    String path = directory.path;
    if(path != null && path.contains("/Android")) {
      path = path.substring(0, path.indexOf("/Android"));
    }

    return path;
  }

  static Future<String> getIosFilePath() async {
    var directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return path;
  }

  static Future<String> findLocalTymoffPath(BuildContext context) async {
    return (await _findLocalPath(context)) + '/tymoff';
  }

  static Future<String> findLocalDownloadPath(BuildContext context) async {
    return (await _findLocalPath(context)) + '/DCIM/tymoff';
  }
}