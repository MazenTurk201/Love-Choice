import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/home.dart';

class TurkFuncs {
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<bool> openAllFilesAccessSettings() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt < 30) {
      var status = await Permission.storage.request();
      return status.isGranted;
    } else {
      // أندرويد 11 أو أحدث
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    }
  }

  Future<void> turkToast(String text) async {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
      fontAsset: "fonts/arabic_font.otf",
    );
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    showNotification(message);
  }

  Future<void> showNotification(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'عنوان',
      body: message.notification?.body ?? 'محتوى',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          icon: 'ic_notification', // ← مهم جدا
        ),
      ),
    );
  }
}
