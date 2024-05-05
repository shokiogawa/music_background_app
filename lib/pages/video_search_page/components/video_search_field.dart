import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyTextField extends HookConsumerWidget {

  const MyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    return TextField(
      controller: controller,
      cursorColor: Colors.green,
      style: const TextStyle(color: Colors.green, fontSize: 20),
      textInputAction: TextInputAction.search,
      //キーボードのアクションボタンを指定
      decoration: const InputDecoration(
        //TextFiledのスタイル
        enabledBorder: UnderlineInputBorder(
          //デフォルトのTextFieldの枠線
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
          //TextFieldにフォーカス時の枠線
            borderSide: BorderSide(color: Colors.white)),
        hintText: '検索', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle(
          //hintTextのスタイル
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}