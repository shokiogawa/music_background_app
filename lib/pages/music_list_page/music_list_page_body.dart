import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/components/music_card.dart';
import 'package:music_background_app/pages/music_list_page/provider/music_list_state_provider.dart';
import 'package:music_background_app/feature/music/provider/music_scoped_provider.dart';

import '../../feature/music/provider/get_music_list_provider.dart';

class MusicListPageBody extends HookConsumerWidget {
  const MusicListPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(getMusicListProvider);
    switch (async) {
      // 正常時
      case AsyncData(:final value):
        return ReorderableListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ProviderScope(
                key: Key(index.toString()),
                overrides: [
                  musicScopedProvider.overrideWithValue(value[index])
                ],
                child: GestureDetector(
                    onTap: () {
                      ref
                          .read(musicListStateNotifierProvider.notifier)
                          .tapMusic(index, value[index]);
                    },
                    child: MusicCard(index: index)));
          },
          itemCount: value.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            ref
                .read(musicListStateNotifierProvider.notifier)
                .changeMusicOrder(newIndex, oldIndex);
          },
        );

      // ローディング時
      default:
        return const Center(child: CircularProgressIndicator());
    }
    return Container();
  }
}
