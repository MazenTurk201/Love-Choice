# Unity Ads specific rules
-keep class com.unity3d.ads.** { *; }
-keep class com.unity3d.services.** { *; }
-keep interface com.unity3d.ads.** { *; }
-keep interface com.unity3d.services.** { *; }

# Keeping JavaScript interfaces (important for webview-based ads)
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-keep class com.unity3d.services.ads.webplayer.UnityAdsJsInterface {
    public *;
}

# General Android rules that help with stability
-dontwarn com.unity3d.ads.**
-dontwarn com.unity3d.services.**