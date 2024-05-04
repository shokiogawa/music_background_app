import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/music_list_page_body.dart';

class MusicListPage extends HookConsumerWidget {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const MusicListPageBody(),
      bottomNavigationBar: Container(),
    );
  }
}
