import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:trendiverse/data/source/GoogleSource.dart';

import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/TwitterSource.dart';

class Glaph extends StatelessWidget {
  final TrendData _data;

  Glaph(this._data) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: charts.TimeSeriesChart(
        [
          charts.Series<TrendSnapshot, DateTime>(
            id: 'Twitter',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
            measureFn: (TrendSnapshot snapshot, _) => snapshot.getHotness(),
            data: _data.getHistoryData().where((element) => element.getSource() is TwitterSource).toList(),
          ),
          charts.Series<TrendSnapshot, DateTime>(
            id: 'Google',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TrendSnapshot snapshot, _) => snapshot.getTime(),
            measureFn: (TrendSnapshot snapshot, _) => snapshot.getHotness(),
            data: _data.getHistoryData().where((element) => element.getSource() is GoogleSource).toList(),
          ),
        ],
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );

  }
}