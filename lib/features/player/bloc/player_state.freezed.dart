// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState {

 Track get track; TrackCategory get category; PlaybackStatus get status; Duration get position; Duration get duration; double get volume; bool get isShuffled; bool get isRepeating; bool get isPlaylistOpen; bool get is8BitEnabled; bool get isStereoEnabled; bool get isBassEnabled; bool get isSfxEnabled; bool get isGamingModeEnabled; SleepTimerMode get sleepTimerMode; Duration? get sleepTimerRemaining; String? get errorMessage;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.track, track) || other.track == track)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isShuffled, isShuffled) || other.isShuffled == isShuffled)&&(identical(other.isRepeating, isRepeating) || other.isRepeating == isRepeating)&&(identical(other.isPlaylistOpen, isPlaylistOpen) || other.isPlaylistOpen == isPlaylistOpen)&&(identical(other.is8BitEnabled, is8BitEnabled) || other.is8BitEnabled == is8BitEnabled)&&(identical(other.isStereoEnabled, isStereoEnabled) || other.isStereoEnabled == isStereoEnabled)&&(identical(other.isBassEnabled, isBassEnabled) || other.isBassEnabled == isBassEnabled)&&(identical(other.isSfxEnabled, isSfxEnabled) || other.isSfxEnabled == isSfxEnabled)&&(identical(other.isGamingModeEnabled, isGamingModeEnabled) || other.isGamingModeEnabled == isGamingModeEnabled)&&(identical(other.sleepTimerMode, sleepTimerMode) || other.sleepTimerMode == sleepTimerMode)&&(identical(other.sleepTimerRemaining, sleepTimerRemaining) || other.sleepTimerRemaining == sleepTimerRemaining)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,track,category,status,position,duration,volume,isShuffled,isRepeating,isPlaylistOpen,is8BitEnabled,isStereoEnabled,isBassEnabled,isSfxEnabled,isGamingModeEnabled,sleepTimerMode,sleepTimerRemaining,errorMessage);

@override
String toString() {
  return 'PlayerState(track: $track, category: $category, status: $status, position: $position, duration: $duration, volume: $volume, isShuffled: $isShuffled, isRepeating: $isRepeating, isPlaylistOpen: $isPlaylistOpen, is8BitEnabled: $is8BitEnabled, isStereoEnabled: $isStereoEnabled, isBassEnabled: $isBassEnabled, isSfxEnabled: $isSfxEnabled, isGamingModeEnabled: $isGamingModeEnabled, sleepTimerMode: $sleepTimerMode, sleepTimerRemaining: $sleepTimerRemaining, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 Track track, TrackCategory category, PlaybackStatus status, Duration position, Duration duration, double volume, bool isShuffled, bool isRepeating, bool isPlaylistOpen, bool is8BitEnabled, bool isStereoEnabled, bool isBassEnabled, bool isSfxEnabled, bool isGamingModeEnabled, SleepTimerMode sleepTimerMode, Duration? sleepTimerRemaining, String? errorMessage
});


