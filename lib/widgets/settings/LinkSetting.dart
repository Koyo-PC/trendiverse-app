import 'package:flutter/material.dart';

import 'template/SettingWidgetContent.dart';

class LinkSetting extends SettingWidgetContent {
  final String title;
  final Widget page;

  LinkSetting(this.title, this.page);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(title),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        ),
      },
    );
  }
}
