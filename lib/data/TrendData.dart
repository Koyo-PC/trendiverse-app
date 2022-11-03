import 'dart:core';

import '../data/TrendSnapshot.dart';
import 'TrendSource.dart';

class TrendData {
  final int _id;
  final String _name;
  final List<List<TrendSnapshot>> _historyData;
  late final int? _sourceId;

  TrendData(this._id, this._name, this._historyData, {int? sourceId}) {
    _sourceId = sourceId;
  }

  factory TrendData.merged(List<TrendData> dataList) {
    final id = dataList[0].getId();
    final name = dataList[0].getName();
    final Map<DateTime, MapEntry<int, TrendSource>> historyData = {};
    for (var singleData in dataList) {
      for (int dividedIndex = 0;
          dividedIndex < singleData.getDividedCount();
          dividedIndex++) {
        singleData.getHistoryData(dividedIndex).forEach((snapshot) {
          if (historyData.containsKey(snapshot.getTime())) {
            if (singleData
                    .getHistoryData(dividedIndex)
                    .lastWhere(
                        (element) => element.getSource() == TrendSource.twitter)
                    .getTime() ==
                snapshot.getTime()) return; // TODO 意味がわからん #24
            historyData[snapshot.getTime()] = MapEntry(
                (historyData[snapshot.getTime()]!.key + snapshot.getHotness()),
                historyData[snapshot.getTime()]!.value);
          } else {
            historyData[snapshot.getTime()] =
                MapEntry(snapshot.getHotness(), snapshot.getSource());
          }
        });
      }
    }
    final List<List<TrendSnapshot>> result = [];
    for (int historyIndex = 0;
        historyIndex < historyData.length;
        historyIndex++) {
      final MapEntry<DateTime, MapEntry<int, TrendSource>> data =
          historyData.entries.elementAt(historyIndex);
      if (result.isEmpty) {
        result.add([TrendSnapshot(data.key, data.value.key, data.value.value)]);
      } else {
        final List<TrendSnapshot> lastData = result[result.length - 1];
        final lastSnapshot = lastData[lastData.length - 1];
        print(data.key.difference(lastSnapshot.getTime()).inMinutes);
        // 1.1 * Day
        if (data.key
                .difference(lastSnapshot.getTime())
                .compareTo(const Duration(days: 1, hours: 2, minutes: 24)) <
            0) {
          // 普通
          result[result.length - 1]
              .add(TrendSnapshot(data.key, data.value.key, data.value.value));
        } else {
          // 間が空いている
          result[result.length - 1]
              .add(TrendSnapshot(data.key, 0, data.value.value));
          result
              .add([TrendSnapshot(data.key, data.value.key, data.value.value)]);
        }
      }
    }

    return TrendData(id, name, result);
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
            _historyData[index].indexOf(element) ==
                _historyData[index].length - 1)
        .toList();
  }

  int getDividedCount() {
    return _historyData.length;
  }

  void clearHistoryData() {
    _historyData.clear();
    return;
  }

  int? getSourceId() {
    return _sourceId != _id ? _sourceId : null;
  }
}
