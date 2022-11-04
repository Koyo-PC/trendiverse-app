import 'dart:core';

import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:tuple/tuple.dart';

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
    for (var trendData in dataList) {
      for (int dividedIndex = 0;
          dividedIndex < trendData.getDividedCount();
          dividedIndex++) {
        var dividedData = trendData.getHistoryData(dividedIndex);
        for (var trendSnapshot in dividedData) {
          DateTime thisStart = trendSnapshot.getTime();
          DateTime thisEnd = trendSnapshot.getTime();
          if (start.millisecondsSinceEpoch == 0 || thisStart.isBefore(start)) {
            start = thisStart;
          }
          if (end.millisecondsSinceEpoch == 0 || thisEnd.isAfter(end)) {
            end = thisEnd;
          }
        }
      }
    }
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
    //     item1: int // count 平均算出のため データの個数
    //     item2: int // sum hotnessの合計
    //     item3: TrendSource // source twitter/ai
    //   }
    // ]
    List<Tuple3<int, int, TrendSource>> mergedData = List.filled(
      length.inMinutes ~/ delta.inMinutes + 2,
      const Tuple3(0, 0, TrendSource.twitter),
      growable: true,
    );

    // 代入
    for (var trendData in dataList) {
      for (int dividedIndex = 0;
          dividedIndex < trendData.getDividedCount();
          dividedIndex++) {
        List<TrendSnapshot> dividedData =
            trendData.getHistoryData(dividedIndex);
        for (var trendSnapshot in dividedData) {
          Tuple3<int, int, TrendSource> originalData =
              mergedData[dateToIndex(trendSnapshot.getTime())];
          Tuple3<int, int, TrendSource> updatedData = Tuple3(
              originalData.item1 + 1,
              originalData.item2 + trendSnapshot.getHotness(),
              trendSnapshot.getSource());
          mergedData[dateToIndex(trendSnapshot.getTime())] = updatedData;
        }
      }
    }

    // divide
    List<List<TrendSnapshot>> dividedData = [[]];
    for (int mergedDataIndex = 0;
        mergedDataIndex < mergedData.length;
        mergedDataIndex++) {
      var dataFrame = mergedData[mergedDataIndex];
      // count = 0 なら null追加 + 次のリストへ
      if (dataFrame.item1 == 0) {
        // 2回以上連続して0の場合
        if (dividedData.last.isEmpty) continue;
        dividedData.last.add(TrendSnapshot(
          indexToDate(mergedDataIndex),
          0,
          TrendSource.twitter,
        ));
        dividedData.add([]);
      } else {
        dividedData.last.add(TrendSnapshot(
          indexToDate(mergedDataIndex),
          dataFrame.item2 ~/ dataFrame.item1,
          dataFrame.item3,
          // 平均
        ));
      }

      // グラフを繋げる(issue #19)
      if (dividedData.last.length >= 2 &&
          (dividedData.last
                      .elementAt(dividedData.last.length - 2)
                      .getSource() ==
                  TrendSource.twitter &&
              dividedData.last.last.getSource() == TrendSource.ai)) {
        dividedData.last.add(TrendSnapshot(dividedData.last.last.getTime(),
            dividedData.last.last.getHotness(), TrendSource.twitter));
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
