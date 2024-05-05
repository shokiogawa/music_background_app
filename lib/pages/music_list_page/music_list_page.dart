import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/music_list_page_body.dart';
import 'package:music_background_app/pages/music_list_page/music_list_page_bottom_navigation_bar.dart';

class MusicListPage extends HookConsumerWidget {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("検索"),
      ),
      body: const MusicListPageBody(),
      bottomNavigationBar: const MusicListPageBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
        Navigator.pushNamed(context, '/video_search_page');
      }),
    );
  }
}
