import 'dart:core';

import '../data/TrendSnapshot.dart';

class TrendData {
  final int _id;
  final String _name;
  final List<List<TrendSnapshot>> _historyData;
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

  List<TrendSnapshot> getHistoryData(int index, {dataCount = -1}) {
    if (dataCount < 1) return _historyData[index];
    return _historyData[index]
        .where((element) =>
            _historyData[index].indexOf(element) == 0 ||
            _historyData[index].indexOf(element) %
                    ((_historyData[index].length / dataCount).ceil()) ==
                0 ||
            _historyData[index].indexOf(element) == _historyData[index].length - 1)
        .toList();
  }

  void clearHistoryData() {
    _historyData.clear();
    return;
  }

  int? getSourceId() {
    return _sourceId != _id ? _sourceId : null;
  }
}
