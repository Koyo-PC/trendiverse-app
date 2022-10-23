import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LocalStrage.dart';
import '../data/TrendData.dart';
import '../widgets/Graph.dart';

class TrendPage extends SubPageContent {
  final TrendData? _data;

  TrendPage(this._data);

  @override
  String getTitle() {
    return "トレンド詳細";
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) return const Text("ERROR");
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Graph(_data!, height: 300),
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _data!.getName(),
                  style: TextStyle(
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    var stockedTrends = ref.watch(LocalStrage.stockedProvider).data;
                    return FloatingActionButton(
                      onPressed: () {
                        LocalStrage().toggleStockedTrend(ref, _data!.getId().toString());
                      },
                      child: stockedTrends
                          .keys
                          .contains(_data?.getId().toString())
                          ? const Icon(Icons.bookmark_added)
                          : const Icon(Icons.bookmark_add_outlined),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    );
                  },
                ),
                SizedBox(
                  height: 600,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 600,
                      child: WebView(
                        initialUrl:
                            "https://twitter.com/search?q=${Uri.encodeFull(_data!.getName()).replaceAll("#", "%23")}",
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: {
                          Factory(() => EagerGestureRecognizer())
                        },
                      ),
                    ),
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
