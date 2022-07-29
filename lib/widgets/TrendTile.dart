import 'package:flutter/material.dart';
import 'package:trendiverse/page/template/SubPage.dart';

import 'Graph.dart';
import '../data/TrendData.dart';
import '../page/TrendPage.dart';

class TrendTile extends StatelessWidget {
  final TrendData _data;

  const TrendTile(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubPage(TrendPage(_data)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Graph(_data),
            Text(
              _data.getName(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
