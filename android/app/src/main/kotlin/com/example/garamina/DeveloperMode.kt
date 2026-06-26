package com.example.garamina // Sesuaikan dengan package name aplikasi Anda

import android.content.ContentResolver
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel

class DeveloperMode : FlutterPlugin {

    companion object {
        private const val CHANNEL = "developer_mode"
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPluginBinding) {
        val channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "isDeveloperModeEnabled") {
                val contentResolver: ContentResolver = binding.applicationContext.contentResolver
                val developerMode = Settings.Global.getInt(contentResolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
                result.success(developerMode)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {}

    // Jika menggunakan Flutter v1.12 ke bawah, tambahkan fungsi berikut:
    // fun registerWith(registrar: Registrar) {
    //     val channel = MethodChannel(registrar.messenger(), CHANNEL)
    //     channel.setMethodCallHandler { ... }
    // }
}
