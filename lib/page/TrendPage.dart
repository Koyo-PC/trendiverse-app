import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/TrendData.dart';
import '../widgets/Graph.dart';

class TrendPage extends SubPageContent {
  final Future<TrendData> _data;

  TrendPage(this._data);

  @override
  String getTitle() {
    return "トレンド詳細";
  }

  @override
  Widget build(BuildContext context) {
    String tweetContent = r"""
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Here’s an edit I did of one of my drawings. I tend to draw a lot of aot stuff when each chapter is released. Sorry about that!<br>Song: polnalyubvi кометы<br>Character: Annie Leonhart <a href="https://twitter.com/hashtag/annieleonhart?src=hash&amp;ref_src=twsrc%5Etfw">#annieleonhart</a> <a href="https://twitter.com/hashtag/aot131spoilers?src=hash&amp;ref_src=twsrc%5Etfw">#aot131spoilers</a> <a href="https://twitter.com/hashtag/aot?src=hash&amp;ref_src=twsrc%5Etfw">#aot</a> <a href="https://twitter.com/hashtag/AttackOnTitan131?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitan131</a> <a href="https://twitter.com/hashtag/AttackOnTitans?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitans</a> <a href="https://twitter.com/hashtag/snk?src=hash&amp;ref_src=twsrc%5Etfw">#snk</a> <a href="https://twitter.com/hashtag/snk131?src=hash&amp;ref_src=twsrc%5Etfw">#snk131</a> <a href="https://twitter.com/hashtag/shingekinokyojin?src=hash&amp;ref_src=twsrc%5Etfw">#shingekinokyojin</a> <a href="https://t.co/b4z48ruCoD">pic.twitter.com/b4z48ruCoD</a></p>&mdash; evie (@hazbin_freak22) <a href="https://twitter.com/hazbin_freak22/status/1291884358870142976?ref_src=twsrc%5Etfw">August 7, 2020</a></blockquote> """;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: FutureBuilder<TrendData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Graph(data, height: 300),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.getName(),
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      SizedBox(
                        height: 600,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 600,
                            child: WebView(
                              initialUrl: "https://twitter.com/search?q=${Uri.encodeFull(data.getName()).replaceAll("#", "%23")}",
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
                            ),
                          ),
                        ),
                      ),

                      // Table(
                      //   columnWidths: const {
                      //     0: IntrinsicColumnWidth(),
                      //     1: IntrinsicColumnWidth(),
                      //   },
                      //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      //   children: [
                      //     TableRow(
                      //       children: [
                      //         Text(
                      //           "カテゴリ : ",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 20,
                      //             color: Theme.of(context).canvasColor,
                      //           ),
                      //         ),
                      //         // TODO 仮
                      //         Row(
                      //           children: [
                      //             Tag(
                      //               data.getCategory() ?? "未分類",
                      //               const Color.fromRGBO(128, 128, 128, 1),
                      //               Colors.white,
                      //               30,
                      //               margin: const EdgeInsets.all(5),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //     TableRow(
                      //       children: <Widget>[
                      //         Text(
                      //           "ソース : ",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 20,
                      //             color: Theme.of(context).canvasColor,
                      //           ),
                      //         ),
                      //         // TODO 仮
                      //         Row(
                      //           children: data.getTags(),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // Text(
                      //   "関連トレンド",
                      //   style: TextStyle(
                      //     height: 3,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 25,
                      //     color: Theme.of(context).canvasColor,
                      //   ),
                      // ),
                      // GridView.count(
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   padding: const EdgeInsets.all(5.0),
                      //   scrollDirection: Axis.vertical,
                      //   crossAxisCount: 2,
                      //   children: data
                      //       .getRelated()
                      //       .map((id) =>
                      //       TrendTile(TrendLibrary().getTrendData(id)))
                      //       .toList(),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}\n${snapshot.stackTrace}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
