import 'dart:core';

import 'TrendData.dart';
import 'Position.dart';


class StockedTrend {
  final TrendData _data;
  Position position = Position(0, 0, 0);

  StockedTrend(this._data);

  TrendData getData() {
    return _data;
  }
}
