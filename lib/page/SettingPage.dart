import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widgets/settings/ConsumerInfoSetting.dart';
import '../widgets/settings/LinkSetting.dart';
import '../widgets/settings/SimpleLinkSetting.dart';
import '../widgets/settings/template/SettingWidget.dart';
import 'settings/CategoryFollowPage.dart';
import 'settings/GoogleSettingPage.dart';
import 'settings/TwitterSettingPage.dart';
import 'settings/ThemeSettingPage.dart';
import 'template/SubPage.dart';
import 'template/SubPageContent.dart';

class SettingPage extends SubPageContent {
  // 分離?
  final FutureProvider<PackageInfo> appInfoProvider =
      FutureProvider((ref) async {
    return await PackageInfo.fromPlatform();
  });

  late final List<SettingWidget> settings = [
    SettingWidget(LinkSetting("カテゴリをフォロー", SubPage(CategoryFollowPage()))),
    SettingWidget(LinkSetting("Twitterトレンド設定", SubPage(TwitterSettingPage()))),
    SettingWidget(LinkSetting("Googleトレンド設定", SubPage(GoogleSettingPage()))),
    SettingWidget(LinkSetting("テーマ", SubPage(ThemeSettingPage()))),
    // Select?
    SettingWidget(SimpleLinkSetting("このアプリについて", "")),
    // Markdown?
    SettingWidget(SimpleLinkSetting("利用規約", "")),
    SettingWidget(SimpleLinkSetting("プライバシーポリシー", "")),
    SettingWidget(
      ConsumerInfoSetting(
        "バージョン情報",
        (_, ref, __) => ref.watch(appInfoProvider).when(
              loading: () => "",
              data: (data) => data.version,
              error: (error, stack) => "error",
            ),
      ),
    ),
    // Key-Value?
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
