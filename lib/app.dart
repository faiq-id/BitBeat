import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/player/bloc/player_bloc.dart';
import 'features/player/bloc/player_event.dart';
import 'features/player/data/audio_player_repository.dart';
import 'features/player/data/player_session_storage.dart';
import 'features/player/data/retro_feedback_service.dart';
import 'features/player/presentation/player_page.dart';

class BitBeatApp extends StatelessWidget {
  const BitBeatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AudioPlayerRepository()),
        RepositoryProvider(create: (_) => PlayerSessionStorage()),
        RepositoryProvider(create: (_) => RetroFeedbackService()),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => PlayerBloc(
              audio: context.read<AudioPlayerRepository>(),
              sessionStorage: context.read<PlayerSessionStorage>(),
              feedback: context.read<RetroFeedbackService>(),
            )..add(const PlayerEvent.started()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'BitBeat',
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF12131A),
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFDBFCFF),
                  onPrimary: Color(0xFF00363A),
                  secondary: Color(0xFFFFB1C4),
                  surface: Color(0xFF12131A),
                  onSurface: Color(0xFFE3E1EC),
                ),
                fontFamily: 'monospace',
              ),
              home: const PlayerPage(),
            ),
          );
        },
      ),
    );
  }
}
