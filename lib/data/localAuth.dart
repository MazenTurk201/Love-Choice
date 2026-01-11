// ignore_for_file: unused_catch_clause

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthManager {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      // canCheckBiometrics + isDeviceSupported عشان نضمن ان الجهاز بيدعمها فعلاً
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticat() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: "لتجنب دخول الأطفال بس",
        persistAcrossBackgrounding: true,
        biometricOnly: false,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'لازم للأسف بصمة',
            cancelButton: 'فاكس',
          ),
        ],
      );
    } on PlatformException catch (e) {
      print("Error: $e");
      return false;
    }
  }
}