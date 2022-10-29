import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/AISource.dart';
import '../data/source/TwitterSource.dart';

class Graph extends StatelessWidget {
  final int _id;
  final double height;

  final Color textColor;

  final bool enableAction;

  const Graph(this._id,
      {Key? key,
      this.height = 150,
      this.textColor = Colors.white,
      this.enableAction = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrendData>(
      future: TrenDiverseAPI().getData(_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: height,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                labelStyle: TextStyle(
                  color: textColor,
                ),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: textColor,
                ),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: enableAction, zoomMode: ZoomMode.x),
              series: <ChartSeries>[
                LineSeries<TrendSnapshot, DateTime>(
                  dataSource: data
                      .getHistoryData(dataCount: 500)
                      .where((element) => element.getSource() is TwitterSource)
                      .toList(),
                  xValueMapper: (TrendSnapshot snapshot, _) =>
                      snapshot.getTime(),
                  yValueMapper: (TrendSnapshot snapshot, _) =>
                      snapshot.getHotness(),
                  color: Colors.blue,
                ),
                LineSeries<TrendSnapshot, DateTime>(
                  dataSource: data
                      .getHistoryData(dataCount: 500)
                      .where((element) => element.getSource() is AISource)
                      .toList(),
                  xValueMapper: (TrendSnapshot snapshot, _) =>
                      snapshot.getTime(),
                  yValueMapper: (TrendSnapshot snapshot, _) =>
                      snapshot.getHotness(),
                  color: Colors.red,
                )
              ],
              crosshairBehavior: CrosshairBehavior(enable: enableAction),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
