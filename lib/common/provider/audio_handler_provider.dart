import 'package:audio_service/audio_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_background_app/common/provider/app_directory_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_handler_provider.g.dart';


@riverpod
MyAudioHandler myAudioHandler(MyAudioHandlerRef ref){
  throw UnimplementedError();
}

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final player = AudioPlayer();
  final playList = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _loadEmptyPlaylist();
    _listenForDurationChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(playList);
    } catch (e) {
      Future.error(e);
    }
  }

  void _listenForDurationChanges() {
    player.durationStream.listen((duration) {
      final index = player.currentIndex;
      final newQue = queue.value;
      if (index == null || newQue.isEmpty) return;
      final oldMediaItem = newQue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQue[index] = newMediaItem;
      queue.add(newQue);
      mediaItem.add(newMediaItem);
    });
  }

  //バックグラウンドで通知するもの。
  //just_audioとaudio_serviceの虫びつけを行なっていると思ってもいい。
  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        //特定のボタンを持たないアクション
        systemActions: const {
          MediaAction.seek,
        },
        //0: previous、 1: 再生、2: 止める、 3: next
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode]!,
        shuffleMode: (player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        //just_audioをaudio_serviceに知らせる。
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        queueIndex: event.currentIndex,
      ));
    });
  }

  Future<void> setPlayList(List<MediaItem> mediaItems) async {
    Future.forEach(mediaItems, (MediaItem mediaItem) async {
      final audioSource = await _createAudioSource(mediaItem.title);
      playList.add(audioSource);
    });
    await player.setAudioSource(playList);
  }

  Future<void> tapMusic(int index) async {
    await player.seek(Duration.zero, index: index);
    if (!player.playing) {
      await play();
    }
  }

  @override
  Future<void> play() async {
    // await _player.setAudioSource(_playList);
    // TODO: implement play
    await player.play();
    return super.play();
  }

  @override
  Future<void> pause() async {
    // TODO: implement pause
    await player.pause();
    return super.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    // TODO: implement skipToNext
    await player.seekToNext();
    return super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    // TODO: implement skipToPrevious
    await player.seekToPrevious();
    return super.skipToPrevious();
  }

  @override
  Future<void> stop() async {
    // TODO: implement stop
    await player.dispose();
    return super.stop();
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    Future.forEach(mediaItems, (MediaItem mediaItem) async {
      final audioSource = await _createAudioSource(mediaItem.title);
      await playList.add(audioSource);
    });
    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = await _createAudioSource(mediaItem.title);
    await playList.add(audioSource);

    final newQue = queue.value..add(mediaItem);
    queue.add(newQue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await playList.removeAt(index);
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  Future<void> changeMusicOrder(
      int newIndex, int oldIndex, MediaItem movedMediaItem) async {
    final movedMusic = playList[oldIndex];
    await playList.removeAt(oldIndex);
    await playList.insert(newIndex, movedMusic);
    final newQue = queue.value
      ..removeAt(oldIndex)
      ..insert(newIndex, movedMediaItem);
    queue.add(newQue);
  }

  Future<void> clear() async {
    await playList.clear();
  }

  Future<UriAudioSource> _createAudioSource(String musicName) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    String musicPath = '$path/musics/$musicName';
    return AudioSource.uri(Uri.file(musicPath));
  }
}
