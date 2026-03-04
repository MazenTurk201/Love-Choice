package com.turk.love_choice

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.myapp.secrets/keys"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler { call, result ->
            // هنا بنستخدم when بدل switch .. أروق بكتير
            when (call.method) {
                "getFirstKey" -> result.success("KEY_1_HERE") // حط مفتاحك الأول هنا
                "getSecondKey" -> result.success("KEY_2_HERE") // حط مفتاحك التاني هنا
                else -> result.notImplemented()
            }
        }
    }
}