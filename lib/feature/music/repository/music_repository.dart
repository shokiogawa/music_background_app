import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/common/provider/app_directory_provider.dart';
import 'package:music_background_app/common/provider/shared_preferences_provider.dart';
import 'package:music_background_app/common/provider/youtube_explode_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/music.dart';

part 'music_repository.g.dart';

@riverpod
MusicRepository musicRepository(MusicRepositoryRef ref) {
  return MusicRepository(ref);
}

class MusicRepository {
  final Ref ref;

  MusicRepository(this.ref);

  Future<void> download(String url) async {
    // アプリのディレクトリを取得
    final myDirectory = await ref.watch(appDirectoryProvider.future);

    final yt = ref.watch(youtubeExplodeProvider);
    final path = myDirectory.path;

    //動画の情報をl一括取得
    final video = await yt.videos.get(url);
    final manifest = await yt.videos.streamsClient.getManifest(url);
    final streamAudioInfo = manifest.audioOnly;
    final audio = streamAudioInfo.first;
    final stream = yt.videos.streamsClient.get(audio);
    //動画のタイトルを取得し、余分な文字列を削除。
    final musicTitle = '${video.title}.${audio.container.name}'
        .replaceAll(r'\', '')
        .replaceAll('/', '')
        .replaceAll('*', '')
        .replaceAll('?', '')
        .replaceAll('"', '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('|', '')
        .replaceAll('}', '');
    final Music music = Music(
      title: musicTitle,
      author: video.author,
      image: video.thumbnails.standardResUrl,
    );
    final directory = Directory('$path/musics/');
    await directory.create(recursive: true);

    //まだ音楽がダウンロードされていない場合。
    if (await File('$path/musics/$musicTitle').exists() != true) {
      //ディレクトリの作成
      //ファイルの作成
      final musicFile = File('$path/musics/$musicTitle');
      final outPut = musicFile.openWrite(mode: FileMode.writeOnlyAppend);

      double count = 0;
      final len = audio.size.totalBytes;
      //下の処理を待たずに行ってしまう。けどダウンロードはできている。
      await for (final data in stream) {
        count += data.length;
        var progress = ((count / len) * 100).ceil();
        print(progress);
        outPut.add(data);
      }
      await saveMusic(music);
      await outPut.flush();
      await outPut.close();
    }
    // return music;
  }

  // 音楽を保存
  Future<void> saveMusic(Music music) async {
    try {
      final preference = await ref.watch(sharedPreferencesProvider.future);

      // 現在のデータを取得する
      final List<String> musicsStringList =
          preference.getStringList('musics') ?? [];

      final List<Music> musicList = musicsStringList
          .map((musicJson) => Music.fromJson(jsonDecode(musicJson)))
          .toList();

      //保存したいデータを追加
      musicList.add(music);

      //Dart型をList<String>に変更する。
      final List<String> musicsJson =
          musicList.map((music) => jsonEncode(music.toJson())).toList();

      //データを保存。
      await preference.setStringList('musics', musicsJson);
    } on Exception catch (error, stack) {
      rethrow;
    }
  }

  // 音楽一覧を保存
  @override
  Future<void> saveListMusic(List<Music> musicList) async {
    final preferences = await ref.watch(sharedPreferencesProvider.future);

    // 保存対象の音楽をjson化
    final List<String> musicsJson =
        musicList.map((music) => jsonEncode(music.toJson())).toList();

    //データを保存。
    await preferences.setStringList('musics', musicsJson);
  }

  // 音楽一覧を取得
  @override
  Future<List<Music>> getListMusics() async {
    final preferences = await ref.watch(sharedPreferencesProvider.future);

    // 音楽一覧を取得jsonで取得
    final List<String> musicsString = preferences.getStringList('musics') ?? [];

    // 音楽一覧を型変換し取得
    final List<Music> musicList = musicsString
        .map((musicJson) => Music.fromJson(jsonDecode(musicJson)))
        .toList();

    return musicList;
  }

  @override
  Future<void> deleteMusic(String musicTitle) async {
    final myDirectory = await ref.watch(appDirectoryProvider.future);
    final path = myDirectory.path;
    final musicFile = File('$path/musics/$musicTitle');
    musicFile.deleteSync();

    final list = await getListMusics();
    final newData = list.where((element) => element.title != musicTitle).toList();
    await saveListMusic(newData);
  }
}
