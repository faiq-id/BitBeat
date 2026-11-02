import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/audio_player_repository.dart';
import '../data/player_session_storage.dart';
import '../data/retro_feedback_service.dart';
import '../domain/track.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc({
    required this._audio,
    PlayerSessionStorage? sessionStorage,
    RetroFeedbackService? feedback,
  }) : _sessionStorage = sessionStorage ?? PlayerSessionStorage(),
       _feedback = feedback ?? RetroFeedbackService(),
       super(PlayerState(track: originalTracks.first)) {
    on<PlayerStarted>(_onStarted);
    on<PlayerPlayPausePressed>(_onPlayPausePressed);
    on<PlayerRestartPressed>(_onRestartPressed);
    on<PlayerNextTrackPressed>(_onNextTrackPressed);
    on<PlayerPreviousTrackPressed>(_onPreviousTrackPressed);
    on<PlayerTrackSelected>(_onTrackSelected);
    on<PlayerCategoryChanged>(_onCategoryChanged);
    on<PlayerSeekRequested>(_onSeekRequested);
    on<PlayerVolumeChanged>(_onVolumeChanged);
    on<PlayerShuffleToggled>(_onShuffleToggled);
    on<PlayerRepeatToggled>(_onRepeatToggled);
    on<PlayerPlaylistToggled>(_onPlaylistToggled);
    on<PlayerEffectToggled>(_onEffectToggled);
    on<PlayerSfxToggled>(_onSfxToggled);
    on<PlayerGamingModeToggled>(_onGamingModeToggled);
    on<PlayerGamingModeClosed>(_onGamingModeClosed);
    on<PlayerSleepTimerSelected>(_onSleepTimerSelected);
    on<PlayerSleepTimerTicked>(_onSleepTimerTicked);
    on<PlayerPositionChanged>(_onPositionChanged);
    on<PlayerDurationChanged>(_onDurationChanged);
    on<PlayerEngineStateChanged>(_onEngineStateChanged);
  }

  final AudioPlayerRepository _audio;
  final PlayerSessionStorage _sessionStorage;
  final RetroFeedbackService _feedback;
  final math.Random _random = math.Random();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerEngineSnapshot>? _engineSubscription;
  StreamSubscription<OverlayCommand>? _overlayCommandSubscription;
  Timer? _sleepTimer;
  DateTime? _sleepDeadline;
  bool _endOfTrackFadeTriggered = false;
  int _lastSyncedSecond = -1;
  int _lastSavedPositionSec = -1;

  Future<void> _onStarted(
    PlayerStarted event,
    Emitter<PlayerState> emit,
  ) async {
    final saved = await _sessionStorage.load();
    if (saved != null) {
      final playlist = tracksForCategory(saved.category);
      final restoredTrack = playlist.firstWhere(
        (t) => t.id == saved.trackId,
        orElse: () => playlist.first,
      );
      final maxDuration = restoredTrack.displayDuration;
      final restoredPosition =
          saved.position >= maxDuration - const Duration(seconds: 2)
          ? Duration.zero
          : (saved.position < Duration.zero ? Duration.zero : saved.position);

      _feedback.isEnabled = saved.isSfxEnabled;
      final restoredState = state.copyWith(
        track: restoredTrack,
        category: saved.category,
        position: restoredPosition,
        duration: maxDuration,
        volume: saved.volume,
        isShuffled: saved.isShuffled,
        isRepeating: saved.isRepeating,
        isPlaylistOpen: saved.isPlaylistOpen,
        is8BitEnabled: saved.is8BitEnabled,
        isStereoEnabled: saved.isStereoEnabled,
        isBassEnabled: saved.isBassEnabled,
        isSfxEnabled: saved.isSfxEnabled,
        isGamingModeEnabled: saved.isGamingModeEnabled,
      );
      _lastSavedPositionSec = restoredPosition.inSeconds;
      emit(restoredState);
      if (restoredState.isGamingModeEnabled) {
        unawaited(_audio.setGamingMode(true));
      }
    } else {
      _feedback.isEnabled = state.isSfxEnabled;
    }

    await _audio.setLooping(state.isRepeating);
    await _audio.setShuffle(state.isShuffled);
    try {
      await _audio.prepareTrack(
        state.track,
        initialPosition: state.position,
      );
      final loadedDuration = _audio.currentDuration;
      if (loadedDuration != null && loadedDuration > Duration.zero) {
        emit(state.copyWith(duration: loadedDuration));
      }
    } catch (_) {}
    await _syncEffects(state);

    _positionSubscription = _audio.positionStream.listen(
      (position) => add(PlayerEvent.positionChanged(position)),
    );
    _durationSubscription = _audio.durationStream.listen(
      (duration) => add(PlayerEvent.durationChanged(duration)),
    );
    _engineSubscription = _audio.engineStateStream.listen(
      (snapshot) => add(
        PlayerEvent.engineStateChanged(
          snapshot.isPlaying,
          snapshot.isCompleted,
        ),
      ),
    );
    _overlayCommandSubscription = _audio.overlayCommandStream.listen((command) {
      switch (command.type) {
        case OverlayCommandType.play:
          if (!state.isPlaying) {
            add(const PlayerEvent.playPausePressed());
          }
        case OverlayCommandType.pause:
          if (state.isPlaying) {
            add(const PlayerEvent.playPausePressed());
          }
        case OverlayCommandType.playPause:
          add(const PlayerEvent.playPausePressed());
        case OverlayCommandType.previous:
          add(const PlayerEvent.previousTrackPressed());
        case OverlayCommandType.next:
          add(const PlayerEvent.nextTrackPressed());
        case OverlayCommandType.seekTo:
          final target = command.seekPosition;
          if (target != null) {
            add(PlayerEvent.seekRequested(target));
          }
        case OverlayCommandType.close:
          if (state.isPlaying) {
            add(const PlayerEvent.playPausePressed());
          }
          unawaited(_audio.stopForegroundService());
        case OverlayCommandType.gamingModeClosed:
          add(const PlayerEvent.gamingModeClosed());
      }
    });
  }

  void _syncOverlay(PlayerState target, {bool force = false}) {
    final sec = target.position.inSeconds;
    if (!force && sec == _lastSyncedSecond) return;
    _lastSyncedSecond = sec;
    unawaited(
      _audio.syncOverlayState(
        track: target.track,
        isPlaying: target.isPlaying,
        position: target.position,
        duration: target.effectiveDuration,
        is8BitEnabled: target.is8BitEnabled,
        isGamingMode: target.isGamingModeEnabled,
      ),
    );
  }

  void _persistSession(PlayerState target, {bool force = false}) {
    final sec = target.position.inSeconds;
    if (!force && (sec - _lastSavedPositionSec).abs() < 5) {
      return;
    }
    _lastSavedPositionSec = sec;
    unawaited(
      _sessionStorage.save(
        trackId: target.track.id,
        category: target.category,
        position: target.position,
        volume: target.volume,
        isShuffled: target.isShuffled,
        isRepeating: target.isRepeating,
        isPlaylistOpen: target.isPlaylistOpen,
        is8BitEnabled: target.is8BitEnabled,
        isStereoEnabled: target.isStereoEnabled,
        isBassEnabled: target.isBassEnabled,
        isSfxEnabled: target.isSfxEnabled,
        isGamingModeEnabled: target.isGamingModeEnabled,
      ),
    );
  }

  Future<void> _onPlayPausePressed(
    PlayerPlayPausePressed event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.isPlaying) {
      final pausedState = state.copyWith(status: PlaybackStatus.paused);
      emit(pausedState);
      await _audio.pause();
      _syncOverlay(pausedState, force: true);
      _persistSession(pausedState, force: true);
      return;
    }

    try {
      _endOfTrackFadeTriggered = false;
      final resumePosition = state.position;
      if (state.isGamingModeEnabled) {
        unawaited(_audio.ensureOverlayPermission());
      }
      emit(state.copyWith(status: PlaybackStatus.loading, errorMessage: null));
      await _syncEffects(state, immediateVolume: false);
      await _audio.play(state.track, initialPosition: resumePosition);
      await _syncEffects(state, immediateVolume: false);
      final playingState = state.copyWith(status: PlaybackStatus.playing);
      emit(playingState);
      _syncOverlay(playingState, force: true);
      _persistSession(playingState, force: true);
    } catch (_) {
      emit(
        state.copyWith(
          status: PlaybackStatus.failure,
          errorMessage:
              'File belum ditemukan. Tambahkan ${state.track.assetPath} lalu jalankan ulang aplikasi.',
        ),
      );
    }
  }

  Future<void> _onRestartPressed(
    PlayerRestartPressed event,
    Emitter<PlayerState> emit,
  ) async {
    _endOfTrackFadeTriggered = false;
    await _audio.seek(Duration.zero);
    final nextState = state.copyWith(position: Duration.zero);
    emit(nextState);
    _syncOverlay(nextState, force: true);
    _persistSession(nextState, force: true);
  }

  Future<void> _onNextTrackPressed(
    PlayerNextTrackPressed event,
    Emitter<PlayerState> emit,
  ) async {
    final playlist = state.activePlaylist;
    final currentIndex = playlist.indexWhere((t) => t.id == state.track.id);
    int nextIndex;
    if (state.isShuffled && playlist.length > 1) {
      do {
        nextIndex = _random.nextInt(playlist.length);
      } while (nextIndex == currentIndex);
    } else {
      nextIndex = (currentIndex + 1) % playlist.length;
    }
    await _switchTrack(playlist[nextIndex], emit);
  }

  Future<void> _onPreviousTrackPressed(
    PlayerPreviousTrackPressed event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.position.inSeconds > 3) {
      _endOfTrackFadeTriggered = false;
      await _audio.seek(Duration.zero);
      final resetState = state.copyWith(position: Duration.zero);
      emit(resetState);
      _syncOverlay(resetState, force: true);
      _persistSession(resetState, force: true);
      return;
    }
    final playlist = state.activePlaylist;
    final currentIndex = playlist.indexWhere((t) => t.id == state.track.id);
    final prevIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    await _switchTrack(playlist[prevIndex], emit);
  }

  Future<void> _onTrackSelected(
    PlayerTrackSelected event,
    Emitter<PlayerState> emit,
  ) async {
    final playlist = state.activePlaylist;
    if (event.index < 0 || event.index >= playlist.length) return;
    final targetTrack = playlist[event.index];
    if (targetTrack.id == state.track.id) {
      _endOfTrackFadeTriggered = false;
      if (state.isGamingModeEnabled) {
        unawaited(_audio.ensureOverlayPermission());
      }
      await _audio.seek(Duration.zero);
      if (!state.isPlaying) {
        await _syncEffects(state, immediateVolume: false);
        await _audio.play(targetTrack);
        await _syncEffects(state, immediateVolume: false);
      }
      final playingState = state.copyWith(
        status: PlaybackStatus.playing,
        position: Duration.zero,
      );
      emit(playingState);
      _syncOverlay(playingState, force: true);
      _persistSession(playingState, force: true);
      return;
    }
    await _switchTrack(targetTrack, emit);
  }

  Future<void> _onCategoryChanged(
    PlayerCategoryChanged event,
    Emitter<PlayerState> emit,
  ) async {
    if (event.category == state.category) return;
    final oldPlaylist = state.activePlaylist;
    final newPlaylist = tracksForCategory(event.category);
    final currentIndex = oldPlaylist
        .indexWhere((t) => t.id == state.track.id)
        .clamp(0, newPlaylist.length - 1);
    final targetTrack = newPlaylist[currentIndex];
    final wasPlaying = state.isPlaying;

    final nextState = state.copyWith(
      category: event.category,
      track: targetTrack,
      position: Duration.zero,
      duration: targetTrack.displayDuration,
      status: wasPlaying ? PlaybackStatus.loading : PlaybackStatus.ready,
      errorMessage: null,
    );
    emit(nextState);

    if (wasPlaying) {
      await _switchTrack(targetTrack, emit);
    } else {
      await _audio.pause();
      try {
        await _audio.prepareTrack(targetTrack);
      } catch (_) {}
      _syncOverlay(nextState, force: true);
      _persistSession(nextState, force: true);
    }
  }

  Future<void> _switchTrack(Track target, Emitter<PlayerState> emit) async {
    try {
      _endOfTrackFadeTriggered = false;
      if (state.isGamingModeEnabled) {
        unawaited(_audio.ensureOverlayPermission());
      }
      emit(
        state.copyWith(
          track: target,
          category: target.category,
          status: PlaybackStatus.loading,
          position: Duration.zero,
          duration: target.displayDuration,
          errorMessage: null,
        ),
      );
      await _syncEffects(state, immediateVolume: false);
      await _audio.play(target);
      await _syncEffects(state, immediateVolume: false);
      final playingState = state.copyWith(status: PlaybackStatus.playing);
      emit(playingState);
      _syncOverlay(playingState, force: true);
      _persistSession(playingState, force: true);
    } catch (_) {
      emit(
        state.copyWith(
          status: PlaybackStatus.failure,
          errorMessage:
              'File belum ditemukan. Tambahkan ${target.assetPath} lalu jalankan ulang aplikasi.',
        ),
      );
    }
  }

  Future<void> _onSeekRequested(
    PlayerSeekRequested event,
    Emitter<PlayerState> emit,
  ) async {
    final end = state.effectiveDuration;
    final position = event.position < Duration.zero
        ? Duration.zero
        : event.position > end
        ? end
        : event.position;
    if (position < end - const Duration(seconds: 2)) {
      _endOfTrackFadeTriggered = false;
    }
    await _audio.seek(position);
    final nextState = state.copyWith(position: position);
    emit(nextState);
    _syncOverlay(nextState, force: true);
    _persistSession(nextState, force: true);
  }

  Future<void> _onVolumeChanged(
    PlayerVolumeChanged event,
    Emitter<PlayerState> emit,
  ) async {
    final value = event.value.clamp(0.0, 1.0).toDouble();
    final nextState = state.copyWith(volume: value);
    emit(nextState);
    await _syncEffects(nextState);
    _persistSession(nextState, force: true);
  }

  Future<void> _onShuffleToggled(
    PlayerShuffleToggled event,
    Emitter<PlayerState> emit,
  ) async {
    final enabled = !state.isShuffled;
    final nextState = state.copyWith(isShuffled: enabled);
    emit(nextState);
    await _audio.setShuffle(enabled);
    _persistSession(nextState, force: true);
  }

  Future<void> _onRepeatToggled(
    PlayerRepeatToggled event,
    Emitter<PlayerState> emit,
  ) async {
    final enabled = !state.isRepeating;
    await _audio.setLooping(enabled);
    final nextState = state.copyWith(isRepeating: enabled);
    emit(nextState);
    _persistSession(nextState, force: true);
  }

  void _onPlaylistToggled(
    PlayerPlaylistToggled event,
    Emitter<PlayerState> emit,
  ) {
    final nextState = state.copyWith(isPlaylistOpen: !state.isPlaylistOpen);
    emit(nextState);
    _persistSession(nextState, force: true);
  }

  Future<void> _onEffectToggled(
    PlayerEffectToggled event,
    Emitter<PlayerState> emit,
  ) async {
    final nextState = switch (event.effect) {
      PlayerEffect.bit8 => state.copyWith(is8BitEnabled: !state.is8BitEnabled),
      PlayerEffect.stereo => state.copyWith(
        isStereoEnabled: !state.isStereoEnabled,
      ),
      PlayerEffect.bass => state.copyWith(isBassEnabled: !state.isBassEnabled),
    };
    emit(nextState);
    await _syncEffects(nextState);
    _syncOverlay(nextState, force: true);
    _persistSession(nextState, force: true);
  }

  void _onSfxToggled(
    PlayerSfxToggled event,
    Emitter<PlayerState> emit,
  ) {
    final enabled = !state.isSfxEnabled;
    _feedback.isEnabled = enabled;
    if (enabled) {
      _feedback.trigger(RetroClickStyle.toggleOn);
    }
    final nextState = state.copyWith(isSfxEnabled: enabled);
    emit(nextState);
    _persistSession(nextState, force: true);
  }

  Future<void> _onGamingModeToggled(
    PlayerGamingModeToggled event,
    Emitter<PlayerState> emit,
  ) async {
    final enabled = !state.isGamingModeEnabled;
    _feedback.trigger(
      enabled ? RetroClickStyle.toggleOn : RetroClickStyle.toggleOff,
    );
    if (enabled) {
      unawaited(_audio.ensureOverlayPermission());
    }
    final nextState = state.copyWith(isGamingModeEnabled: enabled);
    emit(nextState);
    await _audio.setGamingMode(enabled);
    _syncOverlay(nextState, force: true);
    _persistSession(nextState, force: true);
  }

  void _onGamingModeClosed(
    PlayerGamingModeClosed event,
    Emitter<PlayerState> emit,
  ) {
    if (!state.isGamingModeEnabled) return;
    final nextState = state.copyWith(isGamingModeEnabled: false);
    emit(nextState);
    _persistSession(nextState, force: true);
  }

  void _onSleepTimerSelected(
    PlayerSleepTimerSelected event,
    Emitter<PlayerState> emit,
  ) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepDeadline = null;
    _endOfTrackFadeTriggered = false;

    final nextMode = event.mode == state.sleepTimerMode
        ? SleepTimerMode.off
        : event.mode;

    if (nextMode == SleepTimerMode.off) {
      emit(
        state.copyWith(
          sleepTimerMode: SleepTimerMode.off,
          sleepTimerRemaining: null,
        ),
      );
      return;
    }

    if (nextMode == SleepTimerMode.endOfTrack) {
      emit(
        state.copyWith(
          sleepTimerMode: SleepTimerMode.endOfTrack,
          sleepTimerRemaining: null,
        ),
      );
      return;
    }

    final duration = switch (nextMode) {
      SleepTimerMode.min15 => const Duration(minutes: 15),
      SleepTimerMode.min30 => const Duration(minutes: 30),
      SleepTimerMode.min60 => const Duration(minutes: 60),
      SleepTimerMode.off || SleepTimerMode.endOfTrack => Duration.zero,
    };

    _sleepDeadline = DateTime.now().add(duration);
    emit(
      state.copyWith(
        sleepTimerMode: nextMode,
        sleepTimerRemaining: duration,
      ),
    );
    _sleepTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const PlayerEvent.sleepTimerTicked()),
    );
  }

  Future<void> _onSleepTimerTicked(
    PlayerSleepTimerTicked event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.sleepTimerMode == SleepTimerMode.endOfTrack &&
        _endOfTrackFadeTriggered) {
      await _expireSleepTimer(emit, resetToStart: true);
      return;
    }

    final deadline = _sleepDeadline;
    if (deadline == null ||
        state.sleepTimerMode == SleepTimerMode.off ||
        state.sleepTimerMode == SleepTimerMode.endOfTrack) {
      return;
    }

    final remaining = deadline.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      await _expireSleepTimer(emit, resetToStart: false);
      return;
    }

    if (state.sleepTimerRemaining?.inSeconds != remaining.inSeconds) {
      emit(state.copyWith(sleepTimerRemaining: remaining));
    }
  }

  Future<void> _expireSleepTimer(
    Emitter<PlayerState> emit, {
    required bool resetToStart,
  }) async {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepDeadline = null;
    _endOfTrackFadeTriggered = false;

    if (state.isPlaying) {
      await _audio.pause(gentleSleepFade: true);
    }
    if (resetToStart) {
      await _audio.seek(Duration.zero);
    }

    final stoppedState = state.copyWith(
      status: PlaybackStatus.paused,
      position: resetToStart ? Duration.zero : state.position,
      sleepTimerMode: SleepTimerMode.off,
      sleepTimerRemaining: null,
    );
    emit(stoppedState);
    _syncOverlay(stoppedState, force: true);
    _persistSession(stoppedState, force: true);
    unawaited(_audio.stopForegroundService());
  }

  Future<void> _syncEffects(
    PlayerState target, {
    bool immediateVolume = true,
  }) => _audio.applyEffects(
    is8BitEnabled: target.is8BitEnabled,
    isStereoEnabled: target.isStereoEnabled,
    isBassEnabled: target.isBassEnabled,
    baseVolume: target.volume,
    immediateVolume: immediateVolume,
  );

  void _onPositionChanged(
    PlayerPositionChanged event,
    Emitter<PlayerState> emit,
  ) {
    if (state.status == PlaybackStatus.ready &&
        !_audio.isPlaylistLoaded &&
        event.position == Duration.zero &&
        state.position > Duration.zero) {
      return;
    }

    final nextState = state.copyWith(position: event.position);
    emit(nextState);
    _syncOverlay(nextState);
    _persistSession(nextState);

    if (state.sleepTimerMode == SleepTimerMode.endOfTrack &&
        state.isPlaying &&
        !_endOfTrackFadeTriggered) {
      final total = state.effectiveDuration;
      if (total > const Duration(seconds: 5) &&
          event.position >= total - const Duration(milliseconds: 1450)) {
        _endOfTrackFadeTriggered = true;
        add(const PlayerEvent.sleepTimerTicked());
      }
    }
  }

  void _onDurationChanged(
    PlayerDurationChanged event,
    Emitter<PlayerState> emit,
  ) {
    if (event.duration != null) {
      final nextState = state.copyWith(duration: event.duration!);
      emit(nextState);
      _syncOverlay(nextState, force: true);
    }
  }

  Future<void> _onEngineStateChanged(
    PlayerEngineStateChanged event,
    Emitter<PlayerState> emit,
  ) async {
    final engineTrack = _audio.activeEngineTrack;
    if (engineTrack != null &&
        engineTrack.category == state.category &&
        engineTrack.id != state.track.id) {
      if (state.sleepTimerMode == SleepTimerMode.endOfTrack) {
        await _expireSleepTimer(emit, resetToStart: true);
        return;
      }

      final syncedState = state.copyWith(
        track: engineTrack,
        position: Duration.zero,
        duration: _audio.currentDuration ?? engineTrack.displayDuration,
        status: event.isPlaying ? PlaybackStatus.playing : state.status,
        errorMessage: null,
      );
      emit(syncedState);
      await _syncEffects(syncedState);
      _syncOverlay(syncedState, force: true);
      _persistSession(syncedState, force: true);
      return;
    }

    if (event.isCompleted) {
      if (state.sleepTimerMode == SleepTimerMode.endOfTrack) {
        await _expireSleepTimer(emit, resetToStart: true);
        return;
      }

      final playlist = state.activePlaylist;
      if (playlist.length > 1 && !state.isRepeating) {
        add(const PlayerEvent.nextTrackPressed());
        return;
      }
      await _audio.pause();
      await _audio.seek(Duration.zero);
      final completedState = state.copyWith(
        status: PlaybackStatus.completed,
        position: Duration.zero,
      );
      emit(completedState);
      _syncOverlay(completedState, force: true);
      _persistSession(completedState, force: true);
      return;
    }
    if (event.isPlaying) {
      final playingState = state.copyWith(
        status: PlaybackStatus.playing,
        errorMessage: null,
      );
      emit(playingState);
      _syncOverlay(playingState);
    } else if (state.status == PlaybackStatus.playing) {
      final pausedState = state.copyWith(status: PlaybackStatus.paused);
      emit(pausedState);
      _syncOverlay(pausedState, force: true);
      _persistSession(pausedState, force: true);
    }
  }

  @override
  Future<void> close() async {
    _sleepTimer?.cancel();
    await _sessionStorage.save(
      trackId: state.track.id,
      category: state.category,
      position: state.position,
      volume: state.volume,
      isShuffled: state.isShuffled,
      isRepeating: state.isRepeating,
      isPlaylistOpen: state.isPlaylistOpen,
      is8BitEnabled: state.is8BitEnabled,
      isStereoEnabled: state.isStereoEnabled,
      isBassEnabled: state.isBassEnabled,
      isSfxEnabled: state.isSfxEnabled,
      isGamingModeEnabled: state.isGamingModeEnabled,
    );
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _engineSubscription?.cancel();
    await _overlayCommandSubscription?.cancel();
    await _audio.dispose();
    return super.close();
  }
}
