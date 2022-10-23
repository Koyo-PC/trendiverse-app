import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed/indexed.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/data/StockedTrend.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:trendiverse/widgets/TrendTile.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/TrendData.dart';
import '../widgets/Graph.dart';

class StockPage extends SubPageContent {
  StockPage() {}

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
        // padding: EdgeInsets.all(50),
        child: _StockPageContent(),
      ),
    );
  }
}

class _StockedListNotifier extends ChangeNotifier {
  LinkedHashMap<String, StackedTrend> data = LinkedHashMap();

  _StockedListNotifier() {
    data["aaa"] = StackedTrend(TrendData(100, "aaa", []));
    data["bbb"] = StackedTrend(TrendData(200, "bbb", []));
  }

  void moveTrend(String name, Offset delta) {
    if (!data.containsKey(name)) return;
    var movedTrend = data[name]!;
    // data.remove(name);

    movedTrend.position.x += delta.dx;
    movedTrend.position.y += delta.dy;
    // movedTrend.position.z =
    //     data.values.map((e) => e.position.z).toList().reduce(max) + 1.0;

    // data[name] = movedTrend;
    print(data);

    // data = SplayTreeMap.of(data, (a, b) {
    //   print("a: $a, b: $b");
    //   print("az: ${data[a]!.position.z}, bz: ${data[b]!.position.z}");
    //   int compare = data[a]!.position.z.compareTo(data[b]!.position.z);
    //   return compare == 0 ? 1 : compare;
    // });

    notifyListeners();
  }

  void moveTrendTo(String name, Offset pos) {
    if (!data.containsKey(name)) return;
    var movedTrend = data[name]!;
    data.remove(name);

    movedTrend.position.x = pos.dx;
    movedTrend.position.y = pos.dy;
    // movedTrend.position.z =
    //     data.values.map((e) => e.position.z).toList().reduce(max) + 1.0;

    data[name] = movedTrend;
    // print(data);

    notifyListeners();
  }
}

class _StockPageTile extends ConsumerWidget implements IndexedInterface {
  static int topIndex = 0;

  static final stockedProvider =
      ChangeNotifierProvider((ref) => _StockedListNotifier());

  late StateProvider indexProvider;
  int _indexcache = 0;
  StackedTrend todo;

  _StockPageTile(this.todo) {
    var defaultIndex = ++topIndex;
    indexProvider = StateProvider((ref) => defaultIndex);
    // return Text(index.toString());
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
        left: todo.position.x,
        top: todo.position.y,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          dragStartBehavior: DragStartBehavior.down,
          onPanUpdate: (details) {
            // print(details.primaryDelta);
            if (details.localPosition.distance < 10) return;
            // print(todo.getData().getName());
            stockedTrendsNotifier.moveTrend(
                todo.getData().getName(), details.delta);
            // stockedTrendsNotifier.moveTrendTo(
            //     todo.getData().getName(), details.localPosition);
          },
          onPanStart: (details) {
            indexNotifier.state = topIndex++;
            // ref.read(_StockPageContent.rebuilder.state).update((state) => topIndex);
            // TODO: 前に出してくる
          },
          //   onLongPressMoveUpdate: (details) {
          //     print(todo.getData().getName());
          //     stockedTrendsNotifier.moveTrendTo(
          //         todo.getData().getName(), details.globalPosition);
          //   },
          child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: Text(todo.getData().getName() + index.toString())),
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
          .map(
            (todo) => _StockPageTile(todo) as Widget,
          )
          .toList()
        // ..add(
        //   const Indexed(
        //     child: Positioned(
        //       child: SizedBox(
        //         width: 500,
        //         height: 500,
        //       ),
        //     ),
        //   ),
        // ),
    );
  }
}
