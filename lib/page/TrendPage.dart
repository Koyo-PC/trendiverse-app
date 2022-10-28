import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:trendiverse/widgets/TrendTile.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LocalStrage.dart';
import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../widgets/Graph.dart';

class TrendPage extends SubPageContent {
  final int _id;

  TrendPage(this._id);

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
          Graph(_id, height: 300),
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<String>(
                  future: TrenDiverseAPI().getName(_id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Text(
                        data,
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
                Consumer(
                  builder: (context, ref, child) {
                    var stockedTrends =
                        ref.watch(LocalStrage.stockedProvider).data;
                    return ElevatedButton(
                      onPressed: () {
                        LocalStrage().toggleStockedTrend(ref, _id);
                      },
                      child: stockedTrends.keys.contains(_id)
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
                FutureBuilder<TrendData>(
                  future: TrenDiverseAPI().getData(_id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return TrendTile(data.getSourceId() ?? 0);
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                SizedBox(
                  height: 600,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 600,
                      child:FutureBuilder<String>(
                        future: TrenDiverseAPI().getName(_id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return WebView(
                              initialUrl:
                              "https://twitter.com/search?q=${Uri.encodeFull(data).replaceAll("#", "%23")}",
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureRecognizers: {
                                Factory(() => EagerGestureRecognizer())
                              },
                            );
                          }
                          return const CircularProgressIndicator();
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
