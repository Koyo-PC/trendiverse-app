import 'package:flutter/material.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/page/template/SubPage.dart';

import 'Graph.dart';
import '../data/TrendData.dart';
import '../page/TrendPage.dart';

class TrendTile extends StatelessWidget {
  final int _id;
  final Future<TrendData> _data;

  const TrendTile(this._id, this._data, {Key? key}) : super(key: key);

  int getId() {
    return _id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubPage(TrendPage(TrenDiverseAPI().getCachedData(_id))),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder<TrendData>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                children: <Widget>[
                  Graph(data),
                  Text(
                    data.getName(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
