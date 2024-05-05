import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'video_model.freezed.dart';

@freezed
class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String url,
    required String title,
    required String author,
    required ThumbnailSet thumnail,
    required Duration duration
  }) = _VideoModel;
}