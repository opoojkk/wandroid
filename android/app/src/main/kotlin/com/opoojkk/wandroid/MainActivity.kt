package com.opoojkk.wandroid

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.webkit.WebView

class MainActivity : FlutterActivity(){
    private val CHANNEL = "custom_webview"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "disableOverScroll") {
                val webView: WebView? = call.argument("webView")
                webView?.overScrollMode = WebView.OVER_SCROLL_NEVER
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}
