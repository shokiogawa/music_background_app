import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/music_list_page/provider/music_list_state_provider.dart';

class VideoDownloadDialog extends HookConsumerWidget {
  const VideoDownloadDialog({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(musicListStateNotifierProvider);
    switch (asyncValue) {
      case (AsyncData(:final value)):
        return SimpleDialog(
          title: const Text("ダウンロードしますか？"),
          children: [
            Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(musicListStateNotifierProvider.notifier)
                          .downLoadMusic(url);
                    },
                    child: const Text("ダウンロード"))
              ],
            )
          ],
        );
      case (AsyncError()):
        return const SimpleDialog(
          title: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("エラーが発生しました。"),
          ),
        );
      default:
        return const SimpleDialog(
          title: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("ダウンロード中。。。"),
          ),
        );
    }
  }
}
