import 'package:flutter/material.dart';
import 'SettingWidget.dart';

class ToggleSetting extends SettingWidget {
  final String text;

  ToggleSetting(this.text) : super((_) => Text(text));
}
