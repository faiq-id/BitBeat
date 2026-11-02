import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

import '../domain/track.dart';

enum OverlayCommandType {
  play,
  pause,
  playPause,
  previous,
  next,
  seekTo,
  close,
  gamingModeClosed,
}

class OverlayCommand {
  const OverlayCommand(this.type, {this.seekPosition});

  final OverlayCommandType type;
  final Duration? seekPosition;
}

class PlayerEngineSnapshot {
  const PlayerEngineSnapshot({
    required this.isPlaying,
    required this.isCompleted,
  });

  final bool isPlaying;
  final bool isCompleted;
}

/// Small boundary around just_audio so the BLoC stays independent from the
/// playback package and can be tested with a fake implementation later.
class AudioPlayerRepository {
  AudioPlayerRepository({just_audio.AudioPlayer? player})
    : _equalizer = just_audio.AndroidEqualizer(),
      _loudnessEnhancer = just_audio.AndroidLoudnessEnhancer() {
    _player =
        player ??
        just_audio.AudioPlayer(
          handleInterruptions: false,
          handleAudioSessionActivation: false,
          audioPipeline: just_audio.AudioPipeline(
            androidAudioEffects: [_equalizer, _loudnessEnhancer],
          ),
        );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      _foregroundChannel.setMethodCallHandler(_handlePlatformCall);
    }

    _playerStateSubscription = _player.playerStateStream.listen((_) {
      _emitSnapshot();
    });

