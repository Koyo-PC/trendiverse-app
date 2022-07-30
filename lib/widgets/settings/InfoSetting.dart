import 'package:flutter/material.dart';

import 'template/SettingWidgetContent.dart';

class InfoSetting extends SettingWidgetContent {
  final String text;
  final String value;

  InfoSetting(this.text, this.value);

  @override
  void onTap(BuildContext context) {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(text),
        Text(value),
      ],
    );
  }

}
