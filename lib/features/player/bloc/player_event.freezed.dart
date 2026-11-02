// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent()';
}


}

/// @nodoc
class $PlayerEventCopyWith<$Res>  {
$PlayerEventCopyWith(PlayerEvent _, $Res Function(PlayerEvent) __);
}


/// Adds pattern-matching-related methods to [PlayerEvent].
extension PlayerEventPatterns on PlayerEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlayerStarted value)?  started,TResult Function( PlayerPlayPausePressed value)?  playPausePressed,TResult Function( PlayerRestartPressed value)?  restartPressed,TResult Function( PlayerNextTrackPressed value)?  nextTrackPressed,TResult Function( PlayerPreviousTrackPressed value)?  previousTrackPressed,TResult Function( PlayerTrackSelected value)?  trackSelected,TResult Function( PlayerCategoryChanged value)?  categoryChanged,TResult Function( PlayerSeekRequested value)?  seekRequested,TResult Function( PlayerVolumeChanged value)?  volumeChanged,TResult Function( PlayerShuffleToggled value)?  shuffleToggled,TResult Function( PlayerRepeatToggled value)?  repeatToggled,TResult Function( PlayerPlaylistToggled value)?  playlistToggled,TResult Function( PlayerEffectToggled value)?  effectToggled,TResult Function( PlayerSfxToggled value)?  sfxToggled,TResult Function( PlayerGamingModeToggled value)?  gamingModeToggled,TResult Function( PlayerGamingModeClosed value)?  gamingModeClosed,TResult Function( PlayerSleepTimerSelected value)?  sleepTimerSelected,TResult Function( PlayerSleepTimerTicked value)?  sleepTimerTicked,TResult Function( PlayerPositionChanged value)?  positionChanged,TResult Function( PlayerDurationChanged value)?  durationChanged,TResult Function( PlayerEngineStateChanged value)?  engineStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlayerStarted() when started != null:
return started(_that);case PlayerPlayPausePressed() when playPausePressed != null:
return playPausePressed(_that);case PlayerRestartPressed() when restartPressed != null:
return restartPressed(_that);case PlayerNextTrackPressed() when nextTrackPressed != null:
return nextTrackPressed(_that);case PlayerPreviousTrackPressed() when previousTrackPressed != null:
return previousTrackPressed(_that);case PlayerTrackSelected() when trackSelected != null:
return trackSelected(_that);case PlayerCategoryChanged() when categoryChanged != null:
return categoryChanged(_that);case PlayerSeekRequested() when seekRequested != null:
return seekRequested(_that);case PlayerVolumeChanged() when volumeChanged != null:
return volumeChanged(_that);case PlayerShuffleToggled() when shuffleToggled != null:
return shuffleToggled(_that);case PlayerRepeatToggled() when repeatToggled != null:
return repeatToggled(_that);case PlayerPlaylistToggled() when playlistToggled != null:
return playlistToggled(_that);case PlayerEffectToggled() when effectToggled != null:
return effectToggled(_that);case PlayerSfxToggled() when sfxToggled != null:
return sfxToggled(_that);case PlayerGamingModeToggled() when gamingModeToggled != null:
return gamingModeToggled(_that);case PlayerGamingModeClosed() when gamingModeClosed != null:
return gamingModeClosed(_that);case PlayerSleepTimerSelected() when sleepTimerSelected != null:
return sleepTimerSelected(_that);case PlayerSleepTimerTicked() when sleepTimerTicked != null:
return sleepTimerTicked(_that);case PlayerPositionChanged() when positionChanged != null:
return positionChanged(_that);case PlayerDurationChanged() when durationChanged != null:
return durationChanged(_that);case PlayerEngineStateChanged() when engineStateChanged != null:
return engineStateChanged(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlayerStarted value)  started,required TResult Function( PlayerPlayPausePressed value)  playPausePressed,required TResult Function( PlayerRestartPressed value)  restartPressed,required TResult Function( PlayerNextTrackPressed value)  nextTrackPressed,required TResult Function( PlayerPreviousTrackPressed value)  previousTrackPressed,required TResult Function( PlayerTrackSelected value)  trackSelected,required TResult Function( PlayerCategoryChanged value)  categoryChanged,required TResult Function( PlayerSeekRequested value)  seekRequested,required TResult Function( PlayerVolumeChanged value)  volumeChanged,required TResult Function( PlayerShuffleToggled value)  shuffleToggled,required TResult Function( PlayerRepeatToggled value)  repeatToggled,required TResult Function( PlayerPlaylistToggled value)  playlistToggled,required TResult Function( PlayerEffectToggled value)  effectToggled,required TResult Function( PlayerSfxToggled value)  sfxToggled,required TResult Function( PlayerGamingModeToggled value)  gamingModeToggled,required TResult Function( PlayerGamingModeClosed value)  gamingModeClosed,required TResult Function( PlayerSleepTimerSelected value)  sleepTimerSelected,required TResult Function( PlayerSleepTimerTicked value)  sleepTimerTicked,required TResult Function( PlayerPositionChanged value)  positionChanged,required TResult Function( PlayerDurationChanged value)  durationChanged,required TResult Function( PlayerEngineStateChanged value)  engineStateChanged,}){
final _that = this;
switch (_that) {
case PlayerStarted():
return started(_that);case PlayerPlayPausePressed():
return playPausePressed(_that);case PlayerRestartPressed():
return restartPressed(_that);case PlayerNextTrackPressed():
return nextTrackPressed(_that);case PlayerPreviousTrackPressed():
return previousTrackPressed(_that);case PlayerTrackSelected():
return trackSelected(_that);case PlayerCategoryChanged():
return categoryChanged(_that);case PlayerSeekRequested():
return seekRequested(_that);case PlayerVolumeChanged():
return volumeChanged(_that);case PlayerShuffleToggled():
return shuffleToggled(_that);case PlayerRepeatToggled():
return repeatToggled(_that);case PlayerPlaylistToggled():
return playlistToggled(_that);case PlayerEffectToggled():
return effectToggled(_that);case PlayerSfxToggled():
return sfxToggled(_that);case PlayerGamingModeToggled():
return gamingModeToggled(_that);case PlayerGamingModeClosed():
return gamingModeClosed(_that);case PlayerSleepTimerSelected():
return sleepTimerSelected(_that);case PlayerSleepTimerTicked():
return sleepTimerTicked(_that);case PlayerPositionChanged():
return positionChanged(_that);case PlayerDurationChanged():
return durationChanged(_that);case PlayerEngineStateChanged():
return engineStateChanged(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlayerStarted value)?  started,TResult? Function( PlayerPlayPausePressed value)?  playPausePressed,TResult? Function( PlayerRestartPressed value)?  restartPressed,TResult? Function( PlayerNextTrackPressed value)?  nextTrackPressed,TResult? Function( PlayerPreviousTrackPressed value)?  previousTrackPressed,TResult? Function( PlayerTrackSelected value)?  trackSelected,TResult? Function( PlayerCategoryChanged value)?  categoryChanged,TResult? Function( PlayerSeekRequested value)?  seekRequested,TResult? Function( PlayerVolumeChanged value)?  volumeChanged,TResult? Function( PlayerShuffleToggled value)?  shuffleToggled,TResult? Function( PlayerRepeatToggled value)?  repeatToggled,TResult? Function( PlayerPlaylistToggled value)?  playlistToggled,TResult? Function( PlayerEffectToggled value)?  effectToggled,TResult? Function( PlayerSfxToggled value)?  sfxToggled,TResult? Function( PlayerGamingModeToggled value)?  gamingModeToggled,TResult? Function( PlayerGamingModeClosed value)?  gamingModeClosed,TResult? Function( PlayerSleepTimerSelected value)?  sleepTimerSelected,TResult? Function( PlayerSleepTimerTicked value)?  sleepTimerTicked,TResult? Function( PlayerPositionChanged value)?  positionChanged,TResult? Function( PlayerDurationChanged value)?  durationChanged,TResult? Function( PlayerEngineStateChanged value)?  engineStateChanged,}){
final _that = this;
switch (_that) {
case PlayerStarted() when started != null:
return started(_that);case PlayerPlayPausePressed() when playPausePressed != null:
return playPausePressed(_that);case PlayerRestartPressed() when restartPressed != null:
return restartPressed(_that);case PlayerNextTrackPressed() when nextTrackPressed != null:
return nextTrackPressed(_that);case PlayerPreviousTrackPressed() when previousTrackPressed != null:
return previousTrackPressed(_that);case PlayerTrackSelected() when trackSelected != null:
return trackSelected(_that);case PlayerCategoryChanged() when categoryChanged != null:
return categoryChanged(_that);case PlayerSeekRequested() when seekRequested != null:
return seekRequested(_that);case PlayerVolumeChanged() when volumeChanged != null:
return volumeChanged(_that);case PlayerShuffleToggled() when shuffleToggled != null:
return shuffleToggled(_that);case PlayerRepeatToggled() when repeatToggled != null:
return repeatToggled(_that);case PlayerPlaylistToggled() when playlistToggled != null:
return playlistToggled(_that);case PlayerEffectToggled() when effectToggled != null:
return effectToggled(_that);case PlayerSfxToggled() when sfxToggled != null:
return sfxToggled(_that);case PlayerGamingModeToggled() when gamingModeToggled != null:
return gamingModeToggled(_that);case PlayerGamingModeClosed() when gamingModeClosed != null:
return gamingModeClosed(_that);case PlayerSleepTimerSelected() when sleepTimerSelected != null:
return sleepTimerSelected(_that);case PlayerSleepTimerTicked() when sleepTimerTicked != null:
return sleepTimerTicked(_that);case PlayerPositionChanged() when positionChanged != null:
return positionChanged(_that);case PlayerDurationChanged() when durationChanged != null:
return durationChanged(_that);case PlayerEngineStateChanged() when engineStateChanged != null:
return engineStateChanged(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  playPausePressed,TResult Function()?  restartPressed,TResult Function()?  nextTrackPressed,TResult Function()?  previousTrackPressed,TResult Function( int index)?  trackSelected,TResult Function( TrackCategory category)?  categoryChanged,TResult Function( Duration position)?  seekRequested,TResult Function( double value)?  volumeChanged,TResult Function()?  shuffleToggled,TResult Function()?  repeatToggled,TResult Function()?  playlistToggled,TResult Function( PlayerEffect effect)?  effectToggled,TResult Function()?  sfxToggled,TResult Function()?  gamingModeToggled,TResult Function()?  gamingModeClosed,TResult Function( SleepTimerMode mode)?  sleepTimerSelected,TResult Function()?  sleepTimerTicked,TResult Function( Duration position)?  positionChanged,TResult Function( Duration? duration)?  durationChanged,TResult Function( bool isPlaying,  bool isCompleted)?  engineStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlayerStarted() when started != null:
return started();case PlayerPlayPausePressed() when playPausePressed != null:
return playPausePressed();case PlayerRestartPressed() when restartPressed != null:
return restartPressed();case PlayerNextTrackPressed() when nextTrackPressed != null:
return nextTrackPressed();case PlayerPreviousTrackPressed() when previousTrackPressed != null:
return previousTrackPressed();case PlayerTrackSelected() when trackSelected != null:
return trackSelected(_that.index);case PlayerCategoryChanged() when categoryChanged != null:
return categoryChanged(_that.category);case PlayerSeekRequested() when seekRequested != null:
return seekRequested(_that.position);case PlayerVolumeChanged() when volumeChanged != null:
return volumeChanged(_that.value);case PlayerShuffleToggled() when shuffleToggled != null:
return shuffleToggled();case PlayerRepeatToggled() when repeatToggled != null:
return repeatToggled();case PlayerPlaylistToggled() when playlistToggled != null:
return playlistToggled();case PlayerEffectToggled() when effectToggled != null:
return effectToggled(_that.effect);case PlayerSfxToggled() when sfxToggled != null:
return sfxToggled();case PlayerGamingModeToggled() when gamingModeToggled != null:
return gamingModeToggled();case PlayerGamingModeClosed() when gamingModeClosed != null:
return gamingModeClosed();case PlayerSleepTimerSelected() when sleepTimerSelected != null:
return sleepTimerSelected(_that.mode);case PlayerSleepTimerTicked() when sleepTimerTicked != null:
return sleepTimerTicked();case PlayerPositionChanged() when positionChanged != null:
return positionChanged(_that.position);case PlayerDurationChanged() when durationChanged != null:
return durationChanged(_that.duration);case PlayerEngineStateChanged() when engineStateChanged != null:
return engineStateChanged(_that.isPlaying,_that.isCompleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  playPausePressed,required TResult Function()  restartPressed,required TResult Function()  nextTrackPressed,required TResult Function()  previousTrackPressed,required TResult Function( int index)  trackSelected,required TResult Function( TrackCategory category)  categoryChanged,required TResult Function( Duration position)  seekRequested,required TResult Function( double value)  volumeChanged,required TResult Function()  shuffleToggled,required TResult Function()  repeatToggled,required TResult Function()  playlistToggled,required TResult Function( PlayerEffect effect)  effectToggled,required TResult Function()  sfxToggled,required TResult Function()  gamingModeToggled,required TResult Function()  gamingModeClosed,required TResult Function( SleepTimerMode mode)  sleepTimerSelected,required TResult Function()  sleepTimerTicked,required TResult Function( Duration position)  positionChanged,required TResult Function( Duration? duration)  durationChanged,required TResult Function( bool isPlaying,  bool isCompleted)  engineStateChanged,}) {final _that = this;
switch (_that) {
case PlayerStarted():
return started();case PlayerPlayPausePressed():
return playPausePressed();case PlayerRestartPressed():
return restartPressed();case PlayerNextTrackPressed():
return nextTrackPressed();case PlayerPreviousTrackPressed():
return previousTrackPressed();case PlayerTrackSelected():
return trackSelected(_that.index);case PlayerCategoryChanged():
return categoryChanged(_that.category);case PlayerSeekRequested():
return seekRequested(_that.position);case PlayerVolumeChanged():
return volumeChanged(_that.value);case PlayerShuffleToggled():
return shuffleToggled();case PlayerRepeatToggled():
return repeatToggled();case PlayerPlaylistToggled():
return playlistToggled();case PlayerEffectToggled():
return effectToggled(_that.effect);case PlayerSfxToggled():
return sfxToggled();case PlayerGamingModeToggled():
return gamingModeToggled();case PlayerGamingModeClosed():
return gamingModeClosed();case PlayerSleepTimerSelected():
return sleepTimerSelected(_that.mode);case PlayerSleepTimerTicked():
return sleepTimerTicked();case PlayerPositionChanged():
return positionChanged(_that.position);case PlayerDurationChanged():
return durationChanged(_that.duration);case PlayerEngineStateChanged():
return engineStateChanged(_that.isPlaying,_that.isCompleted);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  playPausePressed,TResult? Function()?  restartPressed,TResult? Function()?  nextTrackPressed,TResult? Function()?  previousTrackPressed,TResult? Function( int index)?  trackSelected,TResult? Function( TrackCategory category)?  categoryChanged,TResult? Function( Duration position)?  seekRequested,TResult? Function( double value)?  volumeChanged,TResult? Function()?  shuffleToggled,TResult? Function()?  repeatToggled,TResult? Function()?  playlistToggled,TResult? Function( PlayerEffect effect)?  effectToggled,TResult? Function()?  sfxToggled,TResult? Function()?  gamingModeToggled,TResult? Function()?  gamingModeClosed,TResult? Function( SleepTimerMode mode)?  sleepTimerSelected,TResult? Function()?  sleepTimerTicked,TResult? Function( Duration position)?  positionChanged,TResult? Function( Duration? duration)?  durationChanged,TResult? Function( bool isPlaying,  bool isCompleted)?  engineStateChanged,}) {final _that = this;
switch (_that) {
case PlayerStarted() when started != null:
return started();case PlayerPlayPausePressed() when playPausePressed != null:
return playPausePressed();case PlayerRestartPressed() when restartPressed != null:
return restartPressed();case PlayerNextTrackPressed() when nextTrackPressed != null:
return nextTrackPressed();case PlayerPreviousTrackPressed() when previousTrackPressed != null:
return previousTrackPressed();case PlayerTrackSelected() when trackSelected != null:
return trackSelected(_that.index);case PlayerCategoryChanged() when categoryChanged != null:
return categoryChanged(_that.category);case PlayerSeekRequested() when seekRequested != null:
return seekRequested(_that.position);case PlayerVolumeChanged() when volumeChanged != null:
return volumeChanged(_that.value);case PlayerShuffleToggled() when shuffleToggled != null:
return shuffleToggled();case PlayerRepeatToggled() when repeatToggled != null:
return repeatToggled();case PlayerPlaylistToggled() when playlistToggled != null:
return playlistToggled();case PlayerEffectToggled() when effectToggled != null:
return effectToggled(_that.effect);case PlayerSfxToggled() when sfxToggled != null:
return sfxToggled();case PlayerGamingModeToggled() when gamingModeToggled != null:
return gamingModeToggled();case PlayerGamingModeClosed() when gamingModeClosed != null:
return gamingModeClosed();case PlayerSleepTimerSelected() when sleepTimerSelected != null:
return sleepTimerSelected(_that.mode);case PlayerSleepTimerTicked() when sleepTimerTicked != null:
return sleepTimerTicked();case PlayerPositionChanged() when positionChanged != null:
return positionChanged(_that.position);case PlayerDurationChanged() when durationChanged != null:
return durationChanged(_that.duration);case PlayerEngineStateChanged() when engineStateChanged != null:
return engineStateChanged(_that.isPlaying,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class PlayerStarted implements PlayerEvent {
  const PlayerStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.started()';
}


}




/// @nodoc


class PlayerPlayPausePressed implements PlayerEvent {
  const PlayerPlayPausePressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerPlayPausePressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.playPausePressed()';
}


}




/// @nodoc


class PlayerRestartPressed implements PlayerEvent {
  const PlayerRestartPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRestartPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.restartPressed()';
}


}




/// @nodoc


class PlayerNextTrackPressed implements PlayerEvent {
  const PlayerNextTrackPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerNextTrackPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.nextTrackPressed()';
}


}




/// @nodoc


class PlayerPreviousTrackPressed implements PlayerEvent {
  const PlayerPreviousTrackPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerPreviousTrackPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.previousTrackPressed()';
}


}




