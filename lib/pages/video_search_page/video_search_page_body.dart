import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/feature/video/provider/search_video_provider.dart';
import 'package:music_background_app/feature/video/provider/video_scoped_provider.dart';

import 'components/video_card.dart';

class VideoSearchPageBody extends HookConsumerWidget {
  const VideoSearchPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(searchVideoProvider);
    switch (asyncValue) {
      case AsyncData(:final value):
        return ListView.builder(
            itemCount: value.length,
            itemBuilder: (BuildContext context, int index) {
              return ProviderScope(overrides: [
                videoScopedProvider.overrideWithValue(value[index])
              ], child: const VideoCard());
            });
      case AsyncError(:final error, :final stackTrace):
        return Center(child: Text(error.toString()));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
