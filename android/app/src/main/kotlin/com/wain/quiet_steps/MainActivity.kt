package com.wain.quiet_steps

import android.app.NotificationManager
import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Ringer state for the milestone tune: no sound when the phone is on
        // silent, vibrate or Do Not Disturb. Read-only; needs no permission.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "quiet_steps/sound_mode")
            .setMethodCallHandler { call, result ->
                if (call.method != "mode") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                try {
                    val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    val filter = nm.currentInterruptionFilter
                    if (filter != NotificationManager.INTERRUPTION_FILTER_ALL &&
                        filter != NotificationManager.INTERRUPTION_FILTER_UNKNOWN
                    ) {
                        result.success("dnd")
                        return@setMethodCallHandler
                    }
                    val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    result.success(
                        when (am.ringerMode) {
                            AudioManager.RINGER_MODE_SILENT -> "silent"
                            AudioManager.RINGER_MODE_VIBRATE -> "vibrate"
                            else -> "normal"
                        }
                    )
                } catch (e: Exception) {
                    result.success("unknown")
                }
            }
    }
}