    _currentIndexSubscription = _player.currentIndexStream.listen((index) {
      if (_isSwitchingPlaylist || _loadedCategory == null || index == null) {
        return;
      }
      final tracks = tracksForCategory(_loadedCategory!);
      if (index >= 0 && index < tracks.length) {
        _emitSnapshot();
      }
    });
  }

  static const _foregroundChannel = MethodChannel('bitbeat/foreground_service');

  late final just_audio.AudioPlayer _player;
  final just_audio.AndroidEqualizer _equalizer;
  final just_audio.AndroidLoudnessEnhancer _loudnessEnhancer;
  final _engineController = StreamController<PlayerEngineSnapshot>.broadcast();
  final _overlayCommandController =
      StreamController<OverlayCommand>.broadcast();

  StreamSubscription<just_audio.PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;

  TrackCategory? _loadedCategory;
  bool _isRepeating = false;
  bool _isShuffled = false;
  bool _isSwitchingPlaylist = false;
  double _targetEffectiveVolume = 0.85;
  int _fadeToken = 0;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerEngineSnapshot> get engineStateStream =>
      _engineController.stream;
  Stream<OverlayCommand> get overlayCommandStream =>
      _overlayCommandController.stream;

  Duration? get currentDuration => _player.duration;
  bool get isPlaylistLoaded => _loadedCategory != null;

  /// Returns the currently active [Track] inside the native ExoPlayer queue,
  /// used when ExoPlayer auto-advances to the next track in the background.
  Track? get activeEngineTrack {
    if (_isSwitchingPlaylist || _loadedCategory == null) return null;
    final idx = _player.currentIndex;
    if (idx == null) return null;
    final tracks = tracksForCategory(_loadedCategory!);
    if (idx < 0 || idx >= tracks.length) return null;
    return tracks[idx];
  }

  Future<void> _handlePlatformCall(MethodCall call) async {
    if (_overlayCommandController.isClosed) return;

    String? command;
    int? positionMs;

    if (call.method == 'onMediaCommand') {
      final raw = call.arguments;
      if (raw is Map) {
        command = raw['command'] as String?;
        final pos = raw['positionMs'];
        if (pos is num) {
          positionMs = pos.toInt();
        }
      }
    } else if (call.method == 'onOverlayCommand') {
      command = call.arguments as String?;
    } else {
      return;
    }

    switch (command) {
      case 'play':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.play),
        );
      case 'pause':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.pause),
        );
      case 'playPause':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.playPause),
        );
      case 'previous':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.previous),
        );
      case 'next':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.next),
        );
      case 'seekTo':
        _overlayCommandController.add(
          OverlayCommand(
            OverlayCommandType.seekTo,
            seekPosition: Duration(milliseconds: positionMs ?? 0),
          ),
        );
      case 'close':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.close),
        );
      case 'gamingModeClosed':
        _overlayCommandController.add(
          const OverlayCommand(OverlayCommandType.gamingModeClosed),
        );
    }
  }

  void _emitSnapshot() {
    if (_engineController.isClosed) return;
    _engineController.add(
      PlayerEngineSnapshot(
        isPlaying: _player.playing,
        isCompleted:
            _player.processingState == just_audio.ProcessingState.completed,
      ),
    );
  }

  Future<void> ensureOverlayPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _foregroundChannel.invokeMethod<bool>('ensureOverlayPermission');
    } catch (_) {}
  }

  Future<void> setGamingMode(bool enabled) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _foregroundChannel.invokeMethod<void>('setGamingMode', {
        'enabled': enabled,
      });
    } catch (_) {}
  }

  Future<void> syncOverlayState({
    required Track track,
    required bool isPlaying,
    required Duration position,
    required Duration duration,
    required bool is8BitEnabled,
    bool isGamingMode = false,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _foregroundChannel.invokeMethod<void>('updateState', {
        'title': track.title,
        'artist': track.artist,
        'isPlaying': isPlaying,
        'positionSec': position.inSeconds,
        'durationSec': duration.inSeconds,
        'is8Bit': is8BitEnabled,
        'isMelody': track.category == TrackCategory.melody,
        'isGamingMode': isGamingMode,
      });
    } catch (_) {}
  }

  Future<void> stopForegroundService() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _foregroundChannel.invokeMethod<void>('stop');
    } catch (_) {}
  }

  Future<void> moveToBackground() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _foregroundChannel.invokeMethod<void>('moveToBackground');
    } catch (_) {}
  }

  Future<void> _ensureTrackQueued(
    Track track, {
    Duration initialPosition = Duration.zero,
  }) async {
    final tracks = tracksForCategory(track.category);
    final foundIndex = tracks.indexWhere((t) => t.id == track.id);
    final targetIndex = foundIndex < 0 ? 0 : foundIndex;

    _isSwitchingPlaylist = true;
    try {
      if (_loadedCategory != track.category ||
          _player.audioSources.length != tracks.length) {
        await _player.setAudioSources(
          [
            for (final item in tracks)
              just_audio.AudioSource.asset(item.assetPath, tag: item.id),
          ],
          initialIndex: targetIndex,
          initialPosition: initialPosition,
        );
        await _player.setLoopMode(
          _isRepeating ? just_audio.LoopMode.one : just_audio.LoopMode.all,
        );
        await _player.setShuffleModeEnabled(_isShuffled);
        if (_isShuffled) {
          await _player.shuffle();
        }
        _loadedCategory = track.category;
      } else if (_player.currentIndex != targetIndex) {
        await _player.seek(initialPosition, index: targetIndex);
      }
    } finally {
      _isSwitchingPlaylist = false;
    }
  }

  Future<void> _rampVolume({
    required double from,
    required double to,
    required Duration duration,
    required int steps,
    required int token,
  }) async {
    if (steps <= 1 || duration <= Duration.zero) {
      if (token == _fadeToken) {
        try {
          await _player.setVolume(to.clamp(0.0, 1.0).toDouble());
        } catch (_) {}
      }
      return;
    }

    final stepDelayMs = (duration.inMilliseconds / steps).round().clamp(10, 200);
    for (var i = 1; i <= steps; i++) {
      if (token != _fadeToken) return;
      final t = i / steps;
      final eased = t * t * (3.0 - 2.0 * t);
      final nextVol = (from + (to - from) * eased).clamp(0.0, 1.0).toDouble();
      try {
        await _player.setVolume(nextVol);
      } catch (_) {}
      if (i < steps) {
        await Future<void>.delayed(Duration(milliseconds: stepDelayMs));
      }
    }
  }

  Future<void> prepareTrack(
    Track track, {
    Duration initialPosition = Duration.zero,
  }) => _ensureTrackQueued(track, initialPosition: initialPosition);

  Future<void> play(
    Track track, {
    Duration initialPosition = Duration.zero,
  }) async {
    final token = ++_fadeToken;
    final wasPlaying = _player.playing;

    if (wasPlaying) {
      await _rampVolume(
        from: _player.volume,
        to: 0.0,
        duration: const Duration(milliseconds: 130),
        steps: 5,
        token: token,
      );
      if (token != _fadeToken) return;
    } else {
      try {
        await _player.setVolume(0.0);
      } catch (_) {}
    }

    await _ensureTrackQueued(track, initialPosition: initialPosition);
    if (token != _fadeToken) return;

    unawaited(_player.play());
    unawaited(
      _rampVolume(
        from: 0.0,
        to: _targetEffectiveVolume,
        duration: const Duration(milliseconds: 240),
        steps: 8,
        token: token,
      ),
    );
  }

  Future<void> pause({bool gentleSleepFade = false}) async {
    final token = ++_fadeToken;
    if (_player.playing) {
      await _rampVolume(
        from: _player.volume,
        to: 0.0,
        duration: gentleSleepFade
            ? const Duration(milliseconds: 1400)
            : const Duration(milliseconds: 170),
        steps: gentleSleepFade ? 14 : 6,
        token: token,
      );
      if (token != _fadeToken) return;
    }
    await _player.pause();
    if (token == _fadeToken) {
      try {
        await _player.setVolume(_targetEffectiveVolume);
      } catch (_) {}
    }
  }

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setVolume(double value) {
    ++_fadeToken;
    _targetEffectiveVolume = value.clamp(0.0, 1.0).toDouble();
    return _player.setVolume(_targetEffectiveVolume);
  }

  Future<void> setLooping(bool enabled) async {
    _isRepeating = enabled;
    await _player.setLoopMode(
      enabled ? just_audio.LoopMode.one : just_audio.LoopMode.all,
    );
  }

  Future<void> setShuffle(bool enabled) async {
    _isShuffled = enabled;
    await _player.setShuffleModeEnabled(enabled);
    if (enabled) {
      await _player.shuffle();
    }
  }

  /// Applies real-time DSP effects (8-BIT pitch/timbre, STEREO air/imaging,
  /// and BASS low-end boost + loudness enhancement) to the underlying player.
  Future<void> applyEffects({
    required bool is8BitEnabled,
    required bool isStereoEnabled,
    required bool isBassEnabled,
    required double baseVolume,
    bool immediateVolume = true,
  }) async {
    // 1. 8-BIT mode adjusts playback speed & pitch slightly for a retro
    // chiptune console crystal-clock feel.
    final targetSpeed = is8BitEnabled ? 1.04 : 1.0;
    final targetPitch = is8BitEnabled ? 1.09 : 1.0;

    try {
      await _player.setSpeed(targetSpeed);
    } catch (_) {}

    try {
      await _player.setPitch(targetPitch);
    } catch (_) {}

    // 2. Effective gain shaping across platforms so BASS and STEREO vs MONO
    // produce an audible difference even when hardware EQ is unavailable.
    final bassMultiplier = isBassEnabled ? 1.0 : 0.88;
    final stereoMultiplier = isStereoEnabled ? 1.0 : 0.92;
    final bitMultiplier = is8BitEnabled ? 0.96 : 1.0;
    final effectiveVolume =
        (baseVolume * bassMultiplier * stereoMultiplier * bitMultiplier)
            .clamp(0.0, 1.0)
            .toDouble();
    _targetEffectiveVolume = effectiveVolume;

    if (immediateVolume) {
      ++_fadeToken;
      try {
        await _player.setVolume(effectiveVolume);
      } catch (_) {}
    }

    // 3. Hardware Android DSP pipeline (Equalizer + LoudnessEnhancer)
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final anyEqActive = is8BitEnabled || isStereoEnabled || isBassEnabled;
        await _equalizer.setEnabled(anyEqActive);
        await _loudnessEnhancer.setEnabled(isBassEnabled);
        await _loudnessEnhancer.setTargetGain(isBassEnabled ? 3.5 : 0.0);

        final params = await _equalizer.parameters.timeout(
          const Duration(milliseconds: 250),
        );
        final minDb = params.minDecibels;
        final maxDb = params.maxDecibels;

        for (final band in params.bands) {
          final freq = band.centerFrequency;
          var gain = 0.0;

          if (isBassEnabled) {
            if (freq < 130) {
              gain += maxDb * 0.75;
            } else if (freq < 320) {
              gain += maxDb * 0.40;
            }
          } else {
            if (freq < 130) {
              gain += minDb * 0.25;
            }
          }

          if (is8BitEnabled) {
            // Retro speaker bandpass: roll off deep sub-bass & ultra-highs,
            // emphasize 700Hz - 2.8kHz square-wave mid presence.
            if (freq < 100 && !isBassEnabled) {
              gain += minDb * 0.55;
            } else if (freq >= 600 && freq <= 2800) {
              gain += maxDb * 0.50;
            } else if (freq > 7500) {
              gain += minDb * 0.45;
            }
          }

          if (isStereoEnabled) {
            // Presence & air boost for wider perceived stereo stage.
            if (freq >= 3000) {
              gain += maxDb * 0.35;
            }
          } else {
            // Narrower mono-like roll-off on upper treble.
            if (freq > 4500) {
              gain += minDb * 0.30;
            }
          }

          await band.setGain(gain.clamp(minDb, maxDb).toDouble());
        }
      } catch (_) {
        // Equalizer parameters may not be ready before the first track loads;
        // they will be applied again as soon as playback starts.
      }
    }
  }

  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _currentIndexSubscription?.cancel();
    await _engineController.close();
    await _overlayCommandController.close();
    await stopForegroundService();
    await _player.dispose();
  }
}
