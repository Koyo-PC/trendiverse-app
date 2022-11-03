import 'package:flutter/material.dart';

import '../../AppColor.dart';
import 'SubPageContent.dart';

class SubPage extends StatelessWidget {
  final SubPageContent content;

  const SubPage(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.getTitle()),
        backgroundColor: AppColor.main,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      backgroundColor: AppColor.black,
      body: content.build(context),
    );
  }
}
