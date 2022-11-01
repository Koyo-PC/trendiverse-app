import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trendiverse/data/TrendSource.dart';

import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';

class Graph extends StatelessWidget {
  final List<int> _ids;
  final double height;

  final Color textColor;

  final bool enableAction;
  final GraphMode mode;

  final bool logarithm;

  final bool legendVisible;

  const Graph(this._ids,
      {Key? key,
      this.height = 150,
      this.textColor = Colors.white,
      this.enableAction = false,
      this.mode = GraphMode.absolute,
      this.logarithm = false,
      this.legendVisible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enableAction,
      child: SizedBox(
        height: height,
        child: FutureBuilder<List<TrendData>>(
          future: Future.wait(
            _ids.map((id) => TrenDiverseAPI().getData(id)).toList(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return SfCartesianChart(
                // X軸
                primaryXAxis: /*mode == GraphMode.absolute
                    // 絶対表示(日付)の時
                    ? */DateTimeAxis(
                        labelStyle: TextStyle(
                          color: textColor,
                        ),
                        dateFormat: DateFormat("MM/dd\nHH:mm"),
                      )
                    /*: NumericAxis(
                        labelStyle: TextStyle(
                          color: textColor,
                        ),
                        labelFormat: '{value}日',
                      )*/,
                // Y軸
                primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(
                      color: textColor,
                    ),
                    labelFormat: logarithm ? "10^{value}" : "{value}K"),
                zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: enableAction, zoomMode: ZoomMode.x),
                series: buildAllTrendSeries(data),
                legend: Legend(
                    isVisible: legendVisible, position: LegendPosition.bottom),
                crosshairBehavior: CrosshairBehavior(enable: enableAction),
              );
            }
            return Container(
              padding: const EdgeInsets.all(20),
              height: height,
              width: height,
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<LineSeries<TrendSnapshot, DateTime>> buildTrendSeries(TrendData data) {
    final List<LineSeries> series = [];
    final trendStartTime = data.getHistoryData(0, dataCount: 1)[0].getTime();
    for (int divIndex = 0; divIndex < data.getDividedCount(); divIndex++) {
      final List<TrendSnapshot> twitterDataList = [];
      final List<TrendSnapshot> aiDataList = [];
      var snapshots = data.getHistoryData(divIndex, dataCount: 500);

      for (var snapshot in snapshots) {
        if (snapshot.getSource() == TrendSource.twitter) {
          twitterDataList.add(snapshot);
        } else {
          aiDataList.add(snapshot);
        }
      }
      if (twitterDataList.isNotEmpty && aiDataList.isNotEmpty) {
        twitterDataList.add(TrendSnapshot(aiDataList[0].getTime(),
            aiDataList[0].getHotness(), TrendSource.twitter));
      } else if (twitterDataList.isNotEmpty) {
        final lastTwitterData = twitterDataList[twitterDataList.length - 1];
        twitterDataList.add(TrendSnapshot(
            lastTwitterData.getTime().add(const Duration(minutes: 1)),
            lastTwitterData.getHotness(),
            TrendSource.twitter));
      }else if(aiDataList.isNotEmpty) {
        // TODO Do nothing?
      }
      xValueMapper(TrendSnapshot snapshot, _) {
        if (mode == GraphMode.absolute) {
          return snapshot.getTime();
        } else {
          return DateTime.fromMillisecondsSinceEpoch(snapshot.getTime().difference(trendStartTime).inMilliseconds/*.inSeconds /
              86400.0*/);
        }
      }

      yValueMapper(TrendSnapshot snapshot, _) {
        if (logarithm) {
          return log(snapshot.getHotness()) * log10e;
        } else {
          snapshot.getHotness() / 1000;
        }
      }

      if (twitterDataList.isNotEmpty) {
        series.add(LineSeries<TrendSnapshot, DateTime>(
          legendItemText: data.getName(),
          dataSource: twitterDataList,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          color: const HSLColor.fromAHSL(1, 0, 1, .5).toColor(),
        ));
      }
      if (aiDataList.isNotEmpty) {
        series.add(LineSeries<TrendSnapshot, DateTime>(
          legendItemText: data.getName() + "(予測)",
          dataSource: aiDataList,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          color: const HSLColor.fromAHSL(1, 0, 1, .85).toColor(),
        ));
      }
    }
    print(series.runtimeType);
    return series.cast();
  }

  List<LineSeries> buildAllTrendSeries(List<TrendData> data) {
    List<LineSeries> series = [];
    for (var element in data) {
      buildTrendSeries(element).forEach((element) {
        series.add(element);
      });
    }
    print(series[0].dataSource);
    return series;
  }

// List<LineSeries> buildTrendSeries(List<TrendData> data) {
//   if (mode == GraphMode.absolute) {
//     // 絶対表示(日付)の場合
//     final List<LineSeries> seriesList = [];
//     //
//     final List<LineSeries> twitterDataList = [];
//     final List<LineSeries> aiDataList = [];
//
//
//     // twitter
//     for (var d in data) {
//       for (int dividedIndex = 0; dividedIndex <
//           d.getDividedCount(); dividedIndex++) {
//         seriesList.add(LineSeries<TrendSnapshot, DateTime>(
//           legendItemText: d.getName(),
//           dataSource: d
//               .getHistoryData(0, dataCount: 500) // TODO 仮
//               .where(
//                   (element) => element.getSource() == TrendSource.twitter)
//               .toList(),
//           xValueMapper: (TrendSnapshot snapshot, _) => snapshot.getTime(),
//           yValueMapper: (TrendSnapshot snapshot, _) =>
//           logarithm
//               ? log(snapshot.getHotness()) * log10e
//               : snapshot.getHotness() / 1000,
//           color: const HSLColor.fromAHSL(1, 0, 1, .5).toColor(),
//         ));
//       }
//     }
//     // ai
//     for (var d in data) {
//       seriesList.add(
//         LineSeries<TrendSnapshot, DateTime>(
//           legendItemText: d.getName() + "(予測)",
//           dataSource: d
//               .getHistoryData(0, dataCount: 500) // TODO 仮
//               .where((element) => element.getSource() == TrendSource.ai)
//               .toList(),
//           xValueMapper: (TrendSnapshot snapshot, _) =>
//               snapshot.getTime(),
//           yValueMapper: (TrendSnapshot snapshot, _) =>
//           logarithm
//               ? log(snapshot.getHotness()) * log10e
//               : snapshot.getHotness() / 1000,
//           color: const HSLColor.fromAHSL(1, 0, 1, 0.85).toColor(),
//         ),
//       );
//     }
//     return seriesList;
//   } else {
//     return data.map(
//           (d) {
//         var color = HSLColor.fromAHSL(
//             1, 360 * data.indexOf(d).toDouble() / data.length, 1, .75);
//         return LineSeries<TrendSnapshot, double>(
//           legendItemText: d.getName(),
//           dataSource: d
//               .getHistoryData(0, dataCount: 500) // TODO 仮
//               .where(
//                   (element) => element.getSource() == TrendSource.twitter)
//               .toList(),
//           xValueMapper: (TrendSnapshot snapshot, _) =>
//           snapshot
//               .getTime()
//               .difference(d
//               .getHistoryData(0, dataCount: 1)[0] // TODO 仮
//               .getTime())
//               .inSeconds /
//               86400.0,
//           yValueMapper: (TrendSnapshot snapshot, _) =>
//           logarithm
//               ? log(snapshot.getHotness()) * log10e
//               : snapshot.getHotness() / 1000,
//           color: color.toColor(),
//         );
//       },
//     ).toList()
//       ..addAll(
//         data.map(
//               (d) {
//             var color = HSLColor.fromAHSL(
//                 1, 360 * data.indexOf(d).toDouble() / data.length, 1, .75);
//             return LineSeries<TrendSnapshot, double>(
//               legendItemText: d.getName() + "(予測)",
//               dataSource: d
//                   .getHistoryData(0, dataCount: 500) // TODO 仮
//                   .where((element) => element.getSource() == TrendSource.ai)
//                   .toList(),
//               xValueMapper: (TrendSnapshot snapshot, _) =>
//               snapshot
//                   .getTime()
//                   .difference(d
//                   .getHistoryData(0, dataCount: 1)[0] // TODO 仮
//                   .getTime())
//                   .inSeconds /
//                   86400.0,
//               yValueMapper: (TrendSnapshot snapshot, _) =>
//               logarithm
//                   ? log(snapshot.getHotness()) * log10e
//                   : snapshot.getHotness() / 1000,
//               color: color.withLightness(0.25).toColor(),
//             );
//           },
//         ),
//       );
//   }
// }
}

// absolute: 日付 relative: 経過時間
enum GraphMode { absolute, relative }
