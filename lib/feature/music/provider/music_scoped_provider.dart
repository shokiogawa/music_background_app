import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/music.dart';

part 'music_scoped_provider.g.dart';

// コンポーネントにデータを渡す用のprovider
@riverpod
Music musicScoped(MusicScopedRef ref) {
  throw UnimplementedError();
}
