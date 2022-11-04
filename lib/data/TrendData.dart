import 'dart:core';

import 'package:trendiverse/TrenDiverseAPI.dart';

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

  static Future<TrendData> merged(List<int> idList) async {
    List<TrendData> dataList = [];
    for (var id in idList) {
      dataList.add(await TrenDiverseAPI().getData(id));
    }

    // 合成トレンドの開始/終了を求める
    DateTime start = DateTime.fromMillisecondsSinceEpoch(0);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(0);
    dataList.forEach((trendData) {
      for (int dividedIndex = 0;
          dividedIndex < trendData.getDividedCount();
          dividedIndex++) {
        var dividedData = trendData.getHistoryData(dividedIndex);
        dividedData.forEach((trendSnapshot) {
          DateTime thisStart = trendSnapshot.getTime();
          DateTime thisEnd = trendSnapshot.getTime();
          if (start.millisecondsSinceEpoch == 0 || thisStart.isBefore(start))
            start = thisStart;
          print("thisEnd = " + thisEnd.toString());
          print("end.millisecondsSinceEpoch = " +
              (end.millisecondsSinceEpoch).toString());
          if (end.millisecondsSinceEpoch == 0 || thisEnd.isAfter(end))
            end = thisEnd;
          print("end.millisecondsSinceEpoch = " +
              (end.millisecondsSinceEpoch).toString());
        });
      }
    });
    print("End: " + end.toString());
    Duration length = end.difference(start);
    Duration delta = const Duration(minutes: 5);

    DateTime indexToDate(int index) {
      return start.add(Duration(minutes: delta.inMinutes * index));
    }

    int dateToIndex(DateTime date) {
      return date.difference(start).inMinutes ~/ delta.inMinutes;
    }

    // 作業用データ
    // [
    //   {
    //     key: int // count 平均算出のため データの個数
    //     value: int // sum hotnessの合計
    //   }
    // ]
    List<MapEntry<int, int>> mergedData = List.filled(
      length.inMinutes ~/ delta.inMinutes + 2,
      const MapEntry(0, 0),
      growable: true,
    );

    // 代入
    dataList.forEach((trendData) {
      for (int dividedIndex = 0;
          dividedIndex < trendData.getDividedCount();
          dividedIndex++) {
        List<TrendSnapshot> dividedData =
            trendData.getHistoryData(dividedIndex);
        dividedData.forEach((trendSnapshot) {
          print(dateToIndex(trendSnapshot.getTime()));
          print("end = " + end.toString());
          print("trendSnapshot.getTime() = " +
              trendSnapshot.getTime().toString());
          MapEntry<int, int> originalData =
              mergedData[dateToIndex(trendSnapshot.getTime())];
          MapEntry<int, int> updatedData = MapEntry(originalData.key + 1,
              originalData.value + trendSnapshot.getHotness());
          mergedData[dateToIndex(trendSnapshot.getTime())] = updatedData;
        });
      }
    });

    // divide
    List<List<TrendSnapshot>> dividedData = [[]];
    for (int mergedDataIndex = 0;
        mergedDataIndex < mergedData.length;
        mergedDataIndex++) {
      var dataFrame = mergedData[mergedDataIndex];
      // count = 0 なら null追加 + 次のリストへ
      if (dataFrame.key == 0) {
        // 2回以上連続して0の場合
        if (dividedData.last.isEmpty) continue;
        dividedData.last.add(TrendSnapshot(
          indexToDate(mergedDataIndex),
          0,
          TrendSource.twitter,
        ));
        // TODO ↑ trendSourceあとで考える
        dividedData.add([]);
      } else {
        dividedData.last.add(TrendSnapshot(
          indexToDate(mergedDataIndex),
          dataFrame.value ~/ dataFrame.key,
          TrendSource.twitter,
          // 平均
        ));
      }
    }

    return TrendData(
        dataList.first.getId(), dataList.first.getName(), dividedData);

    // TODO
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
