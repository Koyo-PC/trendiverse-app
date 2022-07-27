import 'package:flutter/material.dart';
import 'Graph.dart';
import '../data/TrendData.dart';

class TrendTile extends StatelessWidget {
  final TrendData _data;

  TrendTile(this._data) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 200,
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
    );
  }
}
