import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/LocalStrage.dart';
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
    return InteractiveViewer(
      constrained: true,
      minScale: 1.0,
      maxScale: 5.0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: const _StockPageContent(),
      ),
    );
  }
}

class _StockPageTile extends ConsumerWidget {
  int id;

  _StockPageTile(this.id);

  // Indexで前後関係を補正しようとしたがうまく動かず現状スパゲッティになってる
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockedTrends = ref.watch(LocalStrage.stockedProvider);
    final stockedTrendsNotifier = ref.read(LocalStrage.stockedProvider.notifier);
    if(!stockedTrends.data.containsKey(id)) return const Text(""); // hide (NOT GOOD...)
    return Positioned(
      left: stockedTrends.data[id]!.position.x,
      top: stockedTrends.data[id]!.position.y,
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onPanUpdate: (details) {
          stockedTrendsNotifier.moveTrend(id, details.delta);
        },
        onPanStart: (details) {
          // stockedTrends.updateTrends();
          // TODO: 前に出してくる
        },
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubPage(TrendPage(id)),
            ),
          );
        },
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: stockedTrends.data[id]!.getName(),
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
    );
  }
}

class _StockPageContent extends ConsumerWidget {
  const _StockPageContent({Key? key}) : super(key: key);

  static final rebuilder = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rebuilder);
    // ref.read(LocalStrage.stockedProvider).updateTrends();
    return Stack(
        fit: StackFit.expand,
        children: ref
            .watch(LocalStrage.stockedProvider)
            .data
            .values
            .map((todo) => _StockPageTile(todo.getId()))
            .toList());
  }
}
