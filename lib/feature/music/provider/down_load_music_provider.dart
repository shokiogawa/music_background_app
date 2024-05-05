import 'package:music_background_app/feature/music/provider/get_music_list_provider.dart';
import 'package:music_background_app/feature/music/repository/music_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'down_load_music_provider.g.dart';

@riverpod
class DownLoadMusic extends _$DownLoadMusic {
  @override
  Future<void> build() async {}

  Future<void> invoke(String url) async {
    state = const AsyncLoading<void>().copyWithPrevious(state);
    state = await AsyncValue.guard(
        () => ref.watch(musicRepositoryProvider).download(url));

    ref.invalidate(getMusicListProvider);
  }
}
