import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed/indexed.dart';
import 'package:trendiverse/data/StockedTrend.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';

import '../data/TrendData.dart';

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
    data["aaa"] = StockedTrend(TrendData(100, "aaa", []));
    data["bbb"] = StockedTrend(TrendData(200, "bbb", []));
  }

  void moveTrend(String name, Offset delta) {
    if (!data.containsKey(name)) return;
    var movedTrend = data[name]!;
    movedTrend.position.x += delta.dx;
    movedTrend.position.y += delta.dy;
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
            if (details.localPosition.distance < 10) return;
            stockedTrendsNotifier.moveTrend(
                stockedTrend.getData().getName(), details.delta);
          },
          onPanStart: (details) {
            indexNotifier.state = topIndex++;
            // TODO: 前に出してくる
          },
          child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: Text(stockedTrend.getData().getName() + index.toString())),
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
    // TODO DB?
    ref.watch(rebuilder);
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
