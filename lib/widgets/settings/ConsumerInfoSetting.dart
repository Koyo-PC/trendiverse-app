import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'InfoSetting.dart';

class ConsumerInfoSetting extends InfoSetting {
  final String Function(BuildContext context, WidgetRef ref, Widget? child)
      builder;

  ConsumerInfoSetting(text, this.builder) : super(text, 'DUMMY');

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
          builder: (context, watch, child) {
            return Text(builder(context, watch, child));
          },
        ),
      ],
    );
  }
}
