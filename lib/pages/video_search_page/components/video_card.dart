import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:music_background_app/pages/video_search_page/components/video_download_dialog.dart';
import 'package:music_background_app/feature/video/provider/video_scoped_provider.dart';

class VideoCard extends HookConsumerWidget {
  const VideoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final video = ref.watch(videoScopedProvider);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return VideoDownloadDialog(url: video.url);
            });
        // notifier.downLoadMusic(_video.url);
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AspectRatio(
                  aspectRatio: 12 / 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: Image.network(
                      video.thumnail.mediumResUrl,
                      fit: BoxFit.contain,
                    ),
                  )),
              Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: const EdgeInsets.only(
                      top: 5, bottom: 0, right: 10, left: 10),
                  child: Text(
                    video.title,
                    textAlign: TextAlign.center,
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(getVideoMinutes(video.duration)))
            ],
          )),
    );
  }

  String getVideoMinutes(Duration duration) {
    late String time;
    final String hour = duration.inHours.toString();
    final String minutes = duration.inMinutes.toString();
    final String seconds = duration.inSeconds.toString();
    if (hour != '0') {
      time = '$hour時間$minutes分$seconds秒';
    } else {
      time = '$minutes分$seconds秒';
    }
    return time;
  }
}
