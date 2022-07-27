import 'dart:core';

import '../data/TrendSnapshot.dart';

class TrendData {
  final String _name;

  TrendData(this._name);

  List<TrendSnapshot> _historyData = [];

  String getName() {
    return _name;
  }
  List<TrendSnapshot> getHistoryData() {
    return _historyData;
  }
  TrendData addHistoryData(TrendSnapshot snapshot) {
    _historyData.add(snapshot);
    return this;
  }
}