package com.example.my_music

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import java.util.concurrent.Executors
import kotlin.math.PI
import kotlin.math.exp
import kotlin.math.sin

object RetroSfxPlayer {
    private const val SAMPLE_RATE = 22050

    private val executor = Executors.newSingleThreadExecutor { runnable ->
        Thread(runnable, "BitBeatRetroSfx").apply { isDaemon = true }
    }

    // Subtle, warm 8-bit chiptune micro-blips (12ms - 22ms) with smooth envelope
    private val tapPcm: ShortArray by lazy {
        synthesizeBlip(
            segments = listOf(ToneSegment(freqHz = 880.0, durationMs = 11, duty = 0.5)),
            peakGain = 0.11
        )
    }

    private val toggleOnPcm: ShortArray by lazy {
        synthesizeBlip(
            segments = listOf(
                ToneSegment(freqHz = 660.0, durationMs = 9, duty = 0.25),
                ToneSegment(freqHz = 990.0, durationMs = 11, duty = 0.5)
            ),
            peakGain = 0.12
        )
    }

    private val toggleOffPcm: ShortArray by lazy {
        synthesizeBlip(
            segments = listOf(
                ToneSegment(freqHz = 880.0, durationMs = 9, duty = 0.5),
                ToneSegment(freqHz = 587.33, durationMs = 11, duty = 0.25)
            ),
            peakGain = 0.11
        )
    }

    private val transportPcm: ShortArray by lazy {
        synthesizeBlip(
            segments = listOf(
                ToneSegment(freqHz = 523.25, durationMs = 8, duty = 0.5),
                ToneSegment(freqHz = 783.99, durationMs = 12, duty = 0.5)
            ),
            peakGain = 0.14
        )
    }

    fun play(style: String) {
        val pcm = when (style) {
            "toggleOn" -> toggleOnPcm
            "toggleOff" -> toggleOffPcm
            "transport" -> transportPcm
            else -> tapPcm
        }

        executor.execute {
            var track: AudioTrack? = null
            try {
                val byteSize = pcm.size * 2
                track = AudioTrack.Builder()
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                    .setAudioFormat(
                        AudioFormat.Builder()
                            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                            .setSampleRate(SAMPLE_RATE)
                            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                            .build()
                    )
                    .setBufferSizeInBytes(byteSize.coerceAtLeast(1024))
                    .setTransferMode(AudioTrack.MODE_STATIC)
                    .build()

                track.write(pcm, 0, pcm.size)
                track.play()
                val durationMs = (pcm.size * 1000L) / SAMPLE_RATE + 18L
                Thread.sleep(durationMs)
            } catch (_: Exception) {
            } finally {
                try {
                    track?.stop()
                } catch (_: Exception) {
                }
                try {
                    track?.release()
                } catch (_: Exception) {
                }
            }
        }
    }

    private data class ToneSegment(
        val freqHz: Double,
        val durationMs: Int,
        val duty: Double,
    )

    private fun synthesizeBlip(
        segments: List<ToneSegment>,
        peakGain: Double,
    ): ShortArray {
        val totalSamples = segments.sumOf { (SAMPLE_RATE * it.durationMs) / 1000 }.coerceAtLeast(1)
        val out = ShortArray(totalSamples)
        var cursor = 0
        var phase = 0.0

        for (seg in segments) {
            val segSamples = (SAMPLE_RATE * seg.durationMs) / 1000
            val phaseStep = seg.freqHz / SAMPLE_RATE
            val attackSamples = (SAMPLE_RATE * 0.0015).toInt().coerceAtLeast(1)

            for (i in 0 until segSamples) {
                if (cursor >= totalSamples) break
                phase = (phase + phaseStep) % 1.0

                // Blend 8-bit pulse wave with soft fundamental sine so it sounds crisp, not harsh
                val pulse = if (phase < seg.duty) 1.0 else -1.0
                val fundamental = sin(2.0 * PI * phase)
                val rawWave = (pulse * 0.65) + (fundamental * 0.35)

                // Quantize to 16 steps for authentic 4-bit/8-bit DAC texture
                val quantized = (rawWave * 8.0).toInt() / 8.0

                val attackEnv = if (i < attackSamples) i.toDouble() / attackSamples else 1.0
                val progress = i.toDouble() / segSamples.coerceAtLeast(1)
                val decayEnv = exp(-3.4 * progress)

                val sample = (quantized * peakGain * attackEnv * decayEnv * Short.MAX_VALUE)
                    .toInt()
                    .coerceIn(Short.MIN_VALUE.toInt(), Short.MAX_VALUE.toInt())
                    .toShort()
                out[cursor++] = sample
            }
        }
        return out
    }
}

