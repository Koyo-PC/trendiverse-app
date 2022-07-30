import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../page/template/SubPage.dart';
import '../../page/template/SubPageContent.dart';
import 'LinkSetting.dart';

class MdLinkSetting extends LinkSetting {

  MdLinkSetting(title, location) : super(title, SubPage(MdLinkSettingPage(title, location)));
}

class MdLinkSettingPage extends SubPageContent {
  String title;

  String location;

  MdLinkSettingPage(this.title, this.location);

  late final FutureProvider<Widget> contentProvider = FutureProvider((ref) async {
    var content = await rootBundle.loadString('assets/' + location);
    return Markdown(data: content);
  });

  @override
  String getTitle() {
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(contentProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (widget) => widget,
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        );
      },
    );
  }
}
