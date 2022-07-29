import 'package:flutter/material.dart';

import 'SettingWidgetContent.dart';

class SettingWidget {
  final SettingWidgetContent content;

  SettingWidget(this.content);

  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: content.build(context),
      ),
    );
  }
}
