import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/track.dart';
import 'player_state.dart';

part 'player_event.freezed.dart';

enum PlayerEffect { bit8, stereo, bass }

@freezed
sealed class PlayerEvent with _$PlayerEvent {
  const factory PlayerEvent.started() = PlayerStarted;
  const factory PlayerEvent.playPausePressed() = PlayerPlayPausePressed;
  const factory PlayerEvent.restartPressed() = PlayerRestartPressed;
  const factory PlayerEvent.nextTrackPressed() = PlayerNextTrackPressed;
  const factory PlayerEvent.previousTrackPressed() = PlayerPreviousTrackPressed;
  const factory PlayerEvent.trackSelected(int index) = PlayerTrackSelected;
  const factory PlayerEvent.categoryChanged(TrackCategory category) =
      PlayerCategoryChanged;
  const factory PlayerEvent.seekRequested(Duration position) =
      PlayerSeekRequested;
  const factory PlayerEvent.volumeChanged(double value) = PlayerVolumeChanged;
  const factory PlayerEvent.shuffleToggled() = PlayerShuffleToggled;
  const factory PlayerEvent.repeatToggled() = PlayerRepeatToggled;
  const factory PlayerEvent.playlistToggled() = PlayerPlaylistToggled;
  const factory PlayerEvent.effectToggled(PlayerEffect effect) =
      PlayerEffectToggled;
  const factory PlayerEvent.sfxToggled() = PlayerSfxToggled;
  const factory PlayerEvent.gamingModeToggled() = PlayerGamingModeToggled;
  const factory PlayerEvent.gamingModeClosed() = PlayerGamingModeClosed;
  const factory PlayerEvent.sleepTimerSelected(SleepTimerMode mode) =
      PlayerSleepTimerSelected;
  const factory PlayerEvent.sleepTimerTicked() = PlayerSleepTimerTicked;
  const factory PlayerEvent.positionChanged(Duration position) =
      PlayerPositionChanged;
  const factory PlayerEvent.durationChanged(Duration? duration) =
      PlayerDurationChanged;
  const factory PlayerEvent.engineStateChanged(
    bool isPlaying,
    bool isCompleted,
  ) = PlayerEngineStateChanged;
}
