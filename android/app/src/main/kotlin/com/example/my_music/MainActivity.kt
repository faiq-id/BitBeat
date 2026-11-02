package com.example.my_music

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Initialize and cache the persistent FlutterEngine BEFORE super.onCreate
        // so FlutterActivity binds to it immediately and keeps audio alive even if
        // ColorOS / Android reclaims MainActivity during heavy gaming.
        BitBeatEngineHolder.ensureEngine(applicationContext, intent)
        BitBeatEngineHolder.attachActivity(this)
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1001)
            }
        }
    }

    override fun getCachedEngineId(): String = BitBeatEngineHolder.ENGINE_ID

    override fun shouldDestroyEngineWithHost(): Boolean = false

    override fun onStart() {
        super.onStart()
        BitBeatEngineHolder.attachActivity(this)
        PlaybackForegroundService.isAppInForeground = true
        notifyServiceAction(PlaybackForegroundService.ACTION_APP_FOREGROUNDED)
    }

    override fun onStop() {
        super.onStop()
        PlaybackForegroundService.isAppInForeground = false
        if (BitBeatEngineHolder.isPlaybackCurrentlyActive) {
            notifyServiceAction(PlaybackForegroundService.ACTION_APP_BACKGROUNDED)
        }
    }

    override fun onDestroy() {
        BitBeatEngineHolder.detachActivity(this)
        super.onDestroy()
    }

    private fun notifyServiceAction(actionName: String) {
        try {
            val intent = Intent(this, PlaybackForegroundService::class.java).apply {
                action = actionName
            }
            if (actionName == PlaybackForegroundService.ACTION_APP_BACKGROUNDED &&
                !PlaybackForegroundService.isServiceRunning &&
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
            ) {
                startForegroundService(intent)
            } else if (PlaybackForegroundService.isServiceRunning ||
                actionName == PlaybackForegroundService.ACTION_APP_BACKGROUNDED
            ) {
                startService(intent)
            }
        } catch (_: Exception) {
        }
    }
}
