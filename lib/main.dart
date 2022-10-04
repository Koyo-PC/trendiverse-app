import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './page/HomePage.dart';

void main() {
  runApp(const ProviderScope(child: TrenDiverseApp()));
}

class TrenDiverseApp extends HookConsumerWidget {
  const TrenDiverseApp({Key? key}) : super(key: key);
  static const locale = Locale("ja", "JP");

  // 移動?
  static final StateProvider<Brightness> contentProvider = StateProvider((ref) => Brightness.dark);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'TrenDiverse',
      theme: ThemeData(
        brightness: ref.watch(contentProvider),
        primaryColor: const Color.fromRGBO(90, 82, 131, 1),
        backgroundColor: const Color.fromRGBO(42, 28, 52, 1),
        canvasColor: const Color.fromRGBO(244, 242, 255, 1),
        unselectedWidgetColor: const Color.fromRGBO(139, 130, 159, 1),
      ),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
      home: HomePage(),
    );
  }
}
