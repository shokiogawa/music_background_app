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
class MusicListStateNotifier extends _$MusicListStateNotifier with WidgetsBindingObserver {
  MusicListState? get value => state.value;

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
    (await ref.watch(audioHandlerProvider.future)).addQueueItems(mediaItems);
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
          buffered: value!.progressBarState.buffered,
          total: value!.progressBarState.total);
      update((value) {
        value = value.copyWith(progressBarState: newState);
        return value;
      });
    });
  }

  Future<void> _listenToBufferedPosition() async {
    (await ref.watch(audioHandlerProvider.future))
        .playbackState
        .listen((playbackState) {
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

  Future<void> _listenToTotalDuration() async {
    (await ref.watch(audioHandlerProvider.future))
        .mediaItem
        .listen((mediaItem) {
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

  Future<void> _listenToChangeMusic() async {
    (await ref.watch(audioHandlerProvider.future)).mediaItem.listen((value) {
      update((value) {
        value = value.copyWith(musicTitle: value.musicTitle ?? "");
        return value;
      });
    });
  }

  Future<void> _listenToIsPlay() async {
    (await ref.watch(audioHandlerProvider.future))
        .playbackState
        .listen((backState) {
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
    await (await ref.watch(audioHandlerProvider.future))
        .changeMusicOrder(newIndex, oldIndex, moveMediaItem);
  }

  Future<void> tapMusic(int index) async {
    await (await ref.watch(audioHandlerProvider.future)).tapMusic(index);
  }

  Future<void> play() async {
    await (await ref.watch(audioHandlerProvider.future)).play();
  }

  Future<void> stop() async {
    (await ref.watch(audioHandlerProvider.future)).stop();
  }

  Future<void> pause() async {
    (await ref.watch(audioHandlerProvider.future)).pause();
  }

  Future<void> skipToNext() async {
    (await ref.watch(audioHandlerProvider.future)).skipToNext();
  }

  Future<void> skipToPrevious() async {
    (await ref.watch(audioHandlerProvider.future)).skipToPrevious();
  }

  Future<void> addQueueItems() async {
    final List<Music> musicList = await ref.watch(getMusicListProvider.future);
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    (await ref.watch(audioHandlerProvider.future)).addQueueItems(mediaItems);
  }

  Future<void> clear() async {
    (await ref.watch(audioHandlerProvider.future)).clear();
  }

  //Musicデータフェッチ
  Future<void> setPlayList() async {
    final List<Music> musicList = value!.musicList;
    final List<MediaItem> mediaItems = musicList
        .map((music) => MediaItem(id: music.title, title: music.title))
        .toList();
    await (await ref.watch(audioHandlerProvider.future))
        .setPlayList(mediaItems);
  }

  // 音楽追加
  Future<void> downLoadMusic(String url) async {
    state = const AsyncLoading<MusicListState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await ref.watch(musicRepositoryProvider).download(url);
      return _future();
    });
    ref.invalidate(musicListStateNotifierProvider);
  }

  // 削除
  Future<void> removeMusic(int index) async {
    //queueから音楽を削除
    await (await ref.watch(audioHandlerProvider.future))
        .removeQueueItemAt(index);

    ref
        .watch(musicRepositoryProvider)
        .deleteMusic(value!.musicList[index].title);

    ref.invalidate(getMusicListProvider);
  }

  Future<void> seek(Duration position) async {
    (await ref.watch(audioHandlerProvider.future)).seek(position);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      (await ref.watch(audioHandlerProvider.future)).stop();
    }
  }
}
