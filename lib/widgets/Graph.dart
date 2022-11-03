import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/src/chart/axis/multi_level_labels.dart';
import 'package:syncfusion_flutter_core/src/slider_controller.dart';
import 'package:trendiverse/data/TrendSource.dart';

import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';

class Graph extends StatelessWidget {
  final List<List<int>> _ids;
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
        child: FutureBuilder<List<List<TrendData>>>(
          future: Future.wait(
            _ids
                .map(
                  (groupedIds) => Future.wait(
                    groupedIds
                        .map(
                          (id) => TrenDiverseAPI().getData(id),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!
                  .map((groupedIds) => TrendData.merged(groupedIds))
                  .toList();
              return SfCartesianChart(
                // X軸
                primaryXAxis: mode == GraphMode.absolute
                    // 絶対表示(日付)の時
                    ? DateTimeAxis(
                        labelStyle: TextStyle(
                          color: textColor,
                        ),

                        // dateFormat: mode == GraphMode.absolute
                        //     ? DateFormat("MM/dd\nHH:mm")
                    dateFormat: DateFormat("MM/dd\nHH:mm")
                        //     : DateFormat("d日目H時間"),
                  // labelFormat: '{value}日',
                      )
                    : NumericAxis(
                        labelStyle: TextStyle(
                          color: textColor,
                        ),
                        labelFormat: '{value}日',
                      ),
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
                crosshairBehavior: CrosshairBehavior(
                  enable: enableAction,
                  activationMode: ActivationMode.singleTap,
                  // shouldAlwaysShow: true
                ),
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

  // location: 0~1
  List<LineSeries<TrendSnapshot, dynamic>> buildTrendSeries(
      TrendData data, double location) {
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
        twitterDividedDataList.add(TrendSnapshot(
            aiDividedDataList[0]
                .getTime() /*.subtract(const Duration(seconds: 30))*/,
            aiDividedDataList[0].getHotness(),
            TrendSource.twitter));
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

    dynamic xValueMapper(TrendSnapshot snapshot, _) {
      if (mode == GraphMode.absolute) {
        return DateOrDuration.fromDate(snapshot.getTime());
      } else {
        return
            snapshot.getTime().difference(trendStartTime).inSeconds.toDouble() / 60 / 60 / 24;
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

    twitterSeries = LineSeries<TrendSnapshot, dynamic>(
      legendItemText: data.getName(),
      dataSource: twitterDataList,
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      color: HSLColor.fromAHSL(1, location, 1, .5).toColor(),
    );
    aiSeries = LineSeries<TrendSnapshot, dynamic>(
      legendItemText: data.getName() + "(予測)",
      dataSource: aiDataList,
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      color: HSLColor.fromAHSL(1, location, 1, .85).toColor(),
    );
    return [twitterSeries, aiSeries].cast();
  }

  List<LineSeries> buildAllTrendSeries(List<TrendData> data) {
    List<LineSeries> series = [];
    for (var element in data) {
      print(data.indexOf(element).toDouble().toString() +
          " " +
          data.length.toString());
      buildTrendSeries(
              element, data.indexOf(element).toDouble() / data.length * 360)
          .forEach((element) {
        series.add(element);
      });
    }
    return series;
  }
}

class DateOrDuration {
  int _milliseconds;

  DateOrDuration(this._milliseconds);

  factory DateOrDuration.fromDate(DateTime d) =>
      DateOrDuration(d.millisecondsSinceEpoch);

  factory DateOrDuration.fromDuration(Duration d) =>
      DateOrDuration(d.inMilliseconds);

  DateTime getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(_milliseconds);
  }

  Duration getDuration() {
    return Duration(milliseconds: _milliseconds);
  }
  
  get millisecondsSinceEpoch => _milliseconds;
}

// absolute: 日付 relative: 経過時間
enum GraphMode { absolute, relative }
