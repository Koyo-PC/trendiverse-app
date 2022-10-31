import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:trendiverse/widgets/TrendSearch.dart';
import 'package:trendiverse/widgets/TrendTile.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LocalStrage.dart';
import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../widgets/Graph.dart';
import 'template/SubPage.dart';

class TrendPage extends SubPageContent {
  final List<int> _ids;
  late final StateProvider<GraphMode> graphModeProvider;
  late final StateProvider<bool> logarithmProvider;

  TrendPage(this._ids, {graphMode = GraphMode.absolute}) {
    graphModeProvider = StateProvider((ref) => graphMode);
    logarithmProvider = StateProvider((ref) => false);
  }

  @override
  String getTitle() {
    return "トレンド詳細";
  }

  @override
  Widget build(BuildContext context) {
    // if (_data == null) _data = TrenDiverseAPI().getData(_id);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return Graph(
                _ids,
                height: 300,
                enableAction: true,
                mode: ref.watch(graphModeProvider),
                logarithm: ref.watch(logarithmProvider),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<List<String>>(
                  future: Future.wait(
                      _ids.map((id) => TrenDiverseAPI().getName(id))),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Text(
                        data.join(", "),
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Theme.of(context).canvasColor,
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                if (_ids.length == 1)
                  Consumer(
                    builder: (context, ref, child) {
                      var stockedTrends =
                          ref.watch(LocalStrage.stockedProvider).data;
                      return ElevatedButton(
                        onPressed: () {
                          LocalStrage().toggleStockedTrend(ref, _ids[0]);
                        },
                        child: stockedTrends.keys.contains(_ids[0])
                            ? const Icon(Icons.bookmark_added)
                            : const Icon(Icons.bookmark_add_outlined),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ElevatedButton(
                  child: const Text("他のトレンドと比較"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            TrendSearch(
                              (suggestion) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SubPage(
                                      TrendPage(_ids + [suggestion['id']],
                                          graphMode: GraphMode.relative),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              height: 500,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      child: const Text("グラフ表示(絶対/相対)切り替え"),
                      onPressed: () {
                        final state = ref.read(graphModeProvider);
                        ref.read(graphModeProvider.notifier).state =
                            state == GraphMode.relative
                                ? GraphMode.absolute
                                : GraphMode.relative;
                      },
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      child: const Text("対数切り替え"),
                      onPressed: () {
                        final state = ref.read(logarithmProvider);
                        ref.read(logarithmProvider.notifier).state =
                            state ? false : true;
                      },
                    );
                  },
                ),
                if (_ids.length == 1)
                  FutureBuilder<TrendData>(
                    future: TrenDiverseAPI().getData(_ids[0]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return TrendTile(data.getSourceId() ?? 0);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                // TODO ↓ 後で有効化...?
                if (_ids.length == 1)
                  SingleChildScrollView(
                    child: FutureBuilder<List<String>>(
                      future: TrenDiverseAPI().getPopular(_ids[0]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return Column(
                            children: data
                                .map((id) => Container(
                                      height: 500,
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      margin: const EdgeInsets.fromLTRB(
                                          50, 10, 50, 0),
                                      child: WebView(
                                        initialUrl:
                                            "https://twitter.com/i/web/status/$id",
                                        javascriptMode:
                                            JavascriptMode.unrestricted,
                                        gestureRecognizers: {
                                          Factory(
                                              () => EagerGestureRecognizer())
                                        },
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
