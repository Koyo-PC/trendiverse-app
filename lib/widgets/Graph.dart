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
                    ? */
                    DateTimeAxis(
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
                      )*/
                ,
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
    // final List<LineSeries> series = [];
    final LineSeries twitterSeries;
    final LineSeries aiSeries;
    final List<TrendSnapshot> twitterDataList = [];
    final List<TrendSnapshot> aiDataList = [];
    final trendStartTime = data.getHistoryData(0, dataCount: 1)[0].getTime();
    for (int divIndex = 0; divIndex < data.getDividedCount(); divIndex++) {
      final List<TrendSnapshot> twitterDividedDataList = [];
      final List<TrendSnapshot> aiDividedDataList = [];
      var snapshots = data.getHistoryData(divIndex, dataCount: 500);

      for (var snapshot in snapshots) {
        if (snapshot.getSource() == TrendSource.twitter) {
          twitterDividedDataList.add(snapshot);
        } else {
          aiDividedDataList.add(snapshot);
        }
      }
      if (twitterDividedDataList.isNotEmpty && aiDividedDataList.isNotEmpty) {
        twitterDividedDataList.add(TrendSnapshot(aiDividedDataList[0].getTime(),
            aiDividedDataList[0].getHotness(), TrendSource.twitter));
      } else if (twitterDividedDataList.isNotEmpty) {
        final lastTwitterData =
            twitterDividedDataList[twitterDividedDataList.length - 1];
        twitterDividedDataList.add(TrendSnapshot(
            lastTwitterData.getTime().add(const Duration(minutes: 1)),
            0,
            TrendSource.twitter));
      } else if (aiDividedDataList.isNotEmpty) {
        // TODO Do nothing?
      }
      twitterDataList.addAll(twitterDividedDataList);
      aiDataList.addAll(aiDividedDataList);
    }

    xValueMapper(TrendSnapshot snapshot, _) {
      if (mode == GraphMode.absolute) {
        return snapshot.getTime();
      } else {
        return DateTime.fromMillisecondsSinceEpoch(snapshot
                .getTime()
                .difference(trendStartTime)
                .inMilliseconds /*.inSeconds /
              86400.0*/
            );
      }
    }

    yValueMapper(TrendSnapshot snapshot, _) {
      if (snapshot.getHotness() == 0) return null;
      if (logarithm) {
        return log(snapshot.getHotness()) * log10e;
      } else {
        return snapshot.getHotness() / 1000;
      }
    }

    twitterSeries = LineSeries<TrendSnapshot, DateTime>(
      legendItemText: data.getName(),
      dataSource: twitterDataList,
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      color: const HSLColor.fromAHSL(1, 0, 1, .5).toColor(),
    );
    aiSeries = LineSeries<TrendSnapshot, DateTime>(
      legendItemText: data.getName() + "(予測)",
      dataSource: aiDataList,
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      color: const HSLColor.fromAHSL(1, 0, 1, .85).toColor(),
    );
    return [twitterSeries, aiSeries].cast();
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
}

// absolute: 日付 relative: 経過時間
enum GraphMode { absolute, relative }
