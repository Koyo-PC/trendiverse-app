import 'dart:core';

import 'TrendData.dart';
import 'Position.dart';


class StackedTrend {
  final TrendData _data;
  Position position = Position(0, 0, 0);

  StackedTrend(this._data);

  TrendData getData() {
    return _data;
  }
}
