import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed/indexed.dart';
import 'package:trendiverse/LocalStrage.dart';
import 'package:trendiverse/data/Position.dart';
import 'package:trendiverse/data/StockedTrend.dart';
import 'package:trendiverse/page/template/SubPage.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';

import 'TrendPage.dart';

class StockPage extends SubPageContent {
  @override
  String getTitle() {
    return "ストック済トレンド";
  }

  @override
  Widget build(BuildContext context) {
    // TODO DB?
    return InteractiveViewer(
      constrained: true,
      minScale: 1.0,
      maxScale: 5.0,
      child: Container(
        color: Colors.blue,
        child: const _StockPageContent(),
      ),
    );
  }
}

class _StockedListNotifier extends ChangeNotifier {
  LinkedHashMap<String, StockedTrend> data = LinkedHashMap();

  _StockedListNotifier() {
    // data["500"] = StockedTrend(500);
    // data["700"] = StockedTrend(700);
    updateTrends();
  }

  void updateTrends() {
    print("a");
    if (!LocalStrage().prefs!.containsKey("trends_stocked")) {
      LocalStrage().prefs!.setString("trends_stocked", jsonEncode({}));
    }
    print("b");

    // print(LocalStrage().prefs!.getString("trends_stocked"));
    Map<String, dynamic> loadedData = Map<String, dynamic>.from(
        jsonDecode(LocalStrage().prefs!.getString("trends_stocked")!));
    data.clear();
    loadedData.forEach((id, pos) {
      data[id] = StockedTrend(int.parse(id))
        ..position = Position.fromJson(Map<String, dynamic>.from(pos));
    });

    print("c");
  }

  void moveTrend(int id, Offset delta) {
    print(data.keys);
    if (!data.containsKey(id.toString())) return;
    print("z");
    var movedTrend = data[id.toString()]!;
    movedTrend.position.x += delta.dx;
    movedTrend.position.y += delta.dy;

    LocalStrage().prefs!.setString("trends_stocked",
        jsonEncode(data.map((key, value) => MapEntry(key, value.position))));

    notifyListeners();
  }
}

class _StockPageTile extends ConsumerWidget implements IndexedInterface {
  static int topIndex = 0;

  static final stockedProvider =
      ChangeNotifierProvider((ref) => _StockedListNotifier());

  late StateProvider indexProvider;
  int _indexcache = 0;
  StockedTrend stockedTrend;

  _StockPageTile(this.stockedTrend) {
    var defaultIndex = ++topIndex;
    indexProvider = StateProvider((ref) => defaultIndex);
  }

  // Indexで前後関係を補正しようとしたがうまく動かず現状スパゲッティになってる
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockedTrends = ref.watch(stockedProvider);
    final stockedTrendsNotifier = ref.read(stockedProvider.notifier);
    final index = ref.watch(indexProvider);
    final indexNotifier = ref.read(indexProvider.notifier);
    _indexcache = index;
    return Indexed(
      index: index,
      child: Positioned(
        left: stockedTrend.position.x,
        top: stockedTrend.position.y,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          dragStartBehavior: DragStartBehavior.down,
          onPanUpdate: (details) {
            stockedTrendsNotifier.moveTrend(
                stockedTrend.getId(), details.delta);
          },
          onPanStart: (details) {
            indexNotifier.state = topIndex++;
            stockedTrends.updateTrends();
            // TODO: 前に出してくる
          },
          onTap: () async {
            var data = await stockedTrend.getData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubPage(TrendPage(data)),
              ),
            );
          },
          child: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: stockedTrend.getName(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else {
                  return const Text("データ受信中");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement index
  int get index => _indexcache;
}

class _StockPageContent extends ConsumerWidget {
  const _StockPageContent({Key? key}) : super(key: key);

  static final rebuilder = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rebuilder);
    ref.read(_StockPageTile.stockedProvider).updateTrends();
    return Indexer(
        fit: StackFit.expand,
        children: ref
            .read(_StockPageTile.stockedProvider)
            .data
            .values
            .map((todo) => _StockPageTile(todo))
            .toList());
  }
}
