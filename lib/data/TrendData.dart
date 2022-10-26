import 'dart:core';

import '../data/TrendSnapshot.dart';

class TrendData {
  final int _id;
  final String _name;
  final List<TrendSnapshot> _historyData;
  late final int? _sourceId;

  TrendData(this._id, this._name, this._historyData, {int? sourceId}) {
    _sourceId = sourceId;
  }

  int getId() {
    return _id;
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

  int? getSourceId() {
    return _sourceId != _id ? _sourceId : null;
  }
}
