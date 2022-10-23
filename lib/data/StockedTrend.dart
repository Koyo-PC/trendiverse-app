import 'dart:core';

import 'package:trendiverse/TrenDiverseAPI.dart';

import 'TrendData.dart';
import 'Position.dart';


class StockedTrend {
  final String _id;
  String? _name;
  TrendData? _data;
  Position position = Position(0, 0);

  StockedTrend(this._id);

  String getId() {
    return _id;
  }

  Future<TrendData> getData() async {
    if(_data != null) return _data!;
    _data = await TrenDiverseAPI().getData(int.parse(_id));
    return _data!;
  }

  Future<String> getName() async {
    if(_name != null) return _name!;
    _name = await TrenDiverseAPI().getName(int.parse(_id));
    return _name!;
  }

  String toString() {
    return "{ id: $_id, name: $_name, data: $_data, position: $position }";
  }
}
