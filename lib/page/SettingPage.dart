import 'package:flutter/material.dart';

import '../widgets/settings/LinkSetting.dart';
import '../widgets/settings/SettingWidget.dart';
import '../widgets/settings/SimpleLinkSetting.dart';
import 'settings/CategoryFollowPage.dart';
import 'settings/GoogleSettingPage.dart';
import 'settings/TwitterSettingPage.dart';
import 'settings/ThemeSettingPage.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  List<SettingWidget> settings = [
    LinkSetting("カテゴリをフォロー", CategoryFollowPage()),
    LinkSetting("Twitterトレンド設定", TwitterSettingPage()),
    LinkSetting("Googleトレンド設定", GoogleSettingPage()),
    LinkSetting("テーマ", ThemeSettingPage()),
    SimpleLinkSetting("このアプリについて", ""),
    SimpleLinkSetting("利用規約", ""),
    SimpleLinkSetting("プライバシーポリシー", ""),
    SimpleLinkSetting("バージョン情報", ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.black,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: settings.map((e) => e.build(context)).toList()),
          /*<Widget>[
              GestureDetector(
                child: const Text("カテゴリをフォロー"),
                onTap: () {
                },
              ),
              GestureDetector(
                child: const Text("Twitterトレンド設定"),
              ),
              GestureDetector(
                child: const Text("Googleトレンド設定"),
              ),
              GestureDetector(
                child: const Text("テーマ"),
              ),
              GestureDetector(
                child: const Text("このアプリについて"),
              ),
              GestureDetector(
                child: const Text("利用規約"),
              ),
              GestureDetector(
                child: const Text("プライバシーポリシー"),
              ),
              GestureDetector(
                child: const Text("バージョン情報"),
              ),
            ],*/
        ),
      ),
    );
  }
}
