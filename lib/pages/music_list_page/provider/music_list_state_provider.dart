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
class MusicState with _$MusicState {
  const factory MusicState({
    @Default([]) List<Music> musicList,
    @Default(ProgressBarState(
        current: Duration.zero, buffered: Duration.zero, total: Duration.zero))
    ProgressBarState progressBarState,
    @Default("") String musicTitle,
    @Default(false) bool isPlaying,
  }) = _MusicState;
}

@riverpod
class MusicListState extends _$MusicListState with WidgetsBindingObserver {
  MusicState? get value => state.value;

  @override
  Future<MusicState> build() async {
    WidgetsBinding.instance.addObserver(this);

    final musicList = await _future();
    return MusicState(musicList: musicList);
  }

  Future<List<Music>> _future() async {
    final musicList = await ref.watch(getMusicListProvider.future);
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    ref.watch(audioHandlerProvider).addQueueItems(mediaItems);
    _listenToBufferedPosition();
    _listenToChangeMusic();
    _listenToCurrentPosition();
    _listenToIsPlay();
    _listenToTotalDuration();
    return musicList;
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final newState = ProgressBarState(
          current: position,
          buffered: value!.progressBarState.buffered,
          total: value!.progressBarState.total);
      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToBufferedPosition() {
    final handler = ref.watch(audioHandlerProvider);
    handler.playbackState.listen((playbackState) {
      final newState = ProgressBarState(
          current: value!.progressBarState.current,
          buffered: playbackState.bufferedPosition,
          total: value!.progressBarState.total);

      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToTotalDuration() {
    final handler = ref.watch(audioHandlerProvider);
    handler.mediaItem.listen((mediaItem) {
      final newState = ProgressBarState(
          current: value!.progressBarState.current,
          buffered: value!.progressBarState.buffered,
          total: mediaItem?.duration ?? Duration.zero);

      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  void _listenToChangeMusic() {
    final handler = ref.watch(audioHandlerProvider);
    handler.mediaItem.listen((value) {
      update((value) {
        value = value.copyWith(musicTitle: value.musicTitle ?? "");
        return value;
      });
    });
  }

  void _listenToIsPlay() {
    final handler = ref.watch(audioHandlerProvider);
    handler.playbackState.listen((backState) {
      update((value) {
        value = value.copyWith(isPlaying: backState.playing);
        return value;
      });
    });
  }

  Future<void> changeMusicOrder(int newIndex, int oldIndex) async {
    final handler = ref.watch(audioHandlerProvider);
    final Music moveMusic = value!.musicList.removeAt(oldIndex);
    value!.musicList.insert(newIndex, moveMusic);
    final moveMediaItem =
        MediaItem(id: moveMusic.title, title: moveMusic.title);
    await handler.changeMusicOrder(newIndex, oldIndex, moveMediaItem);
  }

  Future<void> tapMusic(int index) async {
    final handler = ref.watch(audioHandlerProvider);
    await handler.tapMusic(index);
  }

  Future<void> play() async {
    final handler = ref.watch(audioHandlerProvider);
    await handler.play();
  }

  Future<void> stop() async {
    final handler = ref.watch(audioHandlerProvider);
    handler.stop();
  }

  Future<void> pause() async {
    final handler = ref.watch(audioHandlerProvider);
    handler.pause();
  }

  Future<void> skipToNext() async {
    final handler = ref.watch(audioHandlerProvider);
    handler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    final handler = ref.watch(audioHandlerProvider);
    handler.skipToPrevious();
  }

  Future<void> addQueueItems() async {
    final handler = ref.watch(audioHandlerProvider);
    final List<Music> musicList = await ref.watch(getMusicListProvider.future);
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    handler.addQueueItems(mediaItems);
  }

  Future<void> clear() async {
    final handler = ref.watch(audioHandlerProvider);
    handler.clear();
  }

  //Musicデータフェッチ
  Future<void> setPlayList() async {
    final handler = ref.watch(audioHandlerProvider);
    final List<Music> musicList = value!.musicList;
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    await handler.setPlayList(mediaItems);
  }

  // 音楽追加
  Future<void> downLoadMusic(String url) async {
    await ref.watch(musicRepositoryProvider).download(url);
    ref.invalidate(getMusicListProvider);
  }

  // 削除
  Future<void> removeMusic(int index) async {
    final handler = ref.watch(audioHandlerProvider);
    //queueから音楽を削除
    await handler.removeQueueItemAt(index);

    ref
        .watch(musicRepositoryProvider)
        .deleteMusic(value!.musicList[index].title);

    ref.invalidate(getMusicListProvider);
  }

  Future<void> seek(Duration position) async {
    final handler = ref.watch(audioHandlerProvider);
    handler.seek(position);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final handler = ref.watch(audioHandlerProvider);
    if (state == AppLifecycleState.detached) {
      handler.stop();
    }
  }
}
