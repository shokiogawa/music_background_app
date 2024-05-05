import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/common/provider/youtube_explode_provider.dart';
import 'package:music_background_app/feature/video/model/video_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_repository.g.dart';

@riverpod
VideoRepository videoRepository(VideoRepositoryRef ref) {
  return VideoRepository(ref);
}

class VideoRepository {
  final Ref ref;

  VideoRepository(this.ref);

  Future<List<VideoModel>> searchVideo(String query) async {
    final yt = ref.watch(youtubeExplodeProvider);
    final searchList = await yt.search.search(query);
    final List<VideoModel> videoList = searchList
        .map((vi) => VideoModel(
            url: vi.url,
            title: vi.title,
            author: vi.author,
            thumnail: vi.thumbnails,
            duration: vi.duration!))
        .toList();
    return videoList;
  }
}
