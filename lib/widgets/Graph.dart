import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/AISource.dart';
import '../data/source/TwitterSource.dart';

class Graph extends StatelessWidget {
  final List<int> _ids;
  final double height;

  final Color textColor;

  final bool enableAction;

  const Graph(this._ids,
      {Key? key,
      this.height = 150,
      this.textColor = Colors.white,
      this.enableAction = false})
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
              series: data
                  .map(
                    (d) => LineSeries<TrendSnapshot, DateTime>(
                      dataSource: d
                          .getHistoryData(dataCount: 500)
                          .where(
                              (element) => element.getSource() is TwitterSource)
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
                          .where((element) => element.getSource() is AISource)
                          .toList(),
                      xValueMapper: (TrendSnapshot snapshot, _) =>
                          snapshot.getTime(),
                      yValueMapper: (TrendSnapshot snapshot, _) =>
                          snapshot.getHotness(),
                      color: Colors.red,
                    ),
                  ),
                ),
              crosshairBehavior: CrosshairBehavior(enable: enableAction),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
