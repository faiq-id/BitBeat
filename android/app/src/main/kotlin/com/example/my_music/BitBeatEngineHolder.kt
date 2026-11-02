package com.example.my_music

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.widget.Toast
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterShellArgs
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.ref.WeakReference

object BitBeatEngineHolder {
    const val ENGINE_ID = "bitbeat_persistent_engine"
    private const val CHANNEL_NAME = "bitbeat/foreground_service"

    private val mainHandler = Handler(Looper.getMainLooper())
    private var methodChannel: MethodChannel? = null
    private var currentActivityRef: WeakReference<Activity>? = null
    private var hasPromptedOverlayPermission = false

    @Volatile
    var isPlaybackCurrentlyActive: Boolean = false
        private set

    @Volatile
    var isGamingModeEnabled: Boolean = false

    fun attachActivity(activity: Activity) {
        currentActivityRef = WeakReference(activity)
    }

    fun detachActivity(activity: Activity) {
        if (currentActivityRef?.get() === activity) {
            currentActivityRef = null
        }
    }

    fun ensureEngine(context: Context, launchIntent: Intent? = null): FlutterEngine {
        val appContext = context.applicationContext
        val cache = FlutterEngineCache.getInstance()
        val existing = cache.get(ENGINE_ID)
        if (existing != null) {
            return existing
        }

        val shellArgs = if (launchIntent != null) {
            FlutterShellArgs.fromIntent(launchIntent).toArray()
        } else {
            null
        }

        val engine = if (shellArgs != null) {
            FlutterEngine(appContext, shellArgs)
        } else {
            FlutterEngine(appContext)
        }

        GeneratedPluginRegistrant.registerWith(engine)
        setupMethodChannel(appContext, engine)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        

        cache.put(ENGINE_ID, engine)
        return engine
    }

    private fun setupMethodChannel(appContext: Context, engine: FlutterEngine) {
        val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel = channel

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "ensureOverlayPermission" -> {
                    val activity = currentActivityRef?.get()
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                        !Settings.canDrawOverlays(appContext) &&
                        !hasPromptedOverlayPermission &&
                        activity != null
                    ) {
                        hasPromptedOverlayPermission = true
                        Toast.makeText(
                            activity,
                            "Aktifkan 'Tampilkan di atas aplikasi lain' untuk Kapsul Musik saat main game",
                            Toast.LENGTH_LONG
                        ).show()
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:${appContext.packageName}")
                        )
                        activity.startActivity(intent)
                        result.success(false)
                    } else {
                        val granted = Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                            Settings.canDrawOverlays(appContext)
                        result.success(granted)
                    }
                }

                "setGamingMode" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    isGamingModeEnabled = enabled
                    val serviceIntent =
                        Intent(appContext, PlaybackForegroundService::class.java).apply {
                            action = PlaybackForegroundService.ACTION_SET_GAMING_MODE
                            putExtra(PlaybackForegroundService.EXTRA_IS_GAMING_MODE, enabled)
                        }
                    try {
                        if (PlaybackForegroundService.isServiceRunning) {
                            appContext.startService(serviceIntent)
                        }
                    } catch (_: Exception) {
                    }
                    result.success(true)
                }

                "updateState" -> {
                    val title = call.argument<String>("title") ?: "BitBeat"
                    val artist = call.argument<String>("artist") ?: "Artist"
                    val isPlaying = call.argument<Boolean>("isPlaying") ?: false
                    val positionSec = call.argument<Int>("positionSec") ?: 0
                    val durationSec = call.argument<Int>("durationSec") ?: 0
                    val is8Bit = call.argument<Boolean>("is8Bit") ?: false
                    val isMelody = call.argument<Boolean>("isMelody") ?: false
                    val isGamingMode = call.argument<Boolean>("isGamingMode") ?: isGamingModeEnabled

                    isPlaybackCurrentlyActive = isPlaying
                    isGamingModeEnabled = isGamingMode

                    val serviceIntent =
                        Intent(appContext, PlaybackForegroundService::class.java).apply {
                            action = PlaybackForegroundService.ACTION_UPDATE_STATE
                            putExtra(PlaybackForegroundService.EXTRA_TITLE, title)
                            putExtra(PlaybackForegroundService.EXTRA_ARTIST, artist)
                            putExtra(PlaybackForegroundService.EXTRA_IS_PLAYING, isPlaying)
                            putExtra(PlaybackForegroundService.EXTRA_POSITION_SEC, positionSec)
                            putExtra(PlaybackForegroundService.EXTRA_DURATION_SEC, durationSec)
                            putExtra(PlaybackForegroundService.EXTRA_IS_8BIT, is8Bit)
                            putExtra(PlaybackForegroundService.EXTRA_IS_MELODY, isMelody)
                            putExtra(PlaybackForegroundService.EXTRA_IS_GAMING_MODE, isGamingMode)
                        }

                    try {
                        if (isPlaying &&
                            !PlaybackForegroundService.isServiceRunning &&
                            Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                        ) {
                            appContext.startForegroundService(serviceIntent)
                        } else if (isPlaying || PlaybackForegroundService.isServiceRunning) {
                            appContext.startService(serviceIntent)
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SERVICE_ERROR", e.message, null)
                    }
                }

                "stop" -> {
                    isPlaybackCurrentlyActive = false
                    val serviceIntent =
                        Intent(appContext, PlaybackForegroundService::class.java).apply {
                            action = PlaybackForegroundService.ACTION_STOP
                        }
                    try {
                        if (PlaybackForegroundService.isServiceRunning) {
                            appContext.startService(serviceIntent)
                        } else {
                            appContext.stopService(
                                Intent(appContext, PlaybackForegroundService::class.java)
                            )
                        }
                    } catch (_: Exception) {
                        appContext.stopService(
                            Intent(appContext, PlaybackForegroundService::class.java)
                        )
                    }
                    result.success(true)
                }

                "moveToBackground" -> {
                    currentActivityRef?.get()?.moveTaskToBack(true)
                    result.success(true)
                }

                "playRetroClick" -> {
                    val style = call.argument<String>("style") ?: "tap"
                    RetroSfxPlayer.play(style)
                    result.success(true)
                }

                "playRetroClick" -> {
                    val style = call.argument<String>("style") ?: "tap"
                    RetroSfxPlayer.play(style)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    fun dispatchCommand(command: String, positionMs: Long? = null, attempt: Int = 0) {
        mainHandler.post {
            val payload = if (positionMs != null) {
                mapOf("command" to command, "positionMs" to positionMs)
            } else {
                mapOf("command" to command)
            }
            val channel = methodChannel ?: return@post
            channel.invokeMethod("onMediaCommand", payload, object : MethodChannel.Result {
                override fun success(result: Any?) {}

                override fun error(
                    errorCode: String,
                    errorMessage: String?,
                    errorDetails: Any?,
                ) {}

                override fun notImplemented() {
                    if (attempt < 5) {
                        mainHandler.postDelayed(
                            { dispatchCommand(command, positionMs, attempt + 1) },
                            350L
                        )
                    }
                }
            })
        }
    }
}
