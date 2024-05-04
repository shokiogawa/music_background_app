import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_directory_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Directory> appDirectory(AppDirectoryRef ref)async{
  return await getApplicationDocumentsDirectory();
}