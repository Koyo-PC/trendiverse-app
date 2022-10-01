import 'dart:core';

import '../data/TrendSnapshot.dart';

class TrendData {
  final int _id;
  final String _name;
  final List<TrendSnapshot> _historyData;

  TrendData(this._id, this._name, this._historyData);


  String getId() {
    return _name;
  }

  String getName() {
    return _name;
  }

  List<TrendSnapshot> getHistoryData() {
    return _historyData;
  }

  void clearHistoryData() {
    _historyData.clear();
    return;
  }

  void addHistoryData(TrendSnapshot snapshot) {
    _historyData.add(snapshot);
    return;
  }
}
