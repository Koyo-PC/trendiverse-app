import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/page/TrendManagePage.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:trendiverse/widgets/TrendTile.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppColor.dart';
import '../LocalStrage.dart';
import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../widgets/Graph.dart';
import 'template/SubPage.dart';

class TrendPage extends SubPageContent {
  final List<List<int>> _ids;
  late final StateProvider<GraphMode> graphModeProvider;
  late final StateProvider<bool> logarithmProvider;

  final bool compare;

  TrendPage(this._ids, {graphMode = GraphMode.absolute, this.compare = false}) {
    graphModeProvider = StateProvider((ref) => graphMode);
    logarithmProvider = StateProvider((ref) => false);
  }

  @override
  String getTitle() {
    return !compare ? "トレンド詳細" : "トレンド詳細 - 比較";
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
                legendVisible: true,
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
                      _ids.map((id) => TrenDiverseAPI().getName(id[0]))),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Text(
                        data.join("\n"),
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: !compare ? 40 : 30,
                          color: AppColor.white,
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                Row(
                  children: [
                    // Stock
                    if (_ids.length == 1)
                      Consumer(
                        builder: (context, ref, child) {
                          var stockedTrends =
                              ref.watch(LocalStrage.stockedProvider).data;
                          return ElevatedButton(
                            onPressed: () {
                              LocalStrage().toggleStockedTrend(ref, _ids[0][0]);
                            },
                            child: stockedTrends.keys.contains(_ids[0][0])
                                ? const Icon(Icons.bookmark_added)
                                : const Icon(Icons.bookmark_add_outlined),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: AppColor.main,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    // Compare
                    if (!compare)
                      ElevatedButton(
                        child: const Text("他のトレンドと比較"),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: "/trendManage"),
                              builder: (context) =>
                                  SubPage(TrendManagePage(_ids)),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final mode = ref.watch(graphModeProvider);
                            return ElevatedButton(
                              child: !compare
                                  ? const Text("経過時間で表示")
                                  : const Text("発生日時を揃える"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => mode == GraphMode.absolute
                                        ? Colors.white24
                                        : Colors.blue),
                              ),
                              onPressed: () {
                                ref.read(graphModeProvider.notifier).state =
                                    mode == GraphMode.relative
                                        ? GraphMode.absolute
                                        : GraphMode.relative;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final log = ref.watch(logarithmProvider);
                            return ElevatedButton(
                              child: const Text("対数切り替え"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        !log ? Colors.white24 : Colors.blue),
                              ),
                              onPressed: () {
                                ref.read(logarithmProvider.notifier).state =
                                    log ? false : true;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (_ids.length == 1)
                  FutureBuilder<TrendData>(
                    future: TrenDiverseAPI().getData(_ids[0][0]),
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
                      future: TrenDiverseAPI().getPopular(_ids[0][0]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return Column(
                            children: data
                                .map((id) => Container(
                                      height: 500,
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 0),
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
