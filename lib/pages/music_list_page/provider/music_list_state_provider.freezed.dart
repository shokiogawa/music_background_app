// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music_list_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProgressBarState {
  Duration get current => throw _privateConstructorUsedError;
  Duration get buffered => throw _privateConstructorUsedError;
  Duration get total => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProgressBarStateCopyWith<ProgressBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressBarStateCopyWith<$Res> {
  factory $ProgressBarStateCopyWith(
          ProgressBarState value, $Res Function(ProgressBarState) then) =
      _$ProgressBarStateCopyWithImpl<$Res, ProgressBarState>;
  @useResult
  $Res call({Duration current, Duration buffered, Duration total});
}

/// @nodoc
class _$ProgressBarStateCopyWithImpl<$Res, $Val extends ProgressBarState>
    implements $ProgressBarStateCopyWith<$Res> {
  _$ProgressBarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? buffered = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Duration,
      buffered: null == buffered
          ? _value.buffered
          : buffered // ignore: cast_nullable_to_non_nullable
              as Duration,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressBarStateImplCopyWith<$Res>
    implements $ProgressBarStateCopyWith<$Res> {
  factory _$$ProgressBarStateImplCopyWith(_$ProgressBarStateImpl value,
          $Res Function(_$ProgressBarStateImpl) then) =
      __$$ProgressBarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Duration current, Duration buffered, Duration total});
}

