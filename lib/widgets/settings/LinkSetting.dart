import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:trendiverse/widgets/settings/SettingWidget.dart';

class LinkSetting extends SettingWidget {
  final String title;

  Widget page;

  LinkSetting(this.title, this.page)
      : super(
          (context) => GestureDetector(
            child: Text(title),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              ),
            },
          ),
        );
}
