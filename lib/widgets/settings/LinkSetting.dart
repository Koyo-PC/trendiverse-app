import 'package:flutter/material.dart';

import 'template/SettingWidgetContent.dart';

class LinkSetting extends SettingWidgetContent {
  final String title;
  final Widget page;

  LinkSetting(this.title, this.page);

  @override
  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
