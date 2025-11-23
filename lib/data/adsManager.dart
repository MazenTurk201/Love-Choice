import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    return kDebugMode
        ? "ca-app-pub-3940256099942544/9214589741" // test ad
        : "ca-app-pub-5128290475212632/9315334960"; // real ad
  }
}
