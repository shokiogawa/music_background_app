import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_background_app/common/provider/audio_handler_provider.dart';
import 'package:music_background_app/feature/music/provider/get_music_list_provider.dart';
import 'package:music_background_app/feature/music/repository/music_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../feature/music/model/music.dart';

part 'music_list_state_provider.freezed.dart';

part 'music_list_state_provider.g.dart';

@freezed
class ProgressBarState with _$ProgressBarState {
  const factory ProgressBarState({
    required Duration current,
    required Duration buffered,
    required Duration total,
  }) = _ProgressBarState;
}

@freezed
class MusicListState with _$MusicListState {
  const factory MusicListState({
    @Default([]) List<Music> musicList,
    @Default(ProgressBarState(
        current: Duration.zero, buffered: Duration.zero, total: Duration.zero))
    ProgressBarState progressBarState,
    @Default("") String musicTitle,
    @Default(false) bool isPlaying,
  }) = _MusicListState;
}

@riverpod
class MusicListStateNotifier extends _$MusicListStateNotifier
    with WidgetsBindingObserver {
  MusicListState? get value => state.value;

  MyAudioHandler get handler => ref.watch(myAudioHandlerProvider);

  @override
  Future<MusicListState> build() async {
    WidgetsBinding.instance.addObserver(this);

    return _future();
  }

  Future<MusicListState> _future() async {
    final musicList = await ref.watch(getMusicListProvider.future);
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    await ref.watch(myAudioHandlerProvider).addQueueItems(mediaItems);
    _listenToBufferedPosition();
    _listenToChangeMusic();
    _listenToCurrentPosition();
    _listenToIsPlay();
    _listenToTotalDuration();
    return MusicListState(musicList: musicList);
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final newState = ProgressBarState(
          current: position,
          buffered:
              value?.progressBarState.buffered ?? const Duration(seconds: 0),
          total: value?.progressBarState.total ?? const Duration(seconds: 0));
      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToBufferedPosition() {
    handler.playbackState.listen((playbackState) {
      final newState = ProgressBarState(
          current:
              value?.progressBarState.current ?? const Duration(seconds: 0),
          buffered: playbackState.bufferedPosition,
          total: value?.progressBarState.total ?? const Duration(seconds: 0));

      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToTotalDuration() {
    handler.mediaItem.listen((mediaItem) {
      final newState = ProgressBarState(
          current:
              value?.progressBarState.current ?? const Duration(seconds: 0),
          buffered:
              value?.progressBarState.buffered ?? const Duration(seconds: 0),
          total: mediaItem?.duration ?? Duration.zero);

      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToChangeMusic() {
    handler.mediaItem.listen((value) {
      update((value) {
        value = value.copyWith(musicTitle: value.musicTitle ?? "");
        return value;
      });
    });
  }

  void _listenToIsPlay() {
    handler.playbackState.listen((backState) {
      update((value) {
        value = value.copyWith(isPlaying: backState.playing);
        return value;
      });
    });
  }

  Future<void> changeMusicOrder(int newIndex, int oldIndex) async {
    final Music moveMusic = value!.musicList.removeAt(oldIndex);
    value!.musicList.insert(newIndex, moveMusic);
    final moveMediaItem =
        MediaItem(id: moveMusic.title, title: moveMusic.title);
    await handler.changeMusicOrder(newIndex, oldIndex, moveMediaItem);
  }

  Future<void> tapMusic(int index, Music selectMusic) async {
    update((value) {
      value = value.copyWith(musicTitle: selectMusic.title);
      return value;
    });
    await handler.tapMusic(index);
  }

  Future<void> play() async {
    await handler.play();
  }

  Future<void> stop() async {
    handler.stop();
  }

  Future<void> pause() async {
    handler.pause();
  }

  Future<void> skipToNext() async {
    handler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    handler.skipToPrevious();
  }

  Future<void> addQueueItems() async {
    final List<Music> musicList = await ref.watch(getMusicListProvider.future);
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    handler.addQueueItems(mediaItems);
  }

  Future<void> clear() async {
    handler.clear();
  }

  //Musicデータフェッチ
  Future<void> setPlayList() async {
    final List<Music> musicList = value!.musicList;
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    await handler.setPlayList(mediaItems);
  }

  // 削除
  Future<void> removeMusic(int index) async {
    //queueから音楽を削除
    await handler.removeQueueItemAt(index);

    ref
        .watch(musicRepositoryProvider)
        .deleteMusic(value!.musicList[index].title);

    ref.invalidate(getMusicListProvider);
    ref.invalidateSelf();
  }

  Future<void> seek(Duration position) async {
    handler.seek(position);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      handler.stop();
    }
  }
}
