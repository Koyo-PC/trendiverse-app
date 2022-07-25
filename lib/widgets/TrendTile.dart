import 'package:flutter/material.dart';
import 'Glaph.dart';
import '../data/TrendData.dart';

class TrendTile extends Card {
  final TrendData _data;

  TrendTile(this._data) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Glaph(_data),
          Text(_data.getName()),
        ],
      ),
    );
  }
}