/// @nodoc


class PlayerTrackSelected implements PlayerEvent {
  const PlayerTrackSelected(this.index);
  

 final  int index;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerTrackSelectedCopyWith<PlayerTrackSelected> get copyWith => _$PlayerTrackSelectedCopyWithImpl<PlayerTrackSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerTrackSelected&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'PlayerEvent.trackSelected(index: $index)';
}


}

/// @nodoc
abstract mixin class $PlayerTrackSelectedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerTrackSelectedCopyWith(PlayerTrackSelected value, $Res Function(PlayerTrackSelected) _then) = _$PlayerTrackSelectedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$PlayerTrackSelectedCopyWithImpl<$Res>
    implements $PlayerTrackSelectedCopyWith<$Res> {
  _$PlayerTrackSelectedCopyWithImpl(this._self, this._then);

  final PlayerTrackSelected _self;
  final $Res Function(PlayerTrackSelected) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(PlayerTrackSelected(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PlayerCategoryChanged implements PlayerEvent {
  const PlayerCategoryChanged(this.category);
  

 final  TrackCategory category;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCategoryChangedCopyWith<PlayerCategoryChanged> get copyWith => _$PlayerCategoryChangedCopyWithImpl<PlayerCategoryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerCategoryChanged&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'PlayerEvent.categoryChanged(category: $category)';
}


}

/// @nodoc
abstract mixin class $PlayerCategoryChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerCategoryChangedCopyWith(PlayerCategoryChanged value, $Res Function(PlayerCategoryChanged) _then) = _$PlayerCategoryChangedCopyWithImpl;
@useResult
$Res call({
 TrackCategory category
});




}
/// @nodoc
class _$PlayerCategoryChangedCopyWithImpl<$Res>
    implements $PlayerCategoryChangedCopyWith<$Res> {
  _$PlayerCategoryChangedCopyWithImpl(this._self, this._then);

  final PlayerCategoryChanged _self;
  final $Res Function(PlayerCategoryChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(PlayerCategoryChanged(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TrackCategory,
  ));
}


}

/// @nodoc


class PlayerSeekRequested implements PlayerEvent {
  const PlayerSeekRequested(this.position);
  

 final  Duration position;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerSeekRequestedCopyWith<PlayerSeekRequested> get copyWith => _$PlayerSeekRequestedCopyWithImpl<PlayerSeekRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSeekRequested&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'PlayerEvent.seekRequested(position: $position)';
}


}

