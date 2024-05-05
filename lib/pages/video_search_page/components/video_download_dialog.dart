import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/feature/music/provider/down_load_music_provider.dart';
import 'package:music_background_app/pages/music_list_page/provider/music_list_state_provider.dart';

import '../../../feature/video/provider/video_scoped_provider.dart';

class VideoDownloadDialog extends HookConsumerWidget {
  const VideoDownloadDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(videoScopedProvider).url;
    final asyncValue = ref.watch(downLoadMusicProvider);
    final isSuccess = useState(false);
    ref.listen(downLoadMusicProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });
    switch (asyncValue) {
      case (AsyncData(:final value, isLoading: false)):
        return SimpleDialog(
          title: isSuccess.value
              ? const Text("ダウンロードに成功しました。")
              : const Text("ダウンロードしますか？"),
          children: [
            Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (isSuccess.value) {
                        Navigator.of(context).pop();
                      } else {
                        await ref
                            .read(downLoadMusicProvider.notifier)
                            .invoke(url)
                            .then((value) => isSuccess.value = true);
                      }
                    },
                    child: isSuccess.value
                        ? const Text("戻る")
                        : const Text("ダウンロード"))
              ],
            )
          ],
        );
      case (AsyncError(:final error)):
        return SimpleDialog(
          title: const Text("エラーが発生しました。"),
          children: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("戻る"))
          ],
        );
      case AsyncData(isLoading: true):
        return const SimpleDialog(
          title: Text("ダウンロード中..."),
          children: [Center(child: CircularProgressIndicator())],
        );
      default:
        return const SimpleDialog(
          children: [Text("ダウンロード中。。。")],
        );
    }
  }
}
