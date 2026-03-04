import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return "ca-app-pub-3940256099942544/9214589741";
    } else {
      return "ca-app-pub-5128290475212632/8556324047";
    }
  }

  static String get rewardAdUnitId {
    if (kDebugMode) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      return "ca-app-pub-5128290475212632/6578217338";
    }
  }

  static String get binyRewardAdUnitId {
    if (kDebugMode) {
      return "ca-app-pub-3940256099942544/5354046379";
    } else {
      return "ca-app-pub-5128290475212632/7626864683";
    }
  }

  static BannerAd createBanner() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Failed: ${error.message}");
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  static Widget TurkAD(BannerAd? bannerAd) {
    if (bannerAd != null) {
      return Align(
        alignment: AlignmentGeometry.topCenter,
        child: SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class TurkRewarded {
  static RewardedAd? _rewardedAd;

  // تحميل الإعلان
  static Future<void> load() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardAdUnitId, // غيّره بالحقيقي
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // debugPrint("Rewarded loaded");
          _rewardedAd = ad;

          // إضافة الـ Listeners
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              // debugPrint("Rewarded showed fullscreen");
            },
            onAdDismissedFullScreenContent: (ad) {
              // debugPrint("Rewarded dismissed");
              ad.dispose();
              load(); // تحميل إعلان جديد
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              // debugPrint("Failed to show rewarded: $error");
              ad.dispose();
              load();
            },
            onAdImpression: (ad) {
              // debugPrint("Rewarded impression");
            },
            onAdClicked: (ad) {
              // debugPrint("Reward clicked");
            },
          );
        },

        onAdFailedToLoad: (error) {
          // debugPrint("Failed to load rewarded: $error");
          _rewardedAd = null;
        },
      ),
    );
  }

  // عرض الإعلان
  static void show({required Function(int amount) onReward}) {
    if (_rewardedAd == null) {
      // debugPrint("Rewarded not ready");
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // debugPrint("User rewarded: ${reward.amount}");
        onReward(reward.amount.toInt());
      },
    );

    _rewardedAd = null; // عشان ما يتعرضش مرتين
  }
}
