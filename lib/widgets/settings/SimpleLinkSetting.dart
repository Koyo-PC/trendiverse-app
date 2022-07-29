import 'package:flutter/material.dart';

import '../../page/template/SubPage.dart';
import '../../page/template/SubPageContent.dart';

import 'LinkSetting.dart';

class SimpleLinkSetting extends LinkSetting {

  SimpleLinkSetting(title, content) : super(title, SubPage(SimpleLinkSettingPage(title, content)));
}

class SimpleLinkSettingPage extends SubPageContent {
  String title;

  String content;

  SimpleLinkSettingPage(this.title, this.content);

  @override
  String getTitle() {
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Text(content);
  }
}
