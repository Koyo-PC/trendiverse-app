import 'package:flutter/material.dart';

import 'template/SettingWidgetContent.dart';

class SelectSetting extends SettingWidgetContent {
  final String text;

  SelectSetting(this.text);

  @override
  void onTap(BuildContext context) {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }

}