/// @nodoc
abstract mixin class $PlayerSeekRequestedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerSeekRequestedCopyWith(PlayerSeekRequested value, $Res Function(PlayerSeekRequested) _then) = _$PlayerSeekRequestedCopyWithImpl;
@useResult
$Res call({
 Duration position
});




}
/// @nodoc
class _$PlayerSeekRequestedCopyWithImpl<$Res>
    implements $PlayerSeekRequestedCopyWith<$Res> {
  _$PlayerSeekRequestedCopyWithImpl(this._self, this._then);

  final PlayerSeekRequested _self;
  final $Res Function(PlayerSeekRequested) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(PlayerSeekRequested(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class PlayerVolumeChanged implements PlayerEvent {
  const PlayerVolumeChanged(this.value);
  

 final  double value;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerVolumeChangedCopyWith<PlayerVolumeChanged> get copyWith => _$PlayerVolumeChangedCopyWithImpl<PlayerVolumeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerVolumeChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PlayerEvent.volumeChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $PlayerVolumeChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerVolumeChangedCopyWith(PlayerVolumeChanged value, $Res Function(PlayerVolumeChanged) _then) = _$PlayerVolumeChangedCopyWithImpl;
@useResult
$Res call({
 double value
});




}
/// @nodoc
class _$PlayerVolumeChangedCopyWithImpl<$Res>
    implements $PlayerVolumeChangedCopyWith<$Res> {
  _$PlayerVolumeChangedCopyWithImpl(this._self, this._then);

  final PlayerVolumeChanged _self;
  final $Res Function(PlayerVolumeChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(PlayerVolumeChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class PlayerShuffleToggled implements PlayerEvent {
  const PlayerShuffleToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerShuffleToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.shuffleToggled()';
}


}




/// @nodoc


class PlayerRepeatToggled implements PlayerEvent {
  const PlayerRepeatToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRepeatToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.repeatToggled()';
}


}




/// @nodoc


class PlayerPlaylistToggled implements PlayerEvent {
  const PlayerPlaylistToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerPlaylistToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.playlistToggled()';
}


}




/// @nodoc


class PlayerEffectToggled implements PlayerEvent {
  const PlayerEffectToggled(this.effect);
  

 final  PlayerEffect effect;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerEffectToggledCopyWith<PlayerEffectToggled> get copyWith => _$PlayerEffectToggledCopyWithImpl<PlayerEffectToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEffectToggled&&(identical(other.effect, effect) || other.effect == effect));
}


@override
int get hashCode => Object.hash(runtimeType,effect);

@override
String toString() {
  return 'PlayerEvent.effectToggled(effect: $effect)';
}


}

/// @nodoc
abstract mixin class $PlayerEffectToggledCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerEffectToggledCopyWith(PlayerEffectToggled value, $Res Function(PlayerEffectToggled) _then) = _$PlayerEffectToggledCopyWithImpl;
@useResult
$Res call({
 PlayerEffect effect
});




}
/// @nodoc
class _$PlayerEffectToggledCopyWithImpl<$Res>
    implements $PlayerEffectToggledCopyWith<$Res> {
  _$PlayerEffectToggledCopyWithImpl(this._self, this._then);

  final PlayerEffectToggled _self;
  final $Res Function(PlayerEffectToggled) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? effect = null,}) {
  return _then(PlayerEffectToggled(
null == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as PlayerEffect,
  ));
}


}

