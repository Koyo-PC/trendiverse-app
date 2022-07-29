import 'package:flutter/material.dart';

import '../widgets/settings/LinkSetting.dart';
import '../widgets/settings/template/SettingWidget.dart';
import '../widgets/settings/SimpleLinkSetting.dart';
import 'settings/CategoryFollowPage.dart';
import 'settings/GoogleSettingPage.dart';
import 'settings/TwitterSettingPage.dart';
import 'settings/ThemeSettingPage.dart';
import 'template/SubPageContent.dart';

class SettingPage extends SubPageContent {
  final List<SettingWidget> settings = [
    SettingWidget(LinkSetting("カテゴリをフォロー", const CategoryFollowPage())),
    SettingWidget(LinkSetting("Twitterトレンド設定", const TwitterSettingPage())),
    SettingWidget(LinkSetting("Googleトレンド設定", const GoogleSettingPage())),
    SettingWidget(LinkSetting("テーマ", const ThemeSettingPage())),
    SettingWidget(SimpleLinkSetting("このアプリについて", "")),
    SettingWidget(SimpleLinkSetting("利用規約", "")),
    SettingWidget(SimpleLinkSetting("プライバシーポリシー", "")),
    SettingWidget(SimpleLinkSetting("バージョン情報", "")),
  ];

  @override
  String getTitle() {
    return "設定";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
      ),
    );
  }
}
