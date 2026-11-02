package com.example.my_music

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.text.TextUtils
import android.util.TypedValue
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.ViewConfiguration
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import kotlin.math.abs
import kotlin.random.Random

class GamingFloatingPopup(
    private val context: Context,
    private val onPrevious: () -> Unit,
    private val onPlayPause: () -> Unit,
    private val onNext: () -> Unit,
    private val onOpenApp: () -> Unit,
    private val onClose: (() -> Unit)? = null,
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val mainHandler = Handler(Looper.getMainLooper())
    private val touchSlop = ViewConfiguration.get(context).scaledTouchSlop

    private var rootContainer: FrameLayout? = null
    private var pillView: LinearLayout? = null
    private var boxView: LinearLayout? = null
    private var windowParams: WindowManager.LayoutParams? = null

    private var currentState = NotificationPlaybackState()
    private var isExpanded = false
    private var lastOrientation = context.resources.configuration.orientation

    // Saved custom pill coordinates per orientation so user can drag away from any HUD element
    private var savedPortraitPos: Pair<Int, Int>? = null
    private var savedLandscapePos: Pair<Int, Int>? = null

    // Collapsed pill views
    private var pillDotView: View? = null
    private var pillTitleView: TextView? = null
    private val pillEqBars = mutableListOf<View>()

    // Expanded box views
    private var boxTitleView: TextView? = null
    private var boxMetaView: TextView? = null
    private var boxPosView: TextView? = null
    private var boxLenView: TextView? = null
    private var boxProgressTrack: FrameLayout? = null
    private var boxProgressFill: View? = null
    private var boxPlayIcon: ImageView? = null
    private var boxPlayLabel: TextView? = null
    private val boxEqBars = mutableListOf<View>()

    private var eqTick = 0

    private val eqRunnable = object : Runnable {
        override fun run() {
            if (rootContainer == null) return
            animateEqualizer()
            mainHandler.postDelayed(this, 180L)
        }
    }

    private val autoDimRunnable = Runnable {
        if (!isExpanded) {
            pillView?.animate()?.alpha(0.62f)?.setDuration(300L)?.start()
        }
    }

    private val autoCollapseRunnable = Runnable {
        if (isExpanded) {
            collapseToPill()
        }
    }

    val isShowing: Boolean
        get() = rootContainer != null

    fun show(state: NotificationPlaybackState) {
        currentState = state
        if (rootContainer != null) {
            renderState()
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            return
        }

        isExpanded = false
        lastOrientation = context.resources.configuration.orientation

        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val (startX, startY) = getTargetPillCoordinates()
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = startX
            y = startY
        }

        val container = buildViews(params)
        try {
            windowManager.addView(container, params)
            rootContainer = container
            windowParams = params
            renderState()
            scheduleIdleDim()
            mainHandler.removeCallbacks(eqRunnable)
            mainHandler.post(eqRunnable)
        } catch (_: Exception) {
            rootContainer = null
            windowParams = null
        }
    }

    fun update(state: NotificationPlaybackState) {
        currentState = state
        if (rootContainer != null) {
            renderState()
        }
    }

    fun onConfigurationChanged(newConfig: Configuration) {
        if (rootContainer == null || windowParams == null) return
        if (newConfig.orientation != lastOrientation) {
            lastOrientation = newConfig.orientation
            applyWindowGeometry()
        }
    }

    fun hide() {
        mainHandler.removeCallbacks(eqRunnable)
        mainHandler.removeCallbacks(autoDimRunnable)
        mainHandler.removeCallbacks(autoCollapseRunnable)
        val view = rootContainer ?: return
        rootContainer = null
        pillView = null
        boxView = null
        windowParams = null
        pillEqBars.clear()
        boxEqBars.clear()
        isExpanded = false
        try {
            windowManager.removeView(view)
        } catch (_: Exception) {
        }
    }

    private fun expandToCenterBox() {
        val container = rootContainer ?: return
        if (isExpanded) return
        isExpanded = true
        mainHandler.removeCallbacks(autoDimRunnable)
        pillView?.alpha = 1f
        pillView?.visibility = View.GONE
        boxView?.visibility = View.VISIBLE
        applyWindowGeometry()
        renderState()
        resetAutoCollapseTimer()
        container.alpha = 0.85f
        container.animate().alpha(1f).setDuration(140L).start()
    }

    private fun collapseToPill() {
        if (!isExpanded || rootContainer == null) return
        isExpanded = false
        mainHandler.removeCallbacks(autoCollapseRunnable)
        boxView?.visibility = View.GONE
        pillView?.visibility = View.VISIBLE
        pillView?.alpha = 1f
        applyWindowGeometry()
        renderState()
        scheduleIdleDim()
    }

    private fun applyWindowGeometry() {
        val container = rootContainer ?: return
        val params = windowParams ?: return
        val metrics = context.resources.displayMetrics

        if (isExpanded) {
            val boxWidth = dp(312).coerceAtMost((metrics.widthPixels * 0.88f).toInt())
            params.width = boxWidth
            params.height = WindowManager.LayoutParams.WRAP_CONTENT
            params.x = ((metrics.widthPixels - boxWidth) / 2).coerceAtLeast(dp(8))
            params.y = ((metrics.heightPixels - dp(156)) / 2).coerceAtLeast(dp(16))
        } else {
            val (px, py) = getTargetPillCoordinates()
            params.width = WindowManager.LayoutParams.WRAP_CONTENT
            params.height = WindowManager.LayoutParams.WRAP_CONTENT
            params.x = px
            params.y = py
        }

        try {
            windowManager.updateViewLayout(container, params)
        } catch (_: Exception) {
        }
    }

    private fun getTargetPillCoordinates(): Pair<Int, Int> {
        val isLandscape =
            context.resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE
        val saved = if (isLandscape) savedLandscapePos else savedPortraitPos
        if (saved != null) return saved

        val metrics = context.resources.displayMetrics
        // Top-Center safe zone: right against top edge in the middle so top-left minimap
        // and top-right FPS/settings in games are 100% unobstructed.
        val estimatedPillWidth = dp(152)
        val centerX = ((metrics.widthPixels - estimatedPillWidth) / 2).coerceAtLeast(dp(12))
        val topSafeY = if (isLandscape) dp(6) else dp(34)
        return Pair(centerX, topSafeY)
    }

    private fun saveCurrentPillCoordinates(x: Int, y: Int) {
        val isLandscape =
            context.resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE
        if (isLandscape) {
            savedLandscapePos = Pair(x, y)
        } else {
            savedPortraitPos = Pair(x, y)
        }
    }

    private fun scheduleIdleDim() {
        mainHandler.removeCallbacks(autoDimRunnable)
        mainHandler.postDelayed(autoDimRunnable, 3200L)
    }

    private fun resetAutoCollapseTimer() {
        mainHandler.removeCallbacks(autoCollapseRunnable)
        mainHandler.postDelayed(autoCollapseRunnable, 5500L)
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun buildViews(params: WindowManager.LayoutParams): FrameLayout {
        pillEqBars.clear()
        boxEqBars.clear()

        val root = FrameLayout(context).apply {
            setOnTouchListener { _, event ->
                if (event.actionMasked == MotionEvent.ACTION_OUTSIDE && isExpanded) {
                    collapseToPill()
                }
                false
            }
        }

        // =====================================================================
        // 1. SLIM COLLAPSED CAPSULE (Game-safe, translucent, draggable)
        // =====================================================================
        val pill = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            background = roundedDrawable(
                fillColor = COLOR_PILL_GLASS,
                strokeColor = COLOR_CYAN_BORDER,
                radiusPx = dp(999),
                strokePx = dp(1)
            )
            setPadding(dp(10), dp(5), dp(10), dp(5))
            elevation = dp(6).toFloat()
        }

        val dot = View(context).apply {
            background = roundedDrawable(COLOR_CYAN, 0, dp(99), 0)
        }
        pillDotView = dot
        pill.addView(dot, LinearLayout.LayoutParams(dp(6.5f), dp(6.5f)))

        val pTitle = monoText(sizeSp = 10.5f, color = COLOR_TITLE_ICE, bold = true).apply {
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
            setPadding(dp(7), 0, dp(7), 0)
            maxWidth = dp(108)
        }
        pillTitleView = pTitle
        pill.addView(
            pTitle,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        val miniEqRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.BOTTOM
        }
        val pillBarColors = intArrayOf(COLOR_CYAN, COLOR_GREEN, COLOR_PINK)
        val pillInitHeights = intArrayOf(9, 13, 7)
        for (i in pillBarColors.indices) {
            val bar = View(context).apply {
                background = roundedDrawable(pillBarColors[i], 0, dp(1.5f), 0)
            }
            pillEqBars.add(bar)
            val lp = LinearLayout.LayoutParams(dp(3), dp(pillInitHeights[i])).apply {
                if (i < pillBarColors.lastIndex) marginEnd = dp(2)
            }
            miniEqRow.addView(bar, lp)
        }
        pill.addView(miniEqRow, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, dp(14)))

        // Drag or Tap listener on Collapsed Pill
        var startX = 0
        var startY = 0
        var downRawX = 0f
        var downRawY = 0f
        var dragging = false
        pill.setOnTouchListener { _, event ->
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    mainHandler.removeCallbacks(autoDimRunnable)
                    pill.animate().cancel()
                    pill.alpha = 1f
                    startX = params.x
                    startY = params.y
                    downRawX = event.rawX
                    downRawY = event.rawY
                    dragging = false
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = (event.rawX - downRawX).toInt()
                    val dy = (event.rawY - downRawY).toInt()
                    if (!dragging && (abs(dx) > touchSlop || abs(dy) > touchSlop)) {
                        dragging = true
                    }
                    if (dragging && rootContainer != null) {
                        val metrics = context.resources.displayMetrics
                        val maxX = (metrics.widthPixels - pill.width).coerceAtLeast(0)
                        val maxY = (metrics.heightPixels - pill.height).coerceAtLeast(0)
                        params.x = (startX + dx).coerceIn(0, maxX)
                        params.y = (startY + dy).coerceIn(0, maxY)
                        saveCurrentPillCoordinates(params.x, params.y)
                        try {
                            windowManager.updateViewLayout(rootContainer, params)
                        } catch (_: Exception) {
                        }
                    }
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (!dragging) {
                        expandToCenterBox()
                    } else {
                        scheduleIdleDim()
                    }
                    true
                }
                else -> false
            }
        }

        pillView = pill
        root.addView(
            pill,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
        )

        // =====================================================================
        // 2. EXPANDED PREMIUM MUSIC BOX (Center Screen)
        // =====================================================================
        val box = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            visibility = View.GONE
            background = roundedDrawable(
                fillColor = COLOR_BOX_GLASS,
                strokeColor = COLOR_CYAN_BORDER_BRIGHT,
                radiusPx = dp(18),
                strokePx = dp(1.2f)
            )
            setPadding(dp(13), dp(12), dp(13), dp(12))
            elevation = dp(12).toFloat()
        }

        // Top Row: Waveform + Title/Meta + 4-Bar Visualizer + Minimize [—]
        val topRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val waveIcon = ImageView(context).apply {
            setImageResource(R.drawable.ic_waveform_cyan)
        }
        topRow.addView(waveIcon, LinearLayout.LayoutParams(dp(22), dp(22)))

        val titleCol = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            isClickable = true
            setOnClickListener {
                collapseToPill()
                onOpenApp()
            }
        }
        val bTitle = monoText(sizeSp = 13f, color = COLOR_TITLE_ICE, bold = true).apply {
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
        }
        boxTitleView = bTitle
        val bMeta = monoText(sizeSp = 10f, color = COLOR_TEXT_META, bold = true).apply {
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
        }
        boxMetaView = bMeta
        titleCol.addView(bTitle)
        titleCol.addView(
            bMeta,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = dp(2) }
        )

        topRow.addView(
            titleCol,
            LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f).apply {
                marginStart = dp(9)
                marginEnd = dp(8)
            }
        )

        val boxEqRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.BOTTOM
        }
        val boxBarColors = intArrayOf(COLOR_CYAN, COLOR_GREEN, COLOR_LIGHT_CYAN, COLOR_PINK)
        val boxInitHeights = intArrayOf(12, 18, 9, 15)
        for (i in boxBarColors.indices) {
            val bar = View(context).apply {
                background = roundedDrawable(boxBarColors[i], 0, dp(1.5f), 0)
            }
            boxEqBars.add(bar)
            val lp = LinearLayout.LayoutParams(dp(3.5f), dp(boxInitHeights[i])).apply {
                if (i < boxBarColors.lastIndex) marginEnd = dp(2.5f)
            }
            boxEqRow.addView(bar, lp)
        }
        topRow.addView(
            boxEqRow,
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, dp(20)).apply {
                marginEnd = dp(9)
            }
        )

        val minBtn = monoText(sizeSp = 12f, color = COLOR_TEXT_SUBTLE, bold = true).apply {
            text = "—"
            gravity = Gravity.CENTER
            background = roundedDrawable(COLOR_BTN_DARK, COLOR_BTN_DARK_BORDER, dp(8), dp(1))
            isClickable = true
            setOnClickListener { collapseToPill() }
        }
        topRow.addView(minBtn, LinearLayout.LayoutParams(dp(28), dp(26)))

        val closeBtn = monoText(sizeSp = 12f, color = COLOR_PINK, bold = true).apply {
            text = "✕"
            gravity = Gravity.CENTER
            background = roundedDrawable(COLOR_BTN_DARK, COLOR_BTN_DARK_BORDER, dp(8), dp(1))
            isClickable = true
            setOnClickListener {
                hide()
                onClose?.invoke()
            }
        }
        topRow.addView(
            closeBtn,
            LinearLayout.LayoutParams(dp(28), dp(26)).apply { marginStart = dp(5) }
        )

        box.addView(
            topRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        // Middle Row: Elapsed Time (01:24) + Progress Bar + Total Duration (04:02)
        val progressRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val bPos = monoText(sizeSp = 10.5f, color = COLOR_CYAN, bold = true).apply {
            text = "00:00"
        }
        boxPosView = bPos

        val track = FrameLayout(context).apply {
            background = roundedDrawable(COLOR_PROGRESS_BG, 0, dp(3), 0)
        }
        boxProgressTrack = track
        val fill = View(context).apply {
            background = roundedDrawable(COLOR_CYAN, 0, dp(3), 0)
        }
        boxProgressFill = fill
        track.addView(fill, FrameLayout.LayoutParams(0, FrameLayout.LayoutParams.MATCH_PARENT))

        val bLen = monoText(sizeSp = 10.5f, color = COLOR_TEXT_META, bold = true).apply {
            text = "04:00"
        }
        boxLenView = bLen

        progressRow.addView(bPos)
        progressRow.addView(
            track,
            LinearLayout.LayoutParams(0, dp(5), 1f).apply {
                marginStart = dp(9)
                marginEnd = dp(9)
            }
        )
        progressRow.addView(bLen)

        box.addView(
            progressRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(11)
                bottomMargin = dp(11)
            }
        )

        // Bottom Row: [ ◁◁ PREV ]   [ ▯▯ PAUSE ]   [ NEXT ▷▷ ]
        val controlsRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val prevBtn = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            background = roundedDrawable(COLOR_BTN_DARK, COLOR_BTN_DARK_BORDER, dp(10), dp(1))
            isClickable = true
            setOnClickListener {
                resetAutoCollapseTimer()
                onPrevious()
            }
            val icon = ImageView(context).apply {
                setImageResource(R.drawable.ic_skip_prev_cyan)
            }
            val label = monoText(sizeSp = 11f, color = COLOR_CYAN_SOFT, bold = true).apply {
                text = "PREV"
                setPadding(dp(4), 0, 0, 0)
            }
            addView(icon, LinearLayout.LayoutParams(dp(15), dp(15)))
            addView(label)
        }

        val playPauseBtn = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            background = roundedDrawable(COLOR_CYAN, 0, dp(10), 0)
            isClickable = true
            setOnClickListener {
                resetAutoCollapseTimer()
                onPlayPause()
            }
            val icon = ImageView(context).apply {
                setImageResource(R.drawable.ic_pause_dark)
            }
            boxPlayIcon = icon
            val label = monoText(sizeSp = 11.5f, color = COLOR_DARK_INK, bold = true).apply {
                text = "PAUSE"
                setPadding(dp(5), 0, 0, 0)
            }
            boxPlayLabel = label
            addView(icon, LinearLayout.LayoutParams(dp(14), dp(14)))
            addView(label)
        }

        val nextBtn = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            background = roundedDrawable(COLOR_BTN_DARK, COLOR_BTN_DARK_BORDER, dp(10), dp(1))
            isClickable = true
            setOnClickListener {
                resetAutoCollapseTimer()
                onNext()
            }
            val label = monoText(sizeSp = 11f, color = COLOR_CYAN_SOFT, bold = true).apply {
                text = "NEXT"
                setPadding(0, 0, dp(4), 0)
            }
            val icon = ImageView(context).apply {
                setImageResource(R.drawable.ic_skip_next_cyan)
            }
            addView(label)
            addView(icon, LinearLayout.LayoutParams(dp(15), dp(15)))
        }

        controlsRow.addView(prevBtn, LinearLayout.LayoutParams(0, dp(36), 1f))
        controlsRow.addView(
            playPauseBtn,
            LinearLayout.LayoutParams(0, dp(36), 1.25f).apply {
                marginStart = dp(7)
                marginEnd = dp(7)
            }
        )
        controlsRow.addView(nextBtn, LinearLayout.LayoutParams(0, dp(36), 1f))

        box.addView(
            controlsRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        boxView = box
        root.addView(
            box,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
        )

        return root
    }

    private fun renderState() {
        val st = currentState
        val cleanShortTitle = sanitizeToken(
            st.title.replace("(Melody)", "", ignoreCase = true).trim(),
            maxLen = 14
        )
        val cleanFullTitle = sanitizeToken(
            st.title.replace("(Melody)", "", ignoreCase = true).trim(),
            maxLen = 19
        )
        val ext = if (st.isMelody) "XM" else "MP3"

        pillTitleView?.text = cleanShortTitle
        pillDotView?.background = roundedDrawable(
            if (st.isPlaying) COLOR_CYAN else COLOR_PINK,
            0,
            dp(99),
            0
        )

        boxTitleView?.text = "$cleanFullTitle.$ext"

        val rawArtist = st.artist.split("//").firstOrNull()?.trim() ?: st.artist
        val cleanArtist = sanitizeToken(rawArtist, maxLen = 14)
        val bpm = 96 + (abs(st.title.hashCode()) % 42)
        val ch = when {
            st.isMelody -> "4-CH SYNTH"
            st.is8Bit -> "4-CH 8BIT"
            else -> "16-CH PCM"
        }
        boxMetaView?.text = "$bpm BPM • $ch • $cleanArtist"

        boxPosView?.text = formatTime(st.positionSec)
        boxLenView?.text = formatTime(st.durationSec)

        boxPlayIcon?.setImageResource(
            if (st.isPlaying) R.drawable.ic_pause_dark else R.drawable.ic_play_dark
        )
        boxPlayLabel?.text = if (st.isPlaying) "PAUSE" else "PLAY"

        val track = boxProgressTrack
        val fill = boxProgressFill
        if (track != null && fill != null) {
            track.post {
                val totalW = track.width
                val ratio = if (st.durationSec > 0) {
                    (st.positionSec.toFloat() / st.durationSec.toFloat()).coerceIn(0f, 1f)
                } else {
                    0f
                }
                val lp = fill.layoutParams
                lp.width = (totalW * ratio).toInt()
                fill.layoutParams = lp
            }
        }
    }

    private fun animateEqualizer() {
        eqTick++
        for (i in pillEqBars.indices) {
            val bar = pillEqBars[i]
            val h = if (!currentState.isPlaying) {
                3
            } else {
                (5 + ((eqTick * (i + 3) + Random.nextInt(9)) % 9)).coerceIn(4, 13)
            }
            val lp = bar.layoutParams
            lp.height = dp(h)
            bar.layoutParams = lp
        }

        if (isExpanded) {
            for (i in boxEqBars.indices) {
                val bar = boxEqBars[i]
                val h = if (!currentState.isPlaying) {
                    4
                } else {
                    (6 + ((eqTick * (i + 4) + Random.nextInt(13)) % 14)).coerceIn(5, 19)
                }
                val lp = bar.layoutParams
                lp.height = dp(h)
                bar.layoutParams = lp
            }
        }
    }

    private fun monoText(sizeSp: Float, color: Int, bold: Boolean): TextView {
        return TextView(context).apply {
            typeface = Typeface.create(
                Typeface.MONOSPACE,
                if (bold) Typeface.BOLD else Typeface.NORMAL
            )
            setTextSize(TypedValue.COMPLEX_UNIT_SP, sizeSp)
            setTextColor(color)
        }
    }

    private fun roundedDrawable(
        fillColor: Int,
        strokeColor: Int,
        radiusPx: Int,
        strokePx: Int
    ): GradientDrawable {
        return GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            setColor(fillColor)
            cornerRadius = radiusPx.toFloat()
            if (strokePx > 0 && strokeColor != 0) {
                setStroke(strokePx, strokeColor)
            }
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

    private fun dp(value: Int): Int =
        TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value.toFloat(),
            context.resources.displayMetrics
        ).toInt()

    private fun dp(value: Float): Int =
        TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value,
            context.resources.displayMetrics
        ).toInt()

    companion object {
        private val COLOR_PILL_GLASS: Int = 0xD80B0E15.toInt()
        private val COLOR_BOX_GLASS: Int = 0xF30B0E15.toInt()
        private val COLOR_CYAN_BORDER: Int = 0x661CE5FF
        private val COLOR_CYAN_BORDER_BRIGHT: Int = 0x881CE5FF.toInt()
        private val COLOR_BTN_DARK: Int = 0xFF1B202C.toInt()
        private val COLOR_BTN_DARK_BORDER: Int = 0xFF283142.toInt()
        private val COLOR_PROGRESS_BG: Int = 0xFF171E2B.toInt()
        private val COLOR_CYAN: Int = 0xFF1CE5FF.toInt()
        private val COLOR_CYAN_SOFT: Int = 0xFF4DE8FF.toInt()
        private val COLOR_LIGHT_CYAN: Int = 0xFF5CEBFF.toInt()
        private val COLOR_GREEN: Int = 0xFF7CFF4F.toInt()
        private val COLOR_PINK: Int = 0xFFFFA4B8.toInt()
        private val COLOR_DARK_INK: Int = 0xFF06131A.toInt()
        private val COLOR_TITLE_ICE: Int = 0xFFA4EEF9.toInt()
        private val COLOR_TEXT_META: Int = 0xFF6D8299.toInt()
        private val COLOR_TEXT_SUBTLE: Int = 0xFF9FB2C8.toInt()
    }
}

