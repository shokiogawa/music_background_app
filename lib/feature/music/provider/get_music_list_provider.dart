import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/music.dart';
import '../repository/music_repository.dart';

part 'get_music_list_provider.g.dart';

@riverpod
Future<List<Music>> getMusicList(GetMusicListRef ref) async {
  final list = await ref.watch(musicRepositoryProvider).getListMusics();
  return list;
}