$TrackCopyWith<$Res> get track;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? category = null,Object? status = null,Object? position = null,Object? duration = null,Object? volume = null,Object? isShuffled = null,Object? isRepeating = null,Object? isPlaylistOpen = null,Object? is8BitEnabled = null,Object? isStereoEnabled = null,Object? isBassEnabled = null,Object? isSfxEnabled = null,Object? isGamingModeEnabled = null,Object? sleepTimerMode = null,Object? sleepTimerRemaining = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TrackCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isShuffled: null == isShuffled ? _self.isShuffled : isShuffled // ignore: cast_nullable_to_non_nullable
as bool,isRepeating: null == isRepeating ? _self.isRepeating : isRepeating // ignore: cast_nullable_to_non_nullable
as bool,isPlaylistOpen: null == isPlaylistOpen ? _self.isPlaylistOpen : isPlaylistOpen // ignore: cast_nullable_to_non_nullable
as bool,is8BitEnabled: null == is8BitEnabled ? _self.is8BitEnabled : is8BitEnabled // ignore: cast_nullable_to_non_nullable
as bool,isStereoEnabled: null == isStereoEnabled ? _self.isStereoEnabled : isStereoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isBassEnabled: null == isBassEnabled ? _self.isBassEnabled : isBassEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSfxEnabled: null == isSfxEnabled ? _self.isSfxEnabled : isSfxEnabled // ignore: cast_nullable_to_non_nullable
as bool,isGamingModeEnabled: null == isGamingModeEnabled ? _self.isGamingModeEnabled : isGamingModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,sleepTimerMode: null == sleepTimerMode ? _self.sleepTimerMode : sleepTimerMode // ignore: cast_nullable_to_non_nullable
as SleepTimerMode,sleepTimerRemaining: freezed == sleepTimerRemaining ? _self.sleepTimerRemaining : sleepTimerRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res> get track {
  
  return $TrackCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Track track,  TrackCategory category,  PlaybackStatus status,  Duration position,  Duration duration,  double volume,  bool isShuffled,  bool isRepeating,  bool isPlaylistOpen,  bool is8BitEnabled,  bool isStereoEnabled,  bool isBassEnabled,  bool isSfxEnabled,  bool isGamingModeEnabled,  SleepTimerMode sleepTimerMode,  Duration? sleepTimerRemaining,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.track,_that.category,_that.status,_that.position,_that.duration,_that.volume,_that.isShuffled,_that.isRepeating,_that.isPlaylistOpen,_that.is8BitEnabled,_that.isStereoEnabled,_that.isBassEnabled,_that.isSfxEnabled,_that.isGamingModeEnabled,_that.sleepTimerMode,_that.sleepTimerRemaining,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Track track,  TrackCategory category,  PlaybackStatus status,  Duration position,  Duration duration,  double volume,  bool isShuffled,  bool isRepeating,  bool isPlaylistOpen,  bool is8BitEnabled,  bool isStereoEnabled,  bool isBassEnabled,  bool isSfxEnabled,  bool isGamingModeEnabled,  SleepTimerMode sleepTimerMode,  Duration? sleepTimerRemaining,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.track,_that.category,_that.status,_that.position,_that.duration,_that.volume,_that.isShuffled,_that.isRepeating,_that.isPlaylistOpen,_that.is8BitEnabled,_that.isStereoEnabled,_that.isBassEnabled,_that.isSfxEnabled,_that.isGamingModeEnabled,_that.sleepTimerMode,_that.sleepTimerRemaining,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Track track,  TrackCategory category,  PlaybackStatus status,  Duration position,  Duration duration,  double volume,  bool isShuffled,  bool isRepeating,  bool isPlaylistOpen,  bool is8BitEnabled,  bool isStereoEnabled,  bool isBassEnabled,  bool isSfxEnabled,  bool isGamingModeEnabled,  SleepTimerMode sleepTimerMode,  Duration? sleepTimerRemaining,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.track,_that.category,_that.status,_that.position,_that.duration,_that.volume,_that.isShuffled,_that.isRepeating,_that.isPlaylistOpen,_that.is8BitEnabled,_that.isStereoEnabled,_that.isBassEnabled,_that.isSfxEnabled,_that.isGamingModeEnabled,_that.sleepTimerMode,_that.sleepTimerRemaining,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState extends PlayerState {
  const _PlayerState({required this.track, this.category = TrackCategory.original, this.status = PlaybackStatus.ready, this.position = Duration.zero, this.duration = Duration.zero, this.volume = 0.85, this.isShuffled = false, this.isRepeating = false, this.isPlaylistOpen = false, this.is8BitEnabled = false, this.isStereoEnabled = true, this.isBassEnabled = true, this.isSfxEnabled = true, this.isGamingModeEnabled = false, this.sleepTimerMode = SleepTimerMode.off, this.sleepTimerRemaining, this.errorMessage}): super._();
  

@override final  Track track;
@override@JsonKey() final  TrackCategory category;
@override@JsonKey() final  PlaybackStatus status;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  double volume;
@override@JsonKey() final  bool isShuffled;
@override@JsonKey() final  bool isRepeating;
@override@JsonKey() final  bool isPlaylistOpen;
@override@JsonKey() final  bool is8BitEnabled;
@override@JsonKey() final  bool isStereoEnabled;
@override@JsonKey() final  bool isBassEnabled;
@override@JsonKey() final  bool isSfxEnabled;
@override@JsonKey() final  bool isGamingModeEnabled;
@override@JsonKey() final  SleepTimerMode sleepTimerMode;
@override final  Duration? sleepTimerRemaining;
@override final  String? errorMessage;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.track, track) || other.track == track)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isShuffled, isShuffled) || other.isShuffled == isShuffled)&&(identical(other.isRepeating, isRepeating) || other.isRepeating == isRepeating)&&(identical(other.isPlaylistOpen, isPlaylistOpen) || other.isPlaylistOpen == isPlaylistOpen)&&(identical(other.is8BitEnabled, is8BitEnabled) || other.is8BitEnabled == is8BitEnabled)&&(identical(other.isStereoEnabled, isStereoEnabled) || other.isStereoEnabled == isStereoEnabled)&&(identical(other.isBassEnabled, isBassEnabled) || other.isBassEnabled == isBassEnabled)&&(identical(other.isSfxEnabled, isSfxEnabled) || other.isSfxEnabled == isSfxEnabled)&&(identical(other.isGamingModeEnabled, isGamingModeEnabled) || other.isGamingModeEnabled == isGamingModeEnabled)&&(identical(other.sleepTimerMode, sleepTimerMode) || other.sleepTimerMode == sleepTimerMode)&&(identical(other.sleepTimerRemaining, sleepTimerRemaining) || other.sleepTimerRemaining == sleepTimerRemaining)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,track,category,status,position,duration,volume,isShuffled,isRepeating,isPlaylistOpen,is8BitEnabled,isStereoEnabled,isBassEnabled,isSfxEnabled,isGamingModeEnabled,sleepTimerMode,sleepTimerRemaining,errorMessage);

