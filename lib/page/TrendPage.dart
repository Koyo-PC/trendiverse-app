import 'package:flutter/material.dart';

import '../TrendLibrary.dart';
import '../data/TrendData.dart';
import '../widgets/Tag.dart';
import '../widgets/Graph.dart';
import '../widgets/TrendTile.dart';

class TrendPage extends StatelessWidget {
  final TrendData _data;

  const TrendPage(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("トレンド詳細"),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Graph(_data, height: 300),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data.getName(),
                    style: TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "カテゴリ : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                          // TODO 仮
                          Row(
                            children: [
                              Tag(
                                _data.getCategory() ?? "未分類",
                                const Color.fromRGBO(128, 128, 128, 1),
                                Colors.white,
                                30,
                                margin: const EdgeInsets.all(5),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Text(
                            "ソース : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                          // TODO 仮
                          Row(
                            children: _data.getTags(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "関連トレンド",
                    style: TextStyle(
                      height: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(5.0),
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    children: _data.getRelated().map((name) => TrendTile(TrendLibrary().getTrendData(name))).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
