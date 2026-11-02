import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import '../data/audio_player_repository.dart';
import '../data/retro_feedback_service.dart';
import '../domain/track.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  static const _surface = Color(0xFF12131A);
  static const _surfaceLow = Color(0xFF1A1B22);
  static const _surfaceContainer = Color(0xFF1E1F27);
  static const _surfaceHigh = Color(0xFF34343C);
  static const _text = Color(0xFFE3E1EC);
  static const _muted = Color(0xFFB9CACB);
  static const _outline = Color(0xFF849495);
  static const _cyan = Color(0xFF00F0FF);
  static const _green = Color(0xFF33FB0A);
  static const _pink = Color(0xFFFF4A8D);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: kIsWeb || defaultTargetPlatform != TargetPlatform.android,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final isPlaying = context.read<PlayerBloc>().state.isPlaying;
        if (isPlaying) {
          context.read<AudioPlayerRepository>().moveToBackground();
        } else {
          SystemNavigator.pop();
        }
      },
      child: const Scaffold(
        backgroundColor: _surface,
        body: SafeArea(
          child: Column(
            children: [
              _AppHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TerminalScreen(),
                      SizedBox(height: 12),
                      _ControlDeck(),
                      SizedBox(height: 12),
                      _PlaylistSwitcher(),
                      SizedBox(height: 12),
                      _Diagnostics(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: PlayerPage._surface,
        border: Border(bottom: BorderSide(color: Color(0x22111B1E))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Kembali',
                color: PlayerPage._cyan,
                onPressed: () {
                  context.read<RetroFeedbackService>().trigger(
                    RetroClickStyle.tap,
                  );
                  Navigator.maybePop(context);
                },
                icon: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'CARTRIDGE INFO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFDBFCFF),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const _GamingHeaderButton(),
          const SizedBox(width: 5),
          const _SfxHeaderButton(),
        ],
      ),
    );
  }
}

class _GamingHeaderButton extends StatelessWidget {
  const _GamingHeaderButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, bool>(
      selector: (state) => state.isGamingModeEnabled,
      builder: (context, isGamingEnabled) {
        return Tooltip(
          message: isGamingEnabled
              ? 'Mode Gaming: AKTIF (Kapsul Melayang di Atas Layar)'
              : 'Mode Gaming: NONAKTIF (Tidak Melayang Otomatis)',
          child: InkWell(
            onTap: () => context.read<PlayerBloc>().add(
              const PlayerEvent.gamingModeToggled(),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: isGamingEnabled
                    ? PlayerPage._cyan.withValues(alpha: .15)
                    : const Color(0xFF0D0E15),
                border: Border.all(
                  color: isGamingEnabled
                      ? PlayerPage._cyan
                      : PlayerPage._surfaceHigh,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports_esports_rounded,
                    size: 12,
                    color: isGamingEnabled
                        ? PlayerPage._cyan
                        : PlayerPage._outline,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'GAME',
                    style: _LabelStyle(
                      color: isGamingEnabled
                          ? PlayerPage._cyan
                          : PlayerPage._outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SfxHeaderButton extends StatelessWidget {
  const _SfxHeaderButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, bool>(
      selector: (state) => state.isSfxEnabled,
      builder: (context, isSfxEnabled) {
        return Tooltip(
          message: isSfxEnabled
              ? 'Klik & Getar 8-Bit: AKTIF'
              : 'Klik & Getar 8-Bit: MATI',
          child: InkWell(
            onTap: () => context.read<PlayerBloc>().add(
              const PlayerEvent.sfxToggled(),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0E15),
                border: Border.all(
                  color: isSfxEnabled
                      ? PlayerPage._cyan.withValues(alpha: .45)
                      : PlayerPage._surfaceHigh,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSfxEnabled
                        ? Icons.vibration_rounded
                        : Icons.volume_off_outlined,
                    size: 11,
                    color: isSfxEnabled
                        ? PlayerPage._cyan
                        : PlayerPage._outline,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'SFX',
                    style: _LabelStyle(
                      color: isSfxEnabled
                          ? PlayerPage._cyan
                          : PlayerPage._outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TerminalScreen extends StatelessWidget {
  const _TerminalScreen();

  @override
  Widget build(BuildContext context) {
    return _HardShadow(
      color: const Color(0xFF0D0E15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    PlayerPage._cyan,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            const _SystemBadge(),
            const SizedBox(height: 12),
            const _TrackInfoHeader(),
            const SizedBox(height: 12),
            const _VisualizerSection(),
            const SizedBox(height: 10),
            const _TimeAndProgressSection(),
            BlocSelector<PlayerBloc, PlayerState, String?>(
              selector: (state) => state.status == PlaybackStatus.failure
                  ? (state.errorMessage ?? 'Audio tidak dapat dimuat.')
                  : null,
              builder: (context, errorMessage) {
                if (errorMessage == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _AssetError(message: errorMessage),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackInfoHeader extends StatelessWidget {
  const _TrackInfoHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          prev.track != curr.track ||
          prev.category != curr.category ||
          prev.is8BitEnabled != curr.is8BitEnabled ||
          prev.isStereoEnabled != curr.isStereoEnabled ||
          prev.isBassEnabled != curr.isBassEnabled,
      builder: (context, state) {
        final track = state.track;
        final playlist = state.activePlaylist;
        final trackNumber = (playlist.indexWhere((t) => t.id == track.id) + 1)
            .toString()
            .padLeft(2, '0');
        final totalTracks = playlist.length.toString().padLeft(2, '0');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, color: PlayerPage._cyan, size: 7),
                const SizedBox(width: 5),
                Text(
                  'TRACK $trackNumber/$totalTracks',
                  style: const _LabelStyle(color: PlayerPage._muted),
                ),
                const Spacer(),
                _MetadataChip(track.format, PlayerPage._green),
                const SizedBox(width: 4),
                _MetadataChip(
                  state.is8BitEnabled ? '8-BIT' : '16-BIT',
                  state.is8BitEnabled ? PlayerPage._green : PlayerPage._muted,
                ),
                const SizedBox(width: 4),
                _MetadataChip(
                  state.isStereoEnabled ? 'STEREO' : 'MONO',
                  state.isStereoEnabled ? PlayerPage._cyan : PlayerPage._muted,
                ),
                if (state.isBassEnabled) ...[
                  const SizedBox(width: 4),
                  const _MetadataChip('BASS+', PlayerPage._pink),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  '>',
                  style: TextStyle(
                    color: PlayerPage._cyan,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${track.title.toUpperCase().replaceAll(' ', '_')}.${track.format}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFDBFCFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .4,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: Text(
                '${track.artist.toUpperCase()}  /  ${state.category == TrackCategory.original ? 'LAGU ASLI' : 'MELODI SYNTH'}',
                style: const TextStyle(
                  color: PlayerPage._muted,
                  fontSize: 10,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VisualizerSection extends StatelessWidget {
  const _VisualizerSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          prev.isPlaying != curr.isPlaying ||
          prev.is8BitEnabled != curr.is8BitEnabled ||
          prev.isStereoEnabled != curr.isStereoEnabled ||
          prev.isBassEnabled != curr.isBassEnabled ||
          prev.volume != curr.volume,
      builder: (context, state) => _Visualizer(state: state),
    );
  }
}

class _TimeAndProgressSection extends StatelessWidget {
  const _TimeAndProgressSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          prev.position.inMilliseconds ~/ 200 !=
              curr.position.inMilliseconds ~/ 200 ||
          prev.effectiveDuration != curr.effectiveDuration,
      builder: (context, state) => _TimeAndProgress(
        position: state.position,
        duration: state.effectiveDuration,
      ),
    );
  }
}

class _SystemBadge extends StatelessWidget {
  const _SystemBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      color: const Color(0xFF0D0E15),
      child: const Row(
        children: [
          _PulseLight(),
          SizedBox(width: 6),
          Text(
            'BITBEAT // LITE v1.0',
            style: _LabelStyle(color: PlayerPage._green),
          ),
          Spacer(),
          _MetadataChip('CH-01 ON', PlayerPage._muted),
          SizedBox(width: 5),
          _MetadataChip('[READY]', PlayerPage._cyan),
        ],
      ),
    );
  }
}

class _PulseLight extends StatefulWidget {
  const _PulseLight();

  @override
  State<_PulseLight> createState() => _PulseLightState();
}

class _PulseLightState extends State<_PulseLight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: .35, end: 1).animate(_controller),
      child: Container(width: 7, height: 7, color: PlayerPage._green),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip(this.label, this.foreground);

  final String label;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      color: PlayerPage._surfaceHigh,
      child: Text(label, style: _LabelStyle(color: foreground)),
    );
  }
}

class _Visualizer extends StatefulWidget {
  const _Visualizer({required this.state});

  final PlayerState state;

  @override
  State<_Visualizer> createState() => _VisualizerState();
}

class _VisualizerState extends State<_Visualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 680),
  );

  @override
  void initState() {
    super.initState();
    if (widget.state.isPlaying) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant _Visualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isPlaying && !oldWidget.state.isPlaying) {
      _controller.repeat();
    } else if (!widget.state.isPlaying && oldWidget.state.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _buildDspLabel(PlayerState state) {
    final modes = <String>[
      if (state.is8BitEnabled) '8-BIT',
      state.isStereoEnabled ? 'STEREO' : 'MONO',
      if (state.isBassEnabled) 'BASS+',
    ];
    return '16-CH DSP // ${modes.join(' • ')}';
  }

  int _computeColumnBlocks(int column, double phaseValue, PlayerState state) {
    if (!state.isPlaying || state.volume <= 0.01) {
      // Idle floor reflects active EQ curve preview
      if (state.isBassEnabled && column < 4) return 3;
      if (state.is8BitEnabled && column >= 5 && column <= 10) return 2;
      return 1;
    }

    // 8-BIT mode quantizes time into 8 discrete steps per cycle for a stepped
    // chiptune DAC look; Hi-Fi mode uses continuous phase.
    final t = state.is8BitEnabled
        ? (phaseValue * 8).floorToDouble() / 8.0
        : phaseValue;

    // STEREO mode uses independent phase dispersion across all 16 channels,
    // while MONO mirrors left & right channels symmetrically from the center.
    final effectiveCol = state.isStereoEnabled
        ? column.toDouble()
        : (column < 8 ? column : 15 - column).toDouble();

    final primaryAngle =
        t * math.pi * 2 + effectiveCol * (state.isStereoEnabled ? 0.88 : 0.55);
    var rawWave = (math.sin(primaryAngle) + 1) / 2;

    if (state.is8BitEnabled) {
      // Add square-like harmonic overtone & quantize vertical resolution
      final harmonic = math.sin(primaryAngle * 3) >= 0 ? 0.22 : -0.15;
      rawWave = ((rawWave + harmonic).clamp(0.0, 1.0) * 4).round() / 4.0;
    }

    // Frequency band weighting across the 16 columns (0..4 low, 5..10 mid, 11..15 high)
    var bandGain = 1.0;
    if (column < 5) {
      // Low / Bass bands
      bandGain = state.isBassEnabled ? 1.32 : 0.68;
    } else if (column <= 10) {
      // Midrange bands (emphasized in 8-BIT chiptune mode)
      bandGain = state.is8BitEnabled ? 1.18 : 0.95;
    } else {
      // High / Air bands (emphasized in STEREO mode, rolled off in 8-BIT/MONO)
      bandGain = state.isStereoEnabled ? 1.12 : 0.72;
      if (state.is8BitEnabled && column > 13) {
        bandGain *= 0.78;
      }
    }

    final volumeScale = 0.35 + (state.volume * 0.65);
    final level = (1 + (rawWave * 10 * bandGain * volumeScale)).round();
    return level.clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Container(
      padding: const EdgeInsets.all(8),
      color: PlayerPage._surfaceLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.graphic_eq, color: PlayerPage._cyan, size: 15),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _buildDspLabel(state),
                  overflow: TextOverflow.ellipsis,
                  style: const _LabelStyle(color: PlayerPage._outline),
                ),
              ),
              Text(
                state.is8BitEnabled ? 'CLK 1.09x' : 'SIGNAL OK',
                style: _LabelStyle(
                  color: state.is8BitEnabled
                      ? PlayerPage._cyan
                      : PlayerPage._green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 56,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(16, (column) {
                    final active = _computeColumnBlocks(
                      column,
                      _controller.value,
                      state,
                    );
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(12, (block) {
                            final levelFromBottom = 11 - block;
                            final isActive = levelFromBottom < active;
                            final color = levelFromBottom > 8
                                ? PlayerPage._pink
                                : levelFromBottom > 5
                                ? PlayerPage._green
                                : PlayerPage._cyan;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: .5,
                                ),
                                color: color.withValues(
                                  alpha: isActive ? 1 : .12,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeAndProgress extends StatelessWidget {
  const _TimeAndProgress({
    required this.position,
    required this.duration,
  });

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.square, color: PlayerPage._cyan, size: 8),
            const SizedBox(width: 5),
            Text(
              _formatDuration(position),
              style: const TextStyle(
                color: PlayerPage._cyan,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Text(
              'LOCAL ASSET',
              style: _LabelStyle(color: PlayerPage._outline),
            ),
            const Spacer(),
            Text(
              _formatDuration(duration),
              style: const TextStyle(
                color: PlayerPage._muted,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _BlockProgress(
          position: position,
          duration: duration,
          onSeek: (target) => context.read<PlayerBloc>().add(
            PlayerEvent.seekRequested(target),
          ),
        ),
      ],
    );
  }
}

class _BlockProgress extends StatelessWidget {
  const _BlockProgress({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final totalMillis = duration.inMilliseconds;
    final fraction = totalMillis == 0
        ? 0.0
        : (position.inMilliseconds / totalMillis).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        void seekAt(Offset localPosition, {bool withFeedback = false}) {
          if (withFeedback) {
            context.read<RetroFeedbackService>().trigger(RetroClickStyle.tap);
          }
          final ratio = (localPosition.dx / constraints.maxWidth).clamp(
            0.0,
            1.0,
          );
          onSeek(Duration(milliseconds: (totalMillis * ratio).round()));
        }

        return Semantics(
          label: 'Posisi lagu',
          child: GestureDetector(
            onTapDown: (details) =>
                seekAt(details.localPosition, withFeedback: true),
            onHorizontalDragUpdate: (details) => seekAt(details.localPosition),
            child: Container(
              height: 17,
              padding: const EdgeInsets.all(2),
              color: PlayerPage._surfaceLow,
              child: Row(
                children: List.generate(20, (index) {
                  final isFilled = (index + 1) / 20 <= fraction;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == 19 ? 0 : 2),
                      color: isFilled
                          ? PlayerPage._cyan
                          : PlayerPage._surfaceHigh,
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AssetError extends StatelessWidget {
  const _AssetError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: PlayerPage._pink),
        color: const Color(0xFF3F001A),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFFFD9E1),
          fontSize: 10,
          height: 1.4,
        ),
      ),
    );
  }
}

class _ControlDeck extends StatelessWidget {
  const _ControlDeck();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return _HardShadow(
      color: PlayerPage._surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            BlocBuilder<PlayerBloc, PlayerState>(
              buildWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.isShuffled != curr.isShuffled ||
                  prev.isRepeating != curr.isRepeating,
              builder: (context, state) {
                return Row(
                  children: [
                    _MiniControl(
                      label: 'SHF',
                      active: state.isShuffled,
                      color: PlayerPage._cyan,
                      feedbackStyle: state.isShuffled
                          ? RetroClickStyle.toggleOff
                          : RetroClickStyle.toggleOn,
                      onTap: () => bloc.add(const PlayerEvent.shuffleToggled()),
                    ),
                    const SizedBox(width: 8),
                    _SquareControl(
                      icon: Icons.skip_previous_rounded,
                      tooltip: 'Lagu sebelumnya',
                      onTap: () =>
                          bloc.add(const PlayerEvent.previousTrackPressed()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PlayControl(
                        isPlaying: state.isPlaying,
                        isLoading: state.status == PlaybackStatus.loading,
                        onTap: () =>
                            bloc.add(const PlayerEvent.playPausePressed()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SquareControl(
                      icon: Icons.skip_next_rounded,
                      tooltip: 'Lagu berikutnya',
                      onTap: () =>
                          bloc.add(const PlayerEvent.nextTrackPressed()),
                    ),
                    const SizedBox(width: 8),
                    _MiniControl(
                      label: 'REP',
                      active: state.isRepeating,
                      color: PlayerPage._green,
                      feedbackStyle: state.isRepeating
                          ? RetroClickStyle.toggleOff
                          : RetroClickStyle.toggleOn,
                      onTap: () => bloc.add(const PlayerEvent.repeatToggled()),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            BlocBuilder<PlayerBloc, PlayerState>(
              buildWhen: (prev, curr) =>
                  prev.is8BitEnabled != curr.is8BitEnabled ||
                  prev.isStereoEnabled != curr.isStereoEnabled ||
                  prev.isBassEnabled != curr.isBassEnabled,
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: _EffectControl(
                        label: '8-BIT',
                        active: state.is8BitEnabled,
                        color: PlayerPage._green,
                        onTap: () => bloc.add(
                          const PlayerEvent.effectToggled(PlayerEffect.bit8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _EffectControl(
                        label: 'STEREO',
                        active: state.isStereoEnabled,
                        color: PlayerPage._cyan,
                        onTap: () => bloc.add(
                          const PlayerEvent.effectToggled(PlayerEffect.stereo),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _EffectControl(
                        label: 'BASS',
                        active: state.isBassEnabled,
                        color: PlayerPage._pink,
                        onTap: () => bloc.add(
                          const PlayerEvent.effectToggled(PlayerEffect.bass),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            BlocSelector<
              PlayerBloc,
              PlayerState,
              ({double volume, bool isBassEnabled})
            >(
              selector: (state) =>
                  (volume: state.volume, isBassEnabled: state.isBassEnabled),
              builder: (context, vm) => _VolumeControl(
                value: vm.volume,
                isBassEnabled: vm.isBassEnabled,
                onChanged: (value) =>
                    bloc.add(PlayerEvent.volumeChanged(value)),
              ),
            ),
            const SizedBox(height: 10),
            const _SleepTimerControl(),
            const SizedBox(height: 10),
            const _GamingModeControl(),
          ],
        ),
      ),
    );
  }
}

class _SleepTimerControl extends StatelessWidget {
  const _SleepTimerControl();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return BlocSelector<
      PlayerBloc,
      PlayerState,
      ({SleepTimerMode mode, int? remainingSec})
    >(
      selector: (state) => (
        mode: state.sleepTimerMode,
        remainingSec: state.sleepTimerRemaining?.inSeconds,
      ),
      builder: (context, sleep) {
        final isActive = sleep.mode != SleepTimerMode.off;
        final statusText = switch (sleep.mode) {
          SleepTimerMode.off => 'MATI',
          SleepTimerMode.endOfTrack => 'SAMPAI LAGU HABIS',
          SleepTimerMode.min15 ||
          SleepTimerMode.min30 ||
          SleepTimerMode.min60 =>
            'TERSISA ${_formatDuration(Duration(seconds: (sleep.remainingSec ?? 0).clamp(0, 86400)))}',
        };

        return Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF0D0E15),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bedtime_outlined,
                    size: 13,
                    color: isActive ? PlayerPage._cyan : PlayerPage._outline,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'SLEEP TIMER',
                    style: _LabelStyle(color: PlayerPage._outline),
                  ),
                  const Spacer(),
                  Text(
                    statusText,
                    style: _LabelStyle(
                      color: isActive ? PlayerPage._cyan : PlayerPage._outline,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        context.read<RetroFeedbackService>().trigger(
                          RetroClickStyle.toggleOff,
                        );
                        bloc.add(
                          const PlayerEvent.sleepTimerSelected(
                            SleepTimerMode.off,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        color: PlayerPage._surfaceHigh,
                        child: const Text(
                          'BATAL',
                          style: _LabelStyle(color: PlayerPage._pink),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: _SleepPresetButton(
                      label: '15M',
                      active: sleep.mode == SleepTimerMode.min15,
                      color: PlayerPage._cyan,
                      onTap: () => bloc.add(
                        const PlayerEvent.sleepTimerSelected(
                          SleepTimerMode.min15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _SleepPresetButton(
                      label: '30M',
                      active: sleep.mode == SleepTimerMode.min30,
                      color: PlayerPage._cyan,
                      onTap: () => bloc.add(
                        const PlayerEvent.sleepTimerSelected(
                          SleepTimerMode.min30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _SleepPresetButton(
                      label: '60M',
                      active: sleep.mode == SleepTimerMode.min60,
                      color: PlayerPage._cyan,
                      onTap: () => bloc.add(
                        const PlayerEvent.sleepTimerSelected(
                          SleepTimerMode.min60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _SleepPresetButton(
                      label: 'AKHIR',
                      active: sleep.mode == SleepTimerMode.endOfTrack,
                      color: PlayerPage._green,
                      onTap: () => bloc.add(
                        const PlayerEvent.sleepTimerSelected(
                          SleepTimerMode.endOfTrack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SleepPresetButton extends StatelessWidget {
  const _SleepPresetButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      feedbackStyle: active
          ? RetroClickStyle.toggleOff
          : RetroClickStyle.toggleOn,
      height: 29,
      color: active ? PlayerPage._surfaceHigh : PlayerPage._surfaceLow,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            color: color.withValues(alpha: active ? 1 : .2),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: _LabelStyle(
                color: active ? color : PlayerPage._muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GamingModeControl extends StatelessWidget {
  const _GamingModeControl();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return BlocSelector<PlayerBloc, PlayerState, bool>(
      selector: (state) => state.isGamingModeEnabled,
      builder: (context, isGaming) {
        return Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF0D0E15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sports_esports_outlined,
                    size: 13,
                    color: isGaming ? PlayerPage._cyan : PlayerPage._outline,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'MODE GAMING',
                    style: _LabelStyle(color: PlayerPage._outline),
                  ),
                  const Spacer(),
                  Text(
                    isGaming ? 'OVERLAY AKTIF' : 'NONAKTIF',
                    style: _LabelStyle(
                      color: isGaming ? PlayerPage._cyan : PlayerPage._outline,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => bloc.add(const PlayerEvent.gamingModeToggled()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      color: isGaming
                          ? PlayerPage._cyan.withValues(alpha: .2)
                          : PlayerPage._surfaceHigh,
                      child: Text(
                        isGaming ? 'MATIKAN' : 'AKTIFKAN',
                        style: _LabelStyle(
                          color: isGaming ? PlayerPage._cyan : PlayerPage._muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                isGaming
                    ? '• Kapsul melayang di atas game saat BitBeat di latar belakang'
                    : '• Mati: Tidak otomatis muncul di atas layar (hanya notifikasi)',
                style: TextStyle(
                  color: isGaming
                      ? PlayerPage._cyan.withValues(alpha: .8)
                      : PlayerPage._outline,
                  fontSize: 9.5,
                  height: 1.25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniControl extends StatelessWidget {
  const _MiniControl({
    required this.label,
    required this.active,
    required this.color,
    required this.feedbackStyle,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final RetroClickStyle feedbackStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      feedbackStyle: feedbackStyle,
      color: PlayerPage._surfaceHigh,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Text(
        label,
        style: _LabelStyle(color: active ? color : PlayerPage._muted),
      ),
    );
  }
}

class _SquareControl extends StatelessWidget {
  const _SquareControl({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: _Pressable(
        onTap: onTap,
        feedbackStyle: RetroClickStyle.transport,
        color: PlayerPage._surfaceHigh,
        height: 44,
        width: 44,
        child: Icon(icon),
      ),
    );
  }
}

class _PlayControl extends StatelessWidget {
  const _PlayControl({
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      feedbackStyle: RetroClickStyle.transport,
      height: 48,
      color: isPlaying ? PlayerPage._cyan : PlayerPage._surfaceHigh,
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: PlayerPage._cyan,
              ),
            )
          : Text(
              isPlaying ? '■  PAUSE' : '▶  PLAY',
              style: TextStyle(
                color: isPlaying ? const Color(0xFF002022) : PlayerPage._text,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: .5,
              ),
            ),
    );
  }
}

class _EffectControl extends StatelessWidget {
  const _EffectControl({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      feedbackStyle: active
          ? RetroClickStyle.toggleOff
          : RetroClickStyle.toggleOn,
      height: 33,
      color: const Color(0xFF0D0E15),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const _LabelStyle(color: PlayerPage._text),
            ),
          ),
          Container(
            height: 8,
            width: 8,
            color: color.withValues(alpha: active ? 1 : .15),
          ),
        ],
      ),
    );
  }
}

class _VolumeControl extends StatelessWidget {
  const _VolumeControl({
    required this.value,
    required this.isBassEnabled,
    required this.onChanged,
  });

  final double value;
  final bool isBassEnabled;
  final ValueChanged<double> onChanged;

  String _formatDecibels() {
    if (value <= 0.01) return 'MUTE';
    final baseDb = (value - 0.85) * 20;
    final bassBoostDb = isBassEnabled ? 3.5 : 0.0;
    final totalDb = baseDb + bassBoostDb;
    final sign = totalDb >= 0 ? '+' : '';
    return '$sign${totalDb.toStringAsFixed(1)}dB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      color: const Color(0xFF0D0E15),
      child: Row(
        children: [
          Text(
            'VOL [${(value * 100).round()}%]',
            style: const _LabelStyle(color: PlayerPage._outline),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5,
                activeTrackColor: PlayerPage._cyan,
                inactiveTrackColor: PlayerPage._surfaceHigh,
                thumbColor: PlayerPage._cyan,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(value: value, onChanged: onChanged),
            ),
          ),
          Text(
            _formatDecibels(),
            style: _LabelStyle(
              color: isBassEnabled ? PlayerPage._pink : PlayerPage._green,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistSwitcher extends StatelessWidget {
  const _PlaylistSwitcher();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          prev.category != curr.category ||
          prev.isPlaylistOpen != curr.isPlaylistOpen ||
          prev.track.id != curr.track.id,
      builder: (context, state) {
        final isOriginal = state.category == TrackCategory.original;
        final playlist = state.activePlaylist;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Pressable(
                    onTap: () => bloc.add(
                      const PlayerEvent.categoryChanged(TrackCategory.original),
                    ),
                    feedbackStyle: isOriginal
                        ? RetroClickStyle.tap
                        : RetroClickStyle.toggleOn,
                    color: isOriginal
                        ? PlayerPage._cyan
                        : PlayerPage._surfaceContainer,
                    height: 40,
                    child: Text(
                      '♪  LAGU ASLI (${originalTracks.length})',
                      style: TextStyle(
                        color: isOriginal
                            ? const Color(0xFF002022)
                            : PlayerPage._muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .7,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Pressable(
                    onTap: () => bloc.add(
                      const PlayerEvent.categoryChanged(TrackCategory.melody),
                    ),
                    feedbackStyle: !isOriginal
                        ? RetroClickStyle.tap
                        : RetroClickStyle.toggleOn,
                    color: !isOriginal
                        ? PlayerPage._green
                        : PlayerPage._surfaceContainer,
                    height: 40,
                    child: Text(
                      '◈  MELODI (${melodyTracks.length})',
                      style: TextStyle(
                        color: !isOriginal
                            ? const Color(0xFF002105)
                            : PlayerPage._muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .7,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Pressable(
              onTap: () => bloc.add(const PlayerEvent.playlistToggled()),
              feedbackStyle: state.isPlaylistOpen
                  ? RetroClickStyle.toggleOff
                  : RetroClickStyle.toggleOn,
              color: PlayerPage._surfaceHigh,
              height: 48,
              child: Text(
                state.isPlaylistOpen
                    ? '[ TUTUP PLAYLIST ${isOriginal ? 'LAGU ASLI' : 'MELODI'} ]'
                    : '☰  LIHAT PLAYLIST ${isOriginal ? 'LAGU ASLI' : 'MELODI'} (${playlist.length} LAGU)  >',
                style: const TextStyle(
                  color: Color(0xFFDBFCFF),
                  fontWeight: FontWeight.w700,
                  letterSpacing: .7,
                  fontSize: 12,
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 170),
              crossFadeState: state.isPlaylistOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _PlaylistDrawer(
                  category: state.category,
                  selectedTrackId: state.track.id,
                  playlist: playlist,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlaylistDrawer extends StatelessWidget {
  const _PlaylistDrawer({
    required this.category,
    required this.selectedTrackId,
    required this.playlist,
  });

  final TrackCategory category;
  final String selectedTrackId;
  final List<Track> playlist;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    final isOriginal = category == TrackCategory.original;
    return _HardShadow(
      color: const Color(0xFF0D0E15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  isOriginal
                      ? 'MOD QUEUE // LAGU ASLI'
                      : 'MOD QUEUE // MELODI SYNTH',
                  style: const _LabelStyle(color: PlayerPage._outline),
                ),
                const Spacer(),
                Text(
                  '[${playlist.length} ENTRIES]',
                  style: const _LabelStyle(color: PlayerPage._green),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...playlist.asMap().entries.map((entry) {
              final index = entry.key;
              final track = entry.value;
              final selected = track.id == selectedTrackId;
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 4),
                child: InkWell(
                  onTap: () {
                    context.read<RetroFeedbackService>().trigger(
                      RetroClickStyle.transport,
                    );
                    bloc.add(PlayerEvent.trackSelected(index));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 8,
                    ),
                    color: selected
                        ? PlayerPage._surfaceHigh
                        : PlayerPage._surfaceContainer,
                    child: Row(
                      children: [
                        Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: const _LabelStyle(color: PlayerPage._green),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${track.title.toUpperCase().replaceAll(' ', '_')}.${track.format}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFFDBFCFF)
                                  : PlayerPage._text,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          _formatDuration(track.displayDuration),
                          style: const _LabelStyle(color: PlayerPage._green),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Diagnostics extends StatelessWidget {
  const _Diagnostics();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PlayerBloc,
      PlayerState,
      ({bool is8Bit, bool isStereo, bool isBass, bool isGaming})
    >(
      selector: (state) => (
        is8Bit: state.is8BitEnabled,
        isStereo: state.isStereoEnabled,
        isBass: state.isBassEnabled,
        isGaming: state.isGamingModeEnabled,
      ),
      builder: (context, fx) {
        final activeEffects = <String>[
          if (fx.is8Bit) '8BIT',
          if (fx.isStereo) 'ST',
          if (fx.isBass) 'BASS',
        ];
        final dspStatus = activeEffects.isEmpty
            ? 'DSP: BYPASS'
            : 'DSP: ${activeEffects.join('+')}';
        final hudStatus = fx.isGaming ? 'HUD: ON' : 'HUD: OFF';
        return Row(
          children: [
            Text(
              'MEM: LOCAL // $hudStatus',
              style: _LabelStyle(
                color: fx.isGaming ? PlayerPage._cyan : PlayerPage._outline,
              ),
            ),
            const Spacer(),
            Text(
              dspStatus,
              style: const _LabelStyle(color: PlayerPage._outline),
            ),
          ],
        );
      },
    );
  }
}

class _HardShadow extends StatelessWidget {
  const _HardShadow({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: child,
    );
  }
}

class _Pressable extends StatelessWidget {
  const _Pressable({
    required this.onTap,
    required this.color,
    required this.height,
    required this.child,
    this.feedbackStyle = RetroClickStyle.tap,
    this.width,
    this.padding,
  });

  final VoidCallback onTap;
  final Color color;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final RetroClickStyle feedbackStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: color,
        child: InkWell(
          onTap: () {
            context.read<RetroFeedbackService>().trigger(feedbackStyle);
            onTap();
          },
          splashColor: PlayerPage._cyan.withValues(alpha: .15),
          child: Container(
            padding: padding,
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _LabelStyle extends TextStyle {
  const _LabelStyle({required Color color})
    : super(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: .75,
      );
}

String _formatDuration(Duration value) {
  final minutes = value.inMinutes;
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
