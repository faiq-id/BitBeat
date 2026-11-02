// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Track {

 String get id; String get title; String get artist; String get assetPath; Duration get displayDuration; String get format; TrackCategory get category;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.format, format) || other.format == format)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,artist,assetPath,displayDuration,format,category);

@override
String toString() {
  return 'Track(id: $id, title: $title, artist: $artist, assetPath: $assetPath, displayDuration: $displayDuration, format: $format, category: $category)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String id, String title, String artist, String assetPath, Duration displayDuration, String format, TrackCategory category
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? assetPath = null,Object? displayDuration = null,Object? format = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,displayDuration: null == displayDuration ? _self.displayDuration : displayDuration // ignore: cast_nullable_to_non_nullable
as Duration,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TrackCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String assetPath,  Duration displayDuration,  String format,  TrackCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.assetPath,_that.displayDuration,_that.format,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String assetPath,  Duration displayDuration,  String format,  TrackCategory category)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.id,_that.title,_that.artist,_that.assetPath,_that.displayDuration,_that.format,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String artist,  String assetPath,  Duration displayDuration,  String format,  TrackCategory category)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.assetPath,_that.displayDuration,_that.format,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _Track implements Track {
  const _Track({required this.id, required this.title, required this.artist, required this.assetPath, required this.displayDuration, required this.format, this.category = TrackCategory.original});
  

@override final  String id;
@override final  String title;
@override final  String artist;
@override final  String assetPath;
@override final  Duration displayDuration;
@override final  String format;
@override@JsonKey() final  TrackCategory category;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.format, format) || other.format == format)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,artist,assetPath,displayDuration,format,category);

@override
String toString() {
  return 'Track(id: $id, title: $title, artist: $artist, assetPath: $assetPath, displayDuration: $displayDuration, format: $format, category: $category)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String artist, String assetPath, Duration displayDuration, String format, TrackCategory category
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? assetPath = null,Object? displayDuration = null,Object? format = null,Object? category = null,}) {
  return _then(_Track(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,displayDuration: null == displayDuration ? _self.displayDuration : displayDuration // ignore: cast_nullable_to_non_nullable
as Duration,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TrackCategory,
  ));
}


}

// dart format on
