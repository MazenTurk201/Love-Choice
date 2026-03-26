import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class TurkFuncs {
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
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

  Future<void> OpenUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch URL: $url');
    }
  }
}
