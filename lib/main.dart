import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './page/HomePage.dart';

void main() {
  runApp(const ProviderScope(child: TrenDiverseApp()));
}

class TrenDiverseApp extends StatelessWidget {
  const TrenDiverseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).backgroundColor.blue);
    return MaterialApp(
      title: 'TrenDiverse',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(90, 82, 131, 1),
        backgroundColor: Color.fromRGBO(42, 28, 52, 1),
        canvasColor: Color.fromRGBO(244, 242, 255, 1),
        unselectedWidgetColor: Color.fromRGBO(139, 130, 159, 1),
      ),
      home: const HomePage()
    );
  }
}