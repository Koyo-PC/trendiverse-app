import 'package:flutter/material.dart';

class SettingWidget {
  final Widget Function(BuildContext) buildFn;

  SettingWidget(this.buildFn);

  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: buildFn(context),
      ),
    );
  }
}
