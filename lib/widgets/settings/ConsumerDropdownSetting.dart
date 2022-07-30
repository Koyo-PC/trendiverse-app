import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'template/SettingWidgetContent.dart';

class ConsumerDropdownSetting extends SettingWidgetContent {
  final String text;
  final List<String> items;
  final Function(
          String? value, BuildContext context, WidgetRef ref, Widget? child)
      onChanged;
  final String Function(
          BuildContext context, WidgetRef ref, Widget? child)
      getValue;

  ConsumerDropdownSetting(this.text, this.items, this.onChanged, this.getValue);

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
        Consumer(
          builder: (context, ref, child) {
            return DropdownButton(
              itemHeight: 50,
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
              items: items
                  .map((item) => DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      ))
                  .toList(),
              onChanged: (String? value) =>
                  onChanged(value, context, ref, child),
              value: getValue(context, ref, child),
            );
          },
        ),
      ],
    );
  }
}

enum ThemeMode {
  light,
  dark,
}
