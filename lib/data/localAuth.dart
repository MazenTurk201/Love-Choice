// ignore_for_file: unused_catch_clause, unrelated_type_equality_checks

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthManager {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      // canCheckBiometrics + isDeviceSupported عشان نضمن ان الجهاز بيدعمها فعلاً
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
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
        biometricOnly: false,
        persistAcrossBackgrounding: true,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'لازم للأسف فك الرمز',
            cancelButton: 'فاكس',
          ),
        ],
      );
    } on PlatformException catch (e) {
      // هنا بقى "الزتونة" يا ترك
      if (e.code == 'noCredentialsSet') {
        print("يا ترك اليوزر مش عامل باسورد للموبايل أصلاً!");
        // ممكن هنا ترجع 'false' وتظهر SnackBar لليوزر تقوله "فعل حماية الموبايل الأول"
      } else if (e.code == 'NotAvailable') {
        print("الخاصية مقفولة أو مش متاحة حالياً");
      }

      print("Error Code: ${e.code} - Message: ${e.message}");
      return false;
    } on LocalAuthException catch (e) {
      if (e.code == 'noCredentialsSet') {
        print("يا ترك اليوزر مش عامل باسورد للموبايل أصلاً!");
        // ممكن هنا ترجع 'false' وتظهر SnackBar لليوزر تقوله "فعل حماية الموبايل الأول"
      } else if (e.code == 'NotAvailable') {
        print("الخاصية مقفولة أو مش متاحة حالياً");
      }

      print("Error Code: ${e.code}");
      return false;
    }
  }
}