/// @nodoc


class PlayerSfxToggled implements PlayerEvent {
  const PlayerSfxToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSfxToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.sfxToggled()';
}


}




/// @nodoc


class PlayerGamingModeToggled implements PlayerEvent {
  const PlayerGamingModeToggled();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerGamingModeToggled);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.gamingModeToggled()';
}
}




/// @nodoc


class PlayerGamingModeClosed implements PlayerEvent {
  const PlayerGamingModeClosed();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerGamingModeClosed);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.gamingModeClosed()';
}
}




/// @nodoc


class PlayerSleepTimerSelected implements PlayerEvent {
  const PlayerSleepTimerSelected(this.mode);
  

 final  SleepTimerMode mode;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerSleepTimerSelectedCopyWith<PlayerSleepTimerSelected> get copyWith => _$PlayerSleepTimerSelectedCopyWithImpl<PlayerSleepTimerSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSleepTimerSelected&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'PlayerEvent.sleepTimerSelected(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $PlayerSleepTimerSelectedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerSleepTimerSelectedCopyWith(PlayerSleepTimerSelected value, $Res Function(PlayerSleepTimerSelected) _then) = _$PlayerSleepTimerSelectedCopyWithImpl;
@useResult
$Res call({
 SleepTimerMode mode
});




}
/// @nodoc
class _$PlayerSleepTimerSelectedCopyWithImpl<$Res>
    implements $PlayerSleepTimerSelectedCopyWith<$Res> {
  _$PlayerSleepTimerSelectedCopyWithImpl(this._self, this._then);

  final PlayerSleepTimerSelected _self;
  final $Res Function(PlayerSleepTimerSelected) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(PlayerSleepTimerSelected(
null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SleepTimerMode,
  ));
}


}

