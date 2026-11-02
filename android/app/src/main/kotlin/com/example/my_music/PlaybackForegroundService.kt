package com.example.my_music

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.content.res.Configuration
import android.graphics.Color
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaMetadata
import android.media.session.MediaSession
import android.media.session.PlaybackState
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.os.SystemClock
import android.util.TypedValue
import android.widget.RemoteViews
import kotlin.math.abs

data class NotificationPlaybackState(
    val title: String = "HERE WITH ME",
    val artist: String = "d4vd",
    val isPlaying: Boolean = false,
    val positionSec: Int = 0,
    val durationSec: Int = 242,
    val is8Bit: Boolean = false,
    val isMelody: Boolean = false,
)

class PlaybackForegroundService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: Any? = null
    private var gamingPopup: GamingFloatingPopup? = null
    private var mediaSession: MediaSession? = null
    private var isNoisyReceiverRegistered: Boolean = false
    private var isGamingModeEnabled: Boolean = false

    private var latestState = NotificationPlaybackState()
    private var lastTitle: String? = null
    private var lastArtist: String? = null
    private var lastPlaying: Boolean? = null
    private var last8Bit: Boolean? = null
    private var lastMelody: Boolean? = null
    private var lastSessionMetaKey: String? = null
    private var lastNotifyElapsedMs: Long = 0L
    private var eqTick: Int = 0
    private var isForegroundStarted: Boolean = false

    // Keep playing alongside games (do not pause when games steal focus);
    // only pause on actual phone calls (ringtone / active cellular call).
    private val audioFocusListener = AudioManager.OnAudioFocusChangeListener { focusChange ->
        if (focusChange == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT ||
            focusChange == AudioManager.AUDIOFOCUS_LOSS
        ) {
            val mode = audioManager?.mode ?: AudioManager.MODE_NORMAL
            if ((mode == AudioManager.MODE_RINGTONE || mode == AudioManager.MODE_IN_CALL) &&
                latestState.isPlaying
            ) {
                BitBeatEngineHolder.dispatchCommand("pause")
            }
        }
    }

    // Automatically pause playback if Bluetooth earbuds disconnect or wired headset is unplugged
    private val noisyAudioReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == AudioManager.ACTION_AUDIO_BECOMING_NOISY && latestState.isPlaying) {
                BitBeatEngineHolder.dispatchCommand("pause")
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        BitBeatEngineHolder.ensureEngine(applicationContext)
        createNotificationChannel()

        audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "BitBeat::PlaybackWakeLock"
        ).apply {
            setReferenceCounted(false)
        }

        setupMediaSession()
        registerNoisyAudioReceiver()

        gamingPopup = GamingFloatingPopup(
            context = this,
            onPrevious = { BitBeatEngineHolder.dispatchCommand("previous") },
            onPlayPause = { BitBeatEngineHolder.dispatchCommand("playPause") },
            onNext = { BitBeatEngineHolder.dispatchCommand("next") },
            onOpenApp = {
                gamingPopup?.hide()
                val openIntent = Intent(this, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                startActivity(openIntent)
            },
            onClose = {
                isGamingModeEnabled = false
                BitBeatEngineHolder.isGamingModeEnabled = false
                BitBeatEngineHolder.dispatchCommand("gamingModeClosed")
            }
        )
    }

    private fun setupMediaSession() {
        val openAppIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val piFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val openAppPi = PendingIntent.getActivity(this, 110, openAppIntent, piFlags)

        mediaSession = MediaSession(this, "BitBeatMediaSession").apply {
            setSessionActivity(openAppPi)
            setPlaybackToLocal(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            )

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                setMediaButtonBroadcastReceiver(
                    ComponentName(
                        this@PlaybackForegroundService,
                        MediaButtonActionReceiver::class.java
                    )
                )
            } else {
                val mbrIntent = Intent(Intent.ACTION_MEDIA_BUTTON).apply {
                    component = ComponentName(
                        this@PlaybackForegroundService,
                        MediaButtonActionReceiver::class.java
                    )
                }
                val mbrPi = PendingIntent.getBroadcast(
                    this@PlaybackForegroundService,
                    200,
                    mbrIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT
                )
                @Suppress("DEPRECATION")
                setMediaButtonReceiver(mbrPi)
            }

            setCallback(object : MediaSession.Callback() {
                override fun onPlay() {
                    BitBeatEngineHolder.dispatchCommand("play")
                }

                override fun onPause() {
                    BitBeatEngineHolder.dispatchCommand("pause")
                }

                override fun onSkipToNext() {
                    BitBeatEngineHolder.dispatchCommand("next")
                }

                override fun onSkipToPrevious() {
                    BitBeatEngineHolder.dispatchCommand("previous")
                }

                override fun onSeekTo(pos: Long) {
                    BitBeatEngineHolder.dispatchCommand("seekTo", pos)
                }

                override fun onStop() {
                    gamingPopup?.hide()
                    BitBeatEngineHolder.dispatchCommand("close")
                    shutdownService()
                }
            })

            isActive = true
        }
        updateMediaSession(latestState)
    }

    private fun updateMediaSession(st: NotificationPlaybackState) {
        val session = mediaSession ?: return
        val metaKey = "${st.title}|${st.artist}|${st.durationSec}|${st.isMelody}"
        if (metaKey != lastSessionMetaKey) {
            lastSessionMetaKey = metaKey
            val albumLabel = if (st.isMelody) "BitBeat // 8-Bit Melody" else "BitBeat // Original"
            val metadata = MediaMetadata.Builder()
                .putString(MediaMetadata.METADATA_KEY_TITLE, st.title)
                .putString(MediaMetadata.METADATA_KEY_ARTIST, st.artist)
                .putString(MediaMetadata.METADATA_KEY_ALBUM, albumLabel)
                .putLong(MediaMetadata.METADATA_KEY_DURATION, st.durationSec.coerceAtLeast(1) * 1000L)
                .build()
            session.setMetadata(metadata)
        }

        val actions = PlaybackState.ACTION_PLAY or
            PlaybackState.ACTION_PAUSE or
            PlaybackState.ACTION_PLAY_PAUSE or
            PlaybackState.ACTION_SKIP_TO_NEXT or
            PlaybackState.ACTION_SKIP_TO_PREVIOUS or
            PlaybackState.ACTION_SEEK_TO or
            PlaybackState.ACTION_STOP

        val playbackSpeed = if (st.isPlaying) {
            if (st.is8Bit) 1.04f else 1.0f
        } else {
            0f
        }

        val pbState = PlaybackState.Builder()
            .setActions(actions)
            .setState(
                if (st.isPlaying) PlaybackState.STATE_PLAYING else PlaybackState.STATE_PAUSED,
                st.positionSec.coerceAtLeast(0) * 1000L,
                playbackSpeed,
                SystemClock.elapsedRealtime()
            )
            .build()

        session.setPlaybackState(pbState)
        if (!session.isActive) {
            session.isActive = true
        }
    }

    private fun registerNoisyAudioReceiver() {
        if (isNoisyReceiverRegistered) return
        try {
            val filter = IntentFilter(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(noisyAudioReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                registerReceiver(noisyAudioReceiver, filter)
            }
            isNoisyReceiverRegistered = true
        } catch (_: Exception) {
        }
    }

    private fun unregisterNoisyAudioReceiver() {
        if (!isNoisyReceiverRegistered) return
        try {
            unregisterReceiver(noisyAudioReceiver)
        } catch (_: Exception) {
        } finally {
            isNoisyReceiverRegistered = false
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        gamingPopup?.onConfigurationChanged(newConfig)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP, ACTION_CMD_CLOSE -> {
                gamingPopup?.hide()
                if (intent.action == ACTION_CMD_CLOSE) {
                    BitBeatEngineHolder.dispatchCommand("close")
                }
                shutdownService()
                return START_NOT_STICKY
            }

            ACTION_APP_BACKGROUNDED -> {
                isAppInForeground = false
                if (latestState.isPlaying) {
                    acquireWakeLock()
                    updateMediaSession(latestState)
                    publishNotification(forceForeground = true)
                    if (isGamingModeEnabled) {
                        gamingPopup?.show(latestState)
                    } else {
                        gamingPopup?.hide()
                    }
                }
                return START_STICKY
            }

            ACTION_APP_FOREGROUNDED -> {
                isAppInForeground = true
                gamingPopup?.hide()
                return START_STICKY
            }

            ACTION_CMD_PREV -> {
                BitBeatEngineHolder.dispatchCommand("previous")
                return START_STICKY
            }

            ACTION_CMD_PLAY_PAUSE -> {
                BitBeatEngineHolder.dispatchCommand("playPause")
                return START_STICKY
            }

            ACTION_CMD_NEXT -> {
                BitBeatEngineHolder.dispatchCommand("next")
                return START_STICKY
            }

            ACTION_SET_GAMING_MODE -> {
                val enabled = intent.getBooleanExtra(EXTRA_IS_GAMING_MODE, false)
                isGamingModeEnabled = enabled
                if (!isAppInForeground) {
                    if (enabled && latestState.isPlaying) {
                        gamingPopup?.show(latestState)
                    } else {
                        gamingPopup?.hide()
                    }
                }
                return START_STICKY
            }

            ACTION_UPDATE_STATE -> {
                val title = intent.getStringExtra(EXTRA_TITLE) ?: latestState.title
                val artist = intent.getStringExtra(EXTRA_ARTIST) ?: latestState.artist
                val isPlaying = intent.getBooleanExtra(EXTRA_IS_PLAYING, latestState.isPlaying)
                val positionSec = intent.getIntExtra(EXTRA_POSITION_SEC, latestState.positionSec)
                val durationSec = intent.getIntExtra(EXTRA_DURATION_SEC, latestState.durationSec)
                val is8Bit = intent.getBooleanExtra(EXTRA_IS_8BIT, latestState.is8Bit)
                val isMelody = intent.getBooleanExtra(EXTRA_IS_MELODY, latestState.isMelody)
                val isGamingMode = intent.getBooleanExtra(EXTRA_IS_GAMING_MODE, isGamingModeEnabled)
                isGamingModeEnabled = isGamingMode

                val wasPlaying = latestState.isPlaying
                latestState = NotificationPlaybackState(
                    title = title,
                    artist = artist,
                    isPlaying = isPlaying,
                    positionSec = positionSec,
                    durationSec = durationSec,
                    is8Bit = is8Bit,
                    isMelody = isMelody,
                )

                if (isPlaying && (!wasPlaying || !isForegroundStarted)) {
                    requestMediaAudioFocus()
                }
                updateMediaSession(latestState)

                val popupVisible = gamingPopup?.isShowing == true
                if (isPlaying || (isGamingModeEnabled && popupVisible)) {
                    acquireWakeLock()
                    publishNotification(forceForeground = false)
                } else {
                    releaseWakeLock()
                    if (isForegroundStarted) {
                        publishNotification(forceForeground = false)
                    }
                }

                if (!isAppInForeground) {
                    if (isGamingModeEnabled) {
                        if (popupVisible) {
                            gamingPopup?.update(latestState)
                        } else if (isPlaying) {
                            gamingPopup?.show(latestState)
                        }
                    } else {
                        if (popupVisible) {
                            gamingPopup?.hide()
                        }
                    }
                }
                return START_STICKY
            }
        }

        return START_STICKY
    }

    private fun publishNotification(forceForeground: Boolean = false) {
        val now = SystemClock.elapsedRealtime()
        val metadataChanged = forceForeground ||
            !isForegroundStarted ||
            lastTitle != latestState.title ||
            lastArtist != latestState.artist ||
            lastPlaying != latestState.isPlaying ||
            last8Bit != latestState.is8Bit ||
            lastMelody != latestState.isMelody

        if (!metadataChanged && now - lastNotifyElapsedMs < 900L) {
            return
        }

        lastTitle = latestState.title
        lastArtist = latestState.artist
        lastPlaying = latestState.isPlaying
        last8Bit = latestState.is8Bit
        lastMelody = latestState.isMelody
        lastNotifyElapsedMs = now
        eqTick++

        val notification = buildCustomNotification(latestState)

        if (!isForegroundStarted || forceForeground) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
            isForegroundStarted = true
            isServiceRunning = true
        } else {
            val manager = getSystemService(NotificationManager::class.java)
            manager?.notify(NOTIFICATION_ID, notification)
        }
    }

    private fun buildCustomNotification(st: NotificationPlaybackState): Notification {
        val openAppIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val piFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val openAppPi = PendingIntent.getActivity(this, 100, openAppIntent, piFlags)
        val prevPi = serviceActionPendingIntent(101, ACTION_CMD_PREV, piFlags)
        val playPausePi = serviceActionPendingIntent(102, ACTION_CMD_PLAY_PAUSE, piFlags)
        val nextPi = serviceActionPendingIntent(103, ACTION_CMD_NEXT, piFlags)

        val cleanTitle = sanitizeToken(
            st.title.replace("(Melody)", "", ignoreCase = true).trim(),
            maxLen = 18
        )
        val ext = if (st.isMelody) "XM" else "MP3"
        val displayTitle = "$cleanTitle.$ext"

        val rawArtist = st.artist.split("//").firstOrNull()?.trim() ?: st.artist
        val cleanArtist = sanitizeToken(rawArtist, maxLen = 14)
        val bpm = 96 + (abs(st.title.hashCode()) % 42)

        val channelLabel = when {
            st.isMelody -> "4-CH SYNTH"
            st.is8Bit -> "4-CH 8BIT"
            else -> "16-CH PCM"
        }

        val posStr = formatTime(st.positionSec)
        val lenStr = formatTime(st.durationSec)
        val playPauseIcon = if (st.isPlaying) R.drawable.ic_pause_dark else R.drawable.ic_play_dark
        val playPauseLabel = if (st.isPlaying) "PAUSE" else "PLAY"

        val safeMax = st.durationSec.coerceAtLeast(1)
        val safeProgress = st.positionSec.coerceIn(0, safeMax)

        // 1. Compact Capsule View (collapsed notification)
        val compact = RemoteViews(packageName, R.layout.notification_bitbeat_compact).apply {
            setTextViewText(R.id.notif_title, displayTitle)
            setTextViewText(R.id.notif_subtitle_compact, "$posStr / $lenStr • $cleanArtist")
            setTextColor(
                R.id.notif_subtitle_compact,
                if (st.isPlaying) Color.parseColor("#6EE6F8") else Color.parseColor("#6B7F96")
            )
            setImageViewResource(R.id.icon_play_pause, playPauseIcon)
            setTextViewText(R.id.label_play_pause, playPauseLabel)
            setProgressBar(R.id.notif_progress, safeMax, safeProgress, false)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val compactBars = intArrayOf(
                    R.id.eq_c_1,
                    R.id.eq_c_2,
                    R.id.eq_c_3,
                    R.id.eq_c_4,
                    R.id.eq_c_5
                )
                val pattern = intArrayOf(12, 18, 9, 15, 8, 17, 10, 14)
                for (i in compactBars.indices) {
                    val hDp = if (!st.isPlaying) 4f else pattern[(eqTick + i * 2) % pattern.size].toFloat()
                    setViewLayoutHeight(compactBars[i], hDp, TypedValue.COMPLEX_UNIT_DIP)
                }
            }

            setOnClickPendingIntent(R.id.btn_prev, prevPi)
            setOnClickPendingIntent(R.id.btn_play_pause, playPausePi)
            setOnClickPendingIntent(R.id.btn_next, nextPi)
        }

        // 2. Expanded Capsule View (matches reference image + live elapsed progress bar)
        val expanded = RemoteViews(packageName, R.layout.notification_bitbeat_expanded).apply {
            setTextViewText(R.id.notif_title, displayTitle)
            setTextViewText(R.id.notif_meta, "$bpm BPM • $channelLabel • $cleanArtist")

            setImageViewResource(R.id.icon_play_pause, playPauseIcon)
            setTextViewText(R.id.label_play_pause, playPauseLabel)

            setTextViewText(R.id.notif_pos, posStr)
            setProgressBar(R.id.notif_progress, safeMax, safeProgress, false)
            setTextViewText(R.id.notif_len, lenStr)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val expandedBars = intArrayOf(
                    R.id.eq_bar_1,
                    R.id.eq_bar_2,
                    R.id.eq_bar_3,
                    R.id.eq_bar_4,
                    R.id.eq_bar_5
                )
                val pattern = intArrayOf(13, 20, 9, 16, 8, 19, 11, 15)
                for (i in expandedBars.indices) {
                    val hDp = if (!st.isPlaying) 4f else pattern[(eqTick + i * 2) % pattern.size].toFloat()
                    setViewLayoutHeight(expandedBars[i], hDp, TypedValue.COMPLEX_UNIT_DIP)
                }
            }

            setOnClickPendingIntent(R.id.btn_prev, prevPi)
            setOnClickPendingIntent(R.id.btn_play_pause, playPausePi)
            setOnClickPendingIntent(R.id.btn_next, nextPi)
        }

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        builder
            .setSmallIcon(R.drawable.ic_stat_bitbeat)
            .setColor(Color.parseColor("#0B0E15"))
            .setContentTitle(st.title)
            .setContentText("$posStr / $lenStr • ${st.artist}")
            .setContentIntent(openAppPi)
            .setOnlyAlertOnce(true)
            .setOngoing(st.isPlaying)
            .setVisibility(Notification.VISIBILITY_PUBLIC)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            builder.setCustomContentView(compact)
            builder.setCustomBigContentView(expanded)
        } else {
            @Suppress("DEPRECATION")
            builder.setContent(compact)
        }

        return builder.build()
    }

    private fun serviceActionPendingIntent(
        requestCode: Int,
        actionName: String,
        flags: Int
    ): PendingIntent {
        val intent = Intent(this, PlaybackForegroundService::class.java).apply {
            action = actionName
        }
        return PendingIntent.getService(this, requestCode, intent, flags)
    }

    private fun shutdownService() {
        abandonMediaAudioFocus()
        releaseWakeLock()
        mediaSession?.isActive = false
        lastSessionMetaKey = null
        isForegroundStarted = false
        isServiceRunning = false
        lastTitle = null
        lastArtist = null
        lastPlaying = null
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        gamingPopup?.hide()
        shutdownService()
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        unregisterNoisyAudioReceiver()
        abandonMediaAudioFocus()
        gamingPopup?.hide()
        gamingPopup = null
        try {
            mediaSession?.isActive = false
            mediaSession?.release()
        } catch (_: Exception) {
        }
        mediaSession = null
        releaseWakeLock()
        isForegroundStarted = false
        isServiceRunning = false
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun requestMediaAudioFocus() {
        val am = audioManager ?: return
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val req = (audioFocusRequest as? AudioFocusRequest)
                    ?: AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                        .setAudioAttributes(
                            AudioAttributes.Builder()
                                .setUsage(AudioAttributes.USAGE_MEDIA)
                                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                .build()
                        )
                        .setWillPauseWhenDucked(false)
                        .setOnAudioFocusChangeListener(audioFocusListener)
                        .build()
                        .also { audioFocusRequest = it }
                am.requestAudioFocus(req)
            } else {
                @Suppress("DEPRECATION")
                am.requestAudioFocus(
                    audioFocusListener,
                    AudioManager.STREAM_MUSIC,
                    AudioManager.AUDIOFOCUS_GAIN
                )
            }
        } catch (_: Exception) {
        }
    }

    private fun abandonMediaAudioFocus() {
        val am = audioManager ?: return
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                (audioFocusRequest as? AudioFocusRequest)?.let { am.abandonAudioFocusRequest(it) }
            } else {
                @Suppress("DEPRECATION")
                am.abandonAudioFocus(audioFocusListener)
            }
        } catch (_: Exception) {
        }
    }

    private fun acquireWakeLock() {
        try {
            if (wakeLock?.isHeld == false) {
                wakeLock?.acquire()
            }
        } catch (_: Exception) {
        }
    }

    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (_: Exception) {
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "BitBeat Media Bar",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Kontrol pemutar musik BitBeat di bar notifikasi"
                setShowBadge(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun sanitizeToken(raw: String, maxLen: Int): String {
        val cleaned = raw
            .uppercase()
            .replace(Regex("[^A-Z0-9]+"), "_")
            .trim('_')
        return if (cleaned.length > maxLen) cleaned.take(maxLen).trimEnd('_') else cleaned
    }

    private fun formatTime(seconds: Int): String {
        val safe = seconds.coerceAtLeast(0)
        val m = safe / 60
        val s = safe % 60
        return "%02d:%02d".format(m, s)
    }

    companion object {
        @Volatile
        var isAppInForeground: Boolean = true

        @Volatile
        var isServiceRunning: Boolean = false

        const val CHANNEL_ID = "bitbeat_playback_v3"
        const val NOTIFICATION_ID = 8081

        const val ACTION_UPDATE_STATE = "com.example.my_music.action.UPDATE_STATE"
        const val ACTION_STOP = "com.example.my_music.action.STOP_PLAYBACK"
        const val ACTION_APP_BACKGROUNDED = "com.example.my_music.action.APP_BACKGROUNDED"
        const val ACTION_APP_FOREGROUNDED = "com.example.my_music.action.APP_FOREGROUNDED"
        const val ACTION_SET_GAMING_MODE = "com.example.my_music.action.SET_GAMING_MODE"
        const val ACTION_CMD_PREV = "com.example.my_music.action.CMD_PREV"
        const val ACTION_CMD_PLAY_PAUSE = "com.example.my_music.action.CMD_PLAY_PAUSE"
        const val ACTION_CMD_NEXT = "com.example.my_music.action.CMD_NEXT"
        const val ACTION_CMD_CLOSE = "com.example.my_music.action.CMD_CLOSE"

        const val EXTRA_TITLE = "extra_title"
        const val EXTRA_ARTIST = "extra_artist"
        const val EXTRA_IS_PLAYING = "extra_is_playing"
        const val EXTRA_POSITION_SEC = "extra_position_sec"
        const val EXTRA_DURATION_SEC = "extra_duration_sec"
        const val EXTRA_IS_8BIT = "extra_is_8bit"
        const val EXTRA_IS_MELODY = "extra_is_melody"
        const val EXTRA_IS_GAMING_MODE = "extra_is_gaming_mode"
    }
}
