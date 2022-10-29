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

  List<TrendSnapshot> getHistoryData({dataCount = -1}) {
    if (dataCount < 1) return _historyData;
    return _historyData
        .where((element) =>
            _historyData.indexOf(element) == 0 ||
            _historyData.indexOf(element) %
                    ((_historyData.length / dataCount).ceil()) ==
                0 ||
            _historyData.indexOf(element) == _historyData.length - 1)
        .toList();
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
