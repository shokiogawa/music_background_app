import 'package:music_background_app/feature/video/model/video_model.dart';
import 'package:music_background_app/feature/video/repository/video_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_video_provider.g.dart';

@riverpod
class SearchVideo extends _$SearchVideo {
  @override
  Future<List<VideoModel>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    // 検索中はローディングにする
    state = const AsyncLoading<List<VideoModel>>();
    state = await AsyncValue.guard(
        () => ref.watch(videoRepositoryProvider).searchVideo(query));
  }
}
