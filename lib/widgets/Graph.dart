import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../TrenDiverseAPI.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/AISource.dart';
import '../data/source/TwitterSource.dart';

class Graph extends StatelessWidget {
  final int _id;
  final double height;

  const Graph(this._id, {Key? key, this.height = 150}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrendData>(
      future: TrenDiverseAPI().getData(_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: height,
            child: charts.TimeSeriesChart(
              [
                charts.Series<TrendSnapshot, DateTime>(
                  id: 'Twitter',
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
                  measureFn: (TrendSnapshot snapshot, _) =>
                      snapshot.getHotness(),
                  // TODO 線を越えないようにする
                  data: data
                      .getHistoryData()
                      .where((element) => element.getSource() is TwitterSource)
                      // .where((element) =>
                      //     element.getTime().millisecondsSinceEpoch <
                      //     DateTime.now().millisecondsSinceEpoch)
                      .toList()
                    ..sort((a, b) => a.getTime().compareTo(b.getTime())),
                ),
                charts.Series<TrendSnapshot, DateTime>(
                  id: 'AI',
                  colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
                  domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
                  measureFn: (TrendSnapshot snapshot, _) =>
                      snapshot.getHotness(),
                  // TODO 線を越えないようにする
                  data: data
                      .getHistoryData()
                      .where((element) => element.getSource() is AISource)
                      // .where((element) =>
                      //     element.getTime().millisecondsSinceEpoch >
                      //     DateTime.now().millisecondsSinceEpoch)
                      .toList()
                    ..sort((a, b) => a.getTime().compareTo(b.getTime())),
                ),
              ],
              defaultInteractions: false,
              animate: false,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              domainAxis: const charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                    format: 'dd', transitionFormat: 'MM/dd'),
                hour: charts.TimeFormatterSpec(
                    format: 'hh:mm', transitionFormat: 'dd hh:mm'),
                minute: charts.TimeFormatterSpec(
                  format: 'hh:mm',
                  transitionFormat: 'hh:mm',
                ),
              )),
              behaviors: [
                charts.RangeAnnotation(
                  [
                    charts.LineAnnotationSegment(
                      DateTime.now(),
                      charts.RangeAnnotationAxisType.domain,
                      color: charts.Color.fromHex(
                        code: Theme.of(context)
                            .backgroundColor
                            .value
                            .toRadixString(16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
