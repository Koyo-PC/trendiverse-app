import 'package:flutter/material.dart';
import 'package:trendiverse/page/template/SubPageContent.dart';

import '../TrendLibrary.dart';
import '../data/TrendData.dart';
import '../widgets/Tag.dart';
import '../widgets/Graph.dart';
import '../widgets/TrendTile.dart';

class TrendPage extends SubPageContent {
  final Future<TrendData> _data;

  TrendPage(this._data);

  @override
  String getTitle() {
    return "トレンド詳細";
  }

  @override
  Widget build(BuildContext context) {
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
