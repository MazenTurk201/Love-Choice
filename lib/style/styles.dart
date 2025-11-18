import 'package:flutter/material.dart';

class TurkStyle {
  final Color mainColor = Color.fromARGB(255, 55, 0, 255);
  final Color hoverColor = Color.fromARGB(255, 70, 20, 255);
  final Color textColor = Colors.white;
  final String turkFont = "TurkFont";
  final TooltipThemeData themetooltip = TooltipThemeData(
    decoration: BoxDecoration(
      color: Color.fromARGB(155, 90, 45, 255),
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      color: Colors.white,
      fontFamily: "TurkFont",
      fontSize: 13,
      // fontWeight: FontWeight.bold,
    ),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    waitDuration: Duration(milliseconds: 300),
    showDuration: Duration(seconds: 3),
    preferBelow: false,
  );
}

extension HexColorExtension on String {
  Color toColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // لو مفيش Alpha حط FF (شفافية كاملة)
    }
    return Color(int.parse(hex, radix: 16));
  }
}

extension HoverColor on Color {
  /// يخلي اللون أفتح بنسبة معينة
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  /// يخلي اللون أغمق بنسبة معينة
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class TextUtils {
  static TextDirection getTextDirection(String text) {
    // أي حرف عربي هيعتبر النص RTL
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (arabicRegex.hasMatch(text)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
