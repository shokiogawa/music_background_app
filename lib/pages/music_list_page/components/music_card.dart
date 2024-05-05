import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/provider/music_list_state_provider.dart';
import 'package:music_background_app/feature/music/provider/music_scoped_provider.dart';

class MusicCard extends HookConsumerWidget {
  const MusicCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final music = ref.watch(musicScopedProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      child: ListTile(
        leading: Container(
            height: 100,
            width: 100,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.network(music.image)),
        title: Text(music.title),
        subtitle: Text(music.author),
        trailing: IconButton(
            onPressed: () {
              // ref.read(musicListStateProvider.notifier).removeMusic(index);
            },
            icon: const Icon(Icons.delete),
            color: Colors.red),
      ),
    );
    ;
  }
}
