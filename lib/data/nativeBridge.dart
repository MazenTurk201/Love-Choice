import 'package:flutter/services.dart';

class NativeSecrets {
  static const platform = MethodChannel('com.myapp.secrets/keys');

  static Future<String?> getFirstKey() async {
    return await platform.invokeMethod<String>('getFirstKey');
  }

  static Future<String?> getSecondKey() async {
    return await platform.invokeMethod<String>('getSecondKey');
  }
}