/// @nodoc
class __$$ProgressBarStateImplCopyWithImpl<$Res>
    extends _$ProgressBarStateCopyWithImpl<$Res, _$ProgressBarStateImpl>
    implements _$$ProgressBarStateImplCopyWith<$Res> {
  __$$ProgressBarStateImplCopyWithImpl(_$ProgressBarStateImpl _value,
      $Res Function(_$ProgressBarStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? buffered = null,
    Object? total = null,
  }) {
    return _then(_$ProgressBarStateImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Duration,
      buffered: null == buffered
          ? _value.buffered
          : buffered // ignore: cast_nullable_to_non_nullable
              as Duration,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$ProgressBarStateImpl implements _ProgressBarState {
  const _$ProgressBarStateImpl(
      {required this.current, required this.buffered, required this.total});

  @override
  final Duration current;
  @override
  final Duration buffered;
  @override
  final Duration total;

  @override
  String toString() {
    return 'ProgressBarState(current: $current, buffered: $buffered, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressBarStateImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.buffered, buffered) ||
                other.buffered == buffered) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, buffered, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressBarStateImplCopyWith<_$ProgressBarStateImpl> get copyWith =>
      __$$ProgressBarStateImplCopyWithImpl<_$ProgressBarStateImpl>(
          this, _$identity);
}

abstract class _ProgressBarState implements ProgressBarState {
  const factory _ProgressBarState(
      {required final Duration current,
      required final Duration buffered,
      required final Duration total}) = _$ProgressBarStateImpl;

  @override
  Duration get current;
  @override
  Duration get buffered;
  @override
  Duration get total;
  @override
  @JsonKey(ignore: true)
  _$$ProgressBarStateImplCopyWith<_$ProgressBarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MusicListState {
  List<Music> get musicList => throw _privateConstructorUsedError;
  ProgressBarState get progressBarState => throw _privateConstructorUsedError;
  String get musicTitle => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MusicListStateCopyWith<MusicListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MusicListStateCopyWith<$Res> {
  factory $MusicListStateCopyWith(
          MusicListState value, $Res Function(MusicListState) then) =
      _$MusicListStateCopyWithImpl<$Res, MusicListState>;
  @useResult
  $Res call(
      {List<Music> musicList,
      ProgressBarState progressBarState,
      String musicTitle,
      bool isPlaying});

  $ProgressBarStateCopyWith<$Res> get progressBarState;
}

/// @nodoc
class _$MusicListStateCopyWithImpl<$Res, $Val extends MusicListState>
    implements $MusicListStateCopyWith<$Res> {
  _$MusicListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicList = null,
    Object? progressBarState = null,
    Object? musicTitle = null,
    Object? isPlaying = null,
  }) {
    return _then(_value.copyWith(
      musicList: null == musicList
          ? _value.musicList
          : musicList // ignore: cast_nullable_to_non_nullable
              as List<Music>,
      progressBarState: null == progressBarState
          ? _value.progressBarState
          : progressBarState // ignore: cast_nullable_to_non_nullable
              as ProgressBarState,
      musicTitle: null == musicTitle
          ? _value.musicTitle
          : musicTitle // ignore: cast_nullable_to_non_nullable
              as String,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProgressBarStateCopyWith<$Res> get progressBarState {
    return $ProgressBarStateCopyWith<$Res>(_value.progressBarState, (value) {
      return _then(_value.copyWith(progressBarState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MusicListStateImplCopyWith<$Res>
    implements $MusicListStateCopyWith<$Res> {
  factory _$$MusicListStateImplCopyWith(_$MusicListStateImpl value,
          $Res Function(_$MusicListStateImpl) then) =
      __$$MusicListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Music> musicList,
      ProgressBarState progressBarState,
      String musicTitle,
      bool isPlaying});

  @override
  $ProgressBarStateCopyWith<$Res> get progressBarState;
}

/// @nodoc
class __$$MusicListStateImplCopyWithImpl<$Res>
    extends _$MusicListStateCopyWithImpl<$Res, _$MusicListStateImpl>
    implements _$$MusicListStateImplCopyWith<$Res> {
  __$$MusicListStateImplCopyWithImpl(
      _$MusicListStateImpl _value, $Res Function(_$MusicListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicList = null,
    Object? progressBarState = null,
    Object? musicTitle = null,
    Object? isPlaying = null,
  }) {
    return _then(_$MusicListStateImpl(
      musicList: null == musicList
          ? _value._musicList
          : musicList // ignore: cast_nullable_to_non_nullable
              as List<Music>,
      progressBarState: null == progressBarState
          ? _value.progressBarState
          : progressBarState // ignore: cast_nullable_to_non_nullable
              as ProgressBarState,
      musicTitle: null == musicTitle
          ? _value.musicTitle
          : musicTitle // ignore: cast_nullable_to_non_nullable
              as String,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MusicListStateImpl implements _MusicListState {
  const _$MusicListStateImpl(
      {final List<Music> musicList = const [],
      this.progressBarState = const ProgressBarState(
          current: Duration.zero,
          buffered: Duration.zero,
          total: Duration.zero),
      this.musicTitle = "",
      this.isPlaying = false})
      : _musicList = musicList;

  final List<Music> _musicList;
  @override
  @JsonKey()
  List<Music> get musicList {
    if (_musicList is EqualUnmodifiableListView) return _musicList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_musicList);
  }

  @override
  @JsonKey()
  final ProgressBarState progressBarState;
  @override
  @JsonKey()
  final String musicTitle;
  @override
  @JsonKey()
  final bool isPlaying;

  @override
  String toString() {
    return 'MusicListState(musicList: $musicList, progressBarState: $progressBarState, musicTitle: $musicTitle, isPlaying: $isPlaying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MusicListStateImpl &&
            const DeepCollectionEquality()
                .equals(other._musicList, _musicList) &&
            (identical(other.progressBarState, progressBarState) ||
                other.progressBarState == progressBarState) &&
            (identical(other.musicTitle, musicTitle) ||
                other.musicTitle == musicTitle) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_musicList),
      progressBarState,
      musicTitle,
      isPlaying);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MusicListStateImplCopyWith<_$MusicListStateImpl> get copyWith =>
      __$$MusicListStateImplCopyWithImpl<_$MusicListStateImpl>(
          this, _$identity);
}

abstract class _MusicListState implements MusicListState {
  const factory _MusicListState(
      {final List<Music> musicList,
      final ProgressBarState progressBarState,
      final String musicTitle,
      final bool isPlaying}) = _$MusicListStateImpl;

  @override
  List<Music> get musicList;
  @override
  ProgressBarState get progressBarState;
  @override
  String get musicTitle;
  @override
  bool get isPlaying;
  @override
  @JsonKey(ignore: true)
  _$$MusicListStateImplCopyWith<_$MusicListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
