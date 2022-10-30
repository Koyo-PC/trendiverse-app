import 'package:flutter/material.dart';
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

  const Graph(this._ids,
      {Key? key,
      this.height = 150,
      this.textColor = Colors.white,
      this.enableAction = false,
      this.mode = GraphMode.absolute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrendData>>(
      future: Future.wait(
        _ids.map((id) => TrenDiverseAPI().getData(id)).toList(),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: height,
            child: SfCartesianChart(
              primaryXAxis: mode == GraphMode.absolute
                  ? (DateTimeAxis(
                      labelStyle: TextStyle(
                      color: textColor,
                    )))
                  : (NumericAxis(
                      labelStyle: TextStyle(
                      color: textColor,
                    ))),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: textColor,
                ),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: enableAction, zoomMode: ZoomMode.x),
              series: mode == GraphMode.absolute
                  ? (data
                      .map(
                        (d) => LineSeries<TrendSnapshot, DateTime>(
                          dataSource: d
                              .getHistoryData(dataCount: 500)
                              .where((element) =>
                                  element.getSource() == TrendSource.twitter)
                              .toList(),
                          xValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot.getTime(),
                          yValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot.getHotness(),
                          color: Colors.blue,
                        ),
                      )
                      .toList()
                    ..addAll(
                      data.map(
                        (d) => LineSeries<TrendSnapshot, DateTime>(
                          dataSource: d
                              .getHistoryData(dataCount: 500)
                              .where((element) =>
                                  element.getSource() == TrendSource.ai)
                              .toList(),
                          xValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot.getTime(),
                          yValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot.getHotness(),
                          color: Colors.red,
                        ),
                      ),
                    ))
                  : (data.map(
                      (d) {
                        var color = HSLColor.fromAHSL(
                            1,
                            360 * data.indexOf(d).toDouble() / data.length,
                            1,
                            .75);
                        return LineSeries<TrendSnapshot, double>(
                          legendItemText: d.getName(),
                          dataSource: d
                              .getHistoryData(dataCount: 500)
                              .where((element) =>
                                  element.getSource() == TrendSource.twitter)
                              .toList(),
                          xValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot
                                  .getTime()
                                  .difference(d
                                      .getHistoryData(dataCount: 1)[0]
                                      .getTime())
                                  .inSeconds /
                              86400.0,
                          yValueMapper: (TrendSnapshot snapshot, _) =>
                              snapshot.getHotness(),
                          color: color.toColor(),
                        );
                      },
                    ).toList()
                    ..addAll(
                      data.map(
                        (d) {
                          var color = HSLColor.fromAHSL(
                              1,
                              360 * data.indexOf(d).toDouble() / data.length,
                              1,
                              .75);
                          return LineSeries<TrendSnapshot, double>(
                            legendItemText: d.getName() + "(予測)",
                            dataSource: d
                                .getHistoryData(dataCount: 500)
                                .where((element) =>
                                    element.getSource() == TrendSource.ai)
                                .toList(),
                            xValueMapper: (TrendSnapshot snapshot, _) =>
                                snapshot
                                    .getTime()
                                    .difference(d
                                        .getHistoryData(dataCount: 1)[0]
                                        .getTime())
                                    .inSeconds /
                                86400.0,
                            yValueMapper: (TrendSnapshot snapshot, _) =>
                                snapshot.getHotness(),
                            color: color.withLightness(0.25).toColor(),
                          );
                        },
                      ),
                    )),
              legend: Legend(
                  isVisible: mode == GraphMode.relative,
                  position: LegendPosition.bottom),
              crosshairBehavior: CrosshairBehavior(enable: enableAction),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

// absolute: 日付 relative: 経過時間
enum GraphMode { absolute, relative }
