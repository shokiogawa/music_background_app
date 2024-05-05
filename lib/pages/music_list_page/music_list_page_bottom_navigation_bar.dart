import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/provider/music_list_state_provider.dart';

class MusicListPageBottomNavigationBar extends HookConsumerWidget {
  const MusicListPageBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(musicListStateNotifierProvider.notifier);
    final asyncValue = ref.watch(musicListStateNotifierProvider);
    switch (asyncValue) {
      case AsyncValue(:final value):
        return Container(
          color: Colors.orange,
          height: MediaQuery.of(context).size.height / 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(value?.musicTitle ?? ""),
                ProgressBar(
                    progress: value?.progressBarState.current ?? const Duration(seconds: 0),
                    total: value?.progressBarState.total ?? const Duration(seconds: 0),
                    buffered: value?.progressBarState.buffered ?? const Duration(seconds: 0),
                    onSeek: notifier.seek),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          notifier.skipToPrevious();
                        },
                        icon: const Icon(Icons.skip_previous)),
                    PlayIcon(key: key),
                    IconButton(
                        onPressed: () {
                          notifier.skipToNext();
                        },
                        icon: const Icon(Icons.skip_next)),
                  ],
                )
              ],
            ),
          ),
        );
    }
  }
}

class PlayIcon extends HookConsumerWidget {
  const PlayIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying =
        ref.watch(musicListStateNotifierProvider).value?.isPlaying ?? false;
    final notifier = ref.read(musicListStateNotifierProvider.notifier);
    late Widget iconWidget;
    if (!isPlaying) {
      iconWidget = IconButton(
          onPressed: () {
            notifier.play();
          },
          icon: const Icon(Icons.play_arrow));
    } else {
      iconWidget = IconButton(
          onPressed: () {
            notifier.pause();
          },
          icon: const Icon(Icons.pause));
    }
    return iconWidget;
  }
}
