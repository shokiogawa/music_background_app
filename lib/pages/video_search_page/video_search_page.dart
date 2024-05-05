import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/video_search_page/video_search_page_app_bar.dart';
import 'package:music_background_app/pages/video_search_page/video_search_page_body.dart';

class VideoSearchPage extends HookConsumerWidget {
  const VideoSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: VideoSearchPageAppBar(),
      body: VideoSearchPageBody(),
    );
  }
}
