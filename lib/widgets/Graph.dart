import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/GoogleSource.dart';
import '../data/source/TwitterSource.dart';

class Graph extends StatelessWidget {
  final TrendData _data;

  final double height;

  Graph(this._data, {Key? key, this.height = 150}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: charts.TimeSeriesChart(
        [
          charts.Series<TrendSnapshot, DateTime>(
            id: 'Twitter',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
            measureFn: (TrendSnapshot snapshot, _) => snapshot.getHotness(),
            dashPatternFn: (TrendSnapshot snapshot, _) =>
                snapshot.getTime().isBefore(DateTime.now()) ? null : [2, 2],
            // TODO 線を越えないようにする
            data: _data
                .getHistoryData()
                .where((element) => element.getSource() is TwitterSource)
                .toList(),
          ),
          charts.Series<TrendSnapshot, DateTime>(
            id: 'Google',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
            measureFn: (TrendSnapshot snapshot, _) => snapshot.getHotness(),
            dashPatternFn: (TrendSnapshot snapshot, _) =>
                snapshot.getTime().isBefore(DateTime.now()) ? null : [2, 2],
            // TODO 線を越えないようにする
            data: _data
                .getHistoryData()
                .where((element) => element.getSource() is GoogleSource)
                .toList(),
          ),
        ],
        defaultInteractions: false,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: const charts.DateTimeAxisSpec(
            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day:
              charts.TimeFormatterSpec(format: 'dd', transitionFormat: 'MM/dd'),
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
                  code:
                      Theme.of(context).backgroundColor.value.toRadixString(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
