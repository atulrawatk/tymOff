
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import '../main.dart';
import 'SizeUtils.dart';
import 'ToastUtils.dart';

enum NOTIFICATIONS {
  _UPLOAD_NOTIFICATION_ID
}

class NotificationUtils {

  Future _showNotification(int notificaitionID, String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel',
        'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificaitionID,
        title,
        message,
        platformChannelSpecifics,
        payload: '');
  }

  Future _showProgressNotification(int notificaitionID, String title, String message, int progress, int maxProgress) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel',
        'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificaitionID,
        title,
        message,
        platformChannelSpecifics,
        payload: '');
  }


  Future<void> _showIndeterminateProgressNotification(int notificaitionID, String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
        'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificaitionID,
        title,
        message,
        platformChannelSpecifics,
        payload: '');
  }


  Future<void> showContentNotification(int notificaitionID, ActionContentData content) async {

    if(Platform.isAndroid) {
      var largeIconPath = await _downloadAndSaveImage(
          'http://via.placeholder.com/48x48', 'largeIcon');
      var bigPicturePath = await _downloadAndSaveImage(
          'http://via.placeholder.com/400x800', 'bigPicture');
      var bigPictureStyleInformation = BigPictureStyleInformation(
          bigPicturePath, BitmapSource.FilePath,
          hideExpandedLargeIcon: true,
          contentTitle: 'overridden <b>big</b> content title',
          htmlFormatContentTitle: true,
          summaryText: 'summary <i>text</i>',
          htmlFormatSummaryText: true);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'indeterminate progress channel',
          'indeterminate progress channel',
          'indeterminate progress channel description',
          largeIcon: largeIconPath,
          largeIconBitmapSource: BitmapSource.FilePath,
          style: AndroidNotificationStyle.BigPicture,
          styleInformation: bigPictureStyleInformation,
          channelShowBadge: false,
          importance: Importance.Max,
          priority: Priority.High,
          onlyAlertOnce: true,
          showProgress: true,
          indeterminate: true,);
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, null);

      await flutterLocalNotificationsPlugin.show(
          0, '', '', platformChannelSpecifics);

      /*await flutterLocalNotificationsPlugin.show(
        notificaitionID,
        title,
        message,
        platformChannelSpecifics,
        payload: '');*/
    }
  }


  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

