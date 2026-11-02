import 'package:shared_preferences/shared_preferences.dart';

import '../domain/track.dart';

class PlayerSessionSnapshot {
  const PlayerSessionSnapshot({
    required this.trackId,
    required this.category,
    required this.position,
    required this.volume,
    required this.isShuffled,
    required this.isRepeating,
    required this.isPlaylistOpen,
    required this.is8BitEnabled,
    required this.isStereoEnabled,
    required this.isBassEnabled,
    required this.isSfxEnabled,
    required this.isGamingModeEnabled,
  });

  final String trackId;
  final TrackCategory category;
  final Duration position;
  final double volume;
  final bool isShuffled;
  final bool isRepeating;
  final bool isPlaylistOpen;
  final bool is8BitEnabled;
  final bool isStereoEnabled;
  final bool isBassEnabled;
  final bool isSfxEnabled;
  final bool isGamingModeEnabled;
}

class PlayerSessionStorage {
  static const _kTrackId = 'bitbeat.session.track_id';
  static const _kCategory = 'bitbeat.session.category';
  static const _kPositionMs = 'bitbeat.session.position_ms';
  static const _kVolume = 'bitbeat.session.volume';
  static const _kShuffled = 'bitbeat.session.shuffled';
  static const _kRepeating = 'bitbeat.session.repeating';
  static const _kPlaylistOpen = 'bitbeat.session.playlist_open';
  static const _kFx8Bit = 'bitbeat.session.fx_8bit';
  static const _kFxStereo = 'bitbeat.session.fx_stereo';
  static const _kFxBass = 'bitbeat.session.fx_bass';
  static const _kSfxEnabled = 'bitbeat.session.sfx_enabled';
  static const _kGamingMode = 'bitbeat.session.gaming_mode';

  SharedPreferences? _prefs;

  Future<SharedPreferences?> _getPrefs() async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (_) {
      return null;
    }
  }

  Future<PlayerSessionSnapshot?> load() async {
    final prefs = await _getPrefs();
    if (prefs == null) return null;

    final trackId = prefs.getString(_kTrackId);
    if (trackId == null || trackId.isEmpty) return null;

    final categoryRaw = prefs.getString(_kCategory);
    final category = categoryRaw == TrackCategory.melody.name
        ? TrackCategory.melody
        : TrackCategory.original;

    final positionMs = (prefs.getInt(_kPositionMs) ?? 0).clamp(0, 86400000);
    final volume = (prefs.getDouble(_kVolume) ?? 0.85)
        .clamp(0.0, 1.0)
        .toDouble();

    return PlayerSessionSnapshot(
      trackId: trackId,
      category: category,
      position: Duration(milliseconds: positionMs),
      volume: volume,
      isShuffled: prefs.getBool(_kShuffled) ?? false,
      isRepeating: prefs.getBool(_kRepeating) ?? false,
      isPlaylistOpen: prefs.getBool(_kPlaylistOpen) ?? false,
      is8BitEnabled: prefs.getBool(_kFx8Bit) ?? false,
      isStereoEnabled: prefs.getBool(_kFxStereo) ?? true,
      isBassEnabled: prefs.getBool(_kFxBass) ?? true,
      isSfxEnabled: prefs.getBool(_kSfxEnabled) ?? true,
      isGamingModeEnabled: prefs.getBool(_kGamingMode) ?? false,
    );
  }

  Future<void> save({
    required String trackId,
    required TrackCategory category,
    required Duration position,
    required double volume,
    required bool isShuffled,
    required bool isRepeating,
    required bool isPlaylistOpen,
    required bool is8BitEnabled,
    required bool isStereoEnabled,
    required bool isBassEnabled,
    required bool isSfxEnabled,
    required bool isGamingModeEnabled,
  }) async {
    final prefs = await _getPrefs();
    if (prefs == null) return;

    try {
      await Future.wait([
        prefs.setString(_kTrackId, trackId),
        prefs.setString(_kCategory, category.name),
        prefs.setInt(_kPositionMs, position.inMilliseconds.clamp(0, 86400000)),
        prefs.setDouble(_kVolume, volume.clamp(0.0, 1.0).toDouble()),
        prefs.setBool(_kShuffled, isShuffled),
        prefs.setBool(_kRepeating, isRepeating),
        prefs.setBool(_kPlaylistOpen, isPlaylistOpen),
        prefs.setBool(_kFx8Bit, is8BitEnabled),
        prefs.setBool(_kFxStereo, isStereoEnabled),
        prefs.setBool(_kFxBass, isBassEnabled),
        prefs.setBool(_kSfxEnabled, isSfxEnabled),
        prefs.setBool(_kGamingMode, isGamingModeEnabled),
      ]);
    } catch (_) {}
  }
}
