import 'dart:core';

import 'package:trendiverse/TrenDiverseAPI.dart';

import 'TrendData.dart';
import 'Position.dart';


class StockedTrend {
  final int _id;
  String? _name;
  TrendData? _data;
  Position position = Position(0, 0);

  StockedTrend(this._id);

  int getId() {
    return _id;
  }

  Future<TrendData> getData() async {
    if(_data != null) return _data!;
    _data = await TrenDiverseAPI().getData(_id);
    return _data!;
  }

  Future<String> getName() async {
    if(_name != null) return _name!;
    _name = await TrenDiverseAPI().getName(_id);
    return _name!;
  }

  @override
  String toString() {
    return "{ id: ${getId()}, position: $position }";
  }
}
