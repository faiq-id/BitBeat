import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/track.dart';

part 'player_state.freezed.dart';

enum PlaybackStatus { ready, loading, playing, paused, completed, failure }

enum SleepTimerMode { off, min15, min30, min60, endOfTrack }

@freezed
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    required Track track,
    @Default(TrackCategory.original) TrackCategory category,
    @Default(PlaybackStatus.ready) PlaybackStatus status,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
    @Default(0.85) double volume,
    @Default(false) bool isShuffled,
    @Default(false) bool isRepeating,
    @Default(false) bool isPlaylistOpen,
    @Default(false) bool is8BitEnabled,
    @Default(true) bool isStereoEnabled,
    @Default(true) bool isBassEnabled,
    @Default(true) bool isSfxEnabled,
    @Default(false) bool isGamingModeEnabled,
    @Default(SleepTimerMode.off) SleepTimerMode sleepTimerMode,
    Duration? sleepTimerRemaining,
    String? errorMessage,
  }) = _PlayerState;

  const PlayerState._();

  bool get isPlaying => status == PlaybackStatus.playing;

  List<Track> get activePlaylist => tracksForCategory(category);

  Duration get effectiveDuration =>
      duration == Duration.zero ? track.displayDuration : duration;
}
