import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum RetroClickStyle { tap, toggleOn, toggleOff, transport }

class RetroFeedbackService {
  static const _channel = MethodChannel('bitbeat/foreground_service');

  bool isEnabled = true;

  void trigger(RetroClickStyle style) {
    if (!isEnabled) return;

    switch (style) {
      case RetroClickStyle.tap:
        unawaited(HapticFeedback.selectionClick());
      case RetroClickStyle.toggleOn:
      case RetroClickStyle.toggleOff:
        unawaited(HapticFeedback.lightImpact());
      case RetroClickStyle.transport:
        unawaited(HapticFeedback.mediumImpact());
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      unawaited(
        _channel
            .invokeMethod<bool>('playRetroClick', {'style': style.name})
            .catchError((_) => false),
      );
    } else {
      unawaited(SystemSound.play(SystemSoundType.click));
    }
  }
}

