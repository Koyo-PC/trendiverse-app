import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LocalStrage.dart';
import '../data/Position.dart';
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
    String tweetContent = r"""
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Here’s an edit I did of one of my drawings. I tend to draw a lot of aot stuff when each chapter is released. Sorry about that!<br>Song: polnalyubvi кометы<br>Character: Annie Leonhart <a href="https://twitter.com/hashtag/annieleonhart?src=hash&amp;ref_src=twsrc%5Etfw">#annieleonhart</a> <a href="https://twitter.com/hashtag/aot131spoilers?src=hash&amp;ref_src=twsrc%5Etfw">#aot131spoilers</a> <a href="https://twitter.com/hashtag/aot?src=hash&amp;ref_src=twsrc%5Etfw">#aot</a> <a href="https://twitter.com/hashtag/AttackOnTitan131?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitan131</a> <a href="https://twitter.com/hashtag/AttackOnTitans?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitans</a> <a href="https://twitter.com/hashtag/snk?src=hash&amp;ref_src=twsrc%5Etfw">#snk</a> <a href="https://twitter.com/hashtag/snk131?src=hash&amp;ref_src=twsrc%5Etfw">#snk131</a> <a href="https://twitter.com/hashtag/shingekinokyojin?src=hash&amp;ref_src=twsrc%5Etfw">#shingekinokyojin</a> <a href="https://t.co/b4z48ruCoD">pic.twitter.com/b4z48ruCoD</a></p>&mdash; evie (@hazbin_freak22) <a href="https://twitter.com/hazbin_freak22/status/1291884358870142976?ref_src=twsrc%5Etfw">August 7, 2020</a></blockquote> """;

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
                FloatingActionButton(
                  onPressed: () {
                    if (!LocalStrage().prefs!.containsKey("trends_stocked")) {
                      LocalStrage()
                          .prefs!
                          .setString("trends_stocked", jsonEncode({}));
                    }
                    Map<String, dynamic> stockedData =
                        Map<String, dynamic>.from(json.decode(
                            LocalStrage().prefs!.getString("trends_stocked")!));
                    if (stockedData.containsKey(_data!.getId().toString())) {
                      stockedData.remove(_data!.getId().toString());
                    } else {
                      stockedData[_data!.getId().toString()] = Position(0, 0);
                    }
                    LocalStrage()
                        .prefs!
                        .setString("trends_stocked", jsonEncode(stockedData));
                  },
                  child: Map<String, dynamic>.from(jsonDecode(LocalStrage()
                              .prefs!
                              .getString("trends_stocked")!))
                          .keys
                          .contains(_data?.getId().toString())
                      ? const Icon(Icons.bookmark_added)
                      : const Icon(Icons.bookmark_add_outlined),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
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
