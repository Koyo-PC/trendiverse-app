import 'package:flutter/material.dart';

import 'SubPageContent.dart';

class SubPage extends StatelessWidget {
  final SubPageContent content;

  const SubPage(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.getTitle()),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: content.build(context),
    );
  }
}