/// @nodoc


class PlayerSleepTimerTicked implements PlayerEvent {
  const PlayerSleepTimerTicked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSleepTimerTicked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlayerEvent.sleepTimerTicked()';
}


}




/// @nodoc


class PlayerPositionChanged implements PlayerEvent {
  const PlayerPositionChanged(this.position);
  

 final  Duration position;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerPositionChangedCopyWith<PlayerPositionChanged> get copyWith => _$PlayerPositionChangedCopyWithImpl<PlayerPositionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerPositionChanged&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'PlayerEvent.positionChanged(position: $position)';
}


}

/// @nodoc
abstract mixin class $PlayerPositionChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerPositionChangedCopyWith(PlayerPositionChanged value, $Res Function(PlayerPositionChanged) _then) = _$PlayerPositionChangedCopyWithImpl;
@useResult
$Res call({
 Duration position
});




}
/// @nodoc
class _$PlayerPositionChangedCopyWithImpl<$Res>
    implements $PlayerPositionChangedCopyWith<$Res> {
  _$PlayerPositionChangedCopyWithImpl(this._self, this._then);

  final PlayerPositionChanged _self;
  final $Res Function(PlayerPositionChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(PlayerPositionChanged(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class PlayerDurationChanged implements PlayerEvent {
  const PlayerDurationChanged(this.duration);
  

 final  Duration? duration;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerDurationChangedCopyWith<PlayerDurationChanged> get copyWith => _$PlayerDurationChangedCopyWithImpl<PlayerDurationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerDurationChanged&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,duration);

@override
String toString() {
  return 'PlayerEvent.durationChanged(duration: $duration)';
}


}

/// @nodoc
abstract mixin class $PlayerDurationChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerDurationChangedCopyWith(PlayerDurationChanged value, $Res Function(PlayerDurationChanged) _then) = _$PlayerDurationChangedCopyWithImpl;
@useResult
$Res call({
 Duration? duration
});




}
/// @nodoc
class _$PlayerDurationChangedCopyWithImpl<$Res>
    implements $PlayerDurationChangedCopyWith<$Res> {
  _$PlayerDurationChangedCopyWithImpl(this._self, this._then);

  final PlayerDurationChanged _self;
  final $Res Function(PlayerDurationChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? duration = freezed,}) {
  return _then(PlayerDurationChanged(
freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class PlayerEngineStateChanged implements PlayerEvent {
  const PlayerEngineStateChanged(this.isPlaying, this.isCompleted);
  

 final  bool isPlaying;
 final  bool isCompleted;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerEngineStateChangedCopyWith<PlayerEngineStateChanged> get copyWith => _$PlayerEngineStateChangedCopyWithImpl<PlayerEngineStateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerEngineStateChanged&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,isCompleted);

@override
String toString() {
  return 'PlayerEvent.engineStateChanged(isPlaying: $isPlaying, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $PlayerEngineStateChangedCopyWith<$Res> implements $PlayerEventCopyWith<$Res> {
  factory $PlayerEngineStateChangedCopyWith(PlayerEngineStateChanged value, $Res Function(PlayerEngineStateChanged) _then) = _$PlayerEngineStateChangedCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, bool isCompleted
});




}
/// @nodoc
class _$PlayerEngineStateChangedCopyWithImpl<$Res>
    implements $PlayerEngineStateChangedCopyWith<$Res> {
  _$PlayerEngineStateChangedCopyWithImpl(this._self, this._then);

  final PlayerEngineStateChanged _self;
  final $Res Function(PlayerEngineStateChanged) _then;

/// Create a copy of PlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? isCompleted = null,}) {
  return _then(PlayerEngineStateChanged(
null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
