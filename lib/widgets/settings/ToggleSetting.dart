import 'package:flutter/material.dart';

import 'template/SettingWidgetContent.dart';

class ToggleSetting extends SettingWidgetContent {
  final String text;

  ToggleSetting(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