@override
String toString() {
  return 'PlayerState(track: $track, category: $category, status: $status, position: $position, duration: $duration, volume: $volume, isShuffled: $isShuffled, isRepeating: $isRepeating, isPlaylistOpen: $isPlaylistOpen, is8BitEnabled: $is8BitEnabled, isStereoEnabled: $isStereoEnabled, isBassEnabled: $isBassEnabled, isSfxEnabled: $isSfxEnabled, isGamingModeEnabled: $isGamingModeEnabled, sleepTimerMode: $sleepTimerMode, sleepTimerRemaining: $sleepTimerRemaining, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 Track track, TrackCategory category, PlaybackStatus status, Duration position, Duration duration, double volume, bool isShuffled, bool isRepeating, bool isPlaylistOpen, bool is8BitEnabled, bool isStereoEnabled, bool isBassEnabled, bool isSfxEnabled, bool isGamingModeEnabled, SleepTimerMode sleepTimerMode, Duration? sleepTimerRemaining, String? errorMessage
});


@override $TrackCopyWith<$Res> get track;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? category = null,Object? status = null,Object? position = null,Object? duration = null,Object? volume = null,Object? isShuffled = null,Object? isRepeating = null,Object? isPlaylistOpen = null,Object? is8BitEnabled = null,Object? isStereoEnabled = null,Object? isBassEnabled = null,Object? isSfxEnabled = null,Object? isGamingModeEnabled = null,Object? sleepTimerMode = null,Object? sleepTimerRemaining = freezed,Object? errorMessage = freezed,}) {
  return _then(_PlayerState(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TrackCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isShuffled: null == isShuffled ? _self.isShuffled : isShuffled // ignore: cast_nullable_to_non_nullable
as bool,isRepeating: null == isRepeating ? _self.isRepeating : isRepeating // ignore: cast_nullable_to_non_nullable
as bool,isPlaylistOpen: null == isPlaylistOpen ? _self.isPlaylistOpen : isPlaylistOpen // ignore: cast_nullable_to_non_nullable
as bool,is8BitEnabled: null == is8BitEnabled ? _self.is8BitEnabled : is8BitEnabled // ignore: cast_nullable_to_non_nullable
as bool,isStereoEnabled: null == isStereoEnabled ? _self.isStereoEnabled : isStereoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isBassEnabled: null == isBassEnabled ? _self.isBassEnabled : isBassEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSfxEnabled: null == isSfxEnabled ? _self.isSfxEnabled : isSfxEnabled // ignore: cast_nullable_to_non_nullable
as bool,isGamingModeEnabled: null == isGamingModeEnabled ? _self.isGamingModeEnabled : isGamingModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,sleepTimerMode: null == sleepTimerMode ? _self.sleepTimerMode : sleepTimerMode // ignore: cast_nullable_to_non_nullable
as SleepTimerMode,sleepTimerRemaining: freezed == sleepTimerRemaining ? _self.sleepTimerRemaining : sleepTimerRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res> get track {
  
  return $TrackCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}

// dart format on
