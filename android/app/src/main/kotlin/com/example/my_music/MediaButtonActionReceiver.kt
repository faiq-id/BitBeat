package com.example.my_music

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.KeyEvent

class MediaButtonActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != Intent.ACTION_MEDIA_BUTTON) return

        val keyEvent: KeyEvent? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT, KeyEvent::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT)
        }

        if (keyEvent == null || keyEvent.action != KeyEvent.ACTION_DOWN) return

        // Ensure persistent FlutterEngine is alive even if app was woken up from Bluetooth earbuds
        BitBeatEngineHolder.ensureEngine(context.applicationContext)

        when (keyEvent.keyCode) {
            KeyEvent.KEYCODE_MEDIA_PLAY -> BitBeatEngineHolder.dispatchCommand("play")
            KeyEvent.KEYCODE_MEDIA_PAUSE -> BitBeatEngineHolder.dispatchCommand("pause")
            KeyEvent.KEYCODE_HEADSETHOOK,
            KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE -> BitBeatEngineHolder.dispatchCommand("playPause")
            KeyEvent.KEYCODE_MEDIA_NEXT -> BitBeatEngineHolder.dispatchCommand("next")
            KeyEvent.KEYCODE_MEDIA_PREVIOUS -> BitBeatEngineHolder.dispatchCommand("previous")
            KeyEvent.KEYCODE_MEDIA_STOP -> BitBeatEngineHolder.dispatchCommand("close")
        }
    }
}

