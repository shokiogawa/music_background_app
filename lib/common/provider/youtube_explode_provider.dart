import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'youtube_explode_provider.g.dart';

@Riverpod(keepAlive: true)
YoutubeExplode youtubeExplode(YoutubeExplodeRef ref) {
  return YoutubeExplode();
}
