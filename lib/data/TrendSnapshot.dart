import '../data/TrendSource.dart';

class TrendSnapshot {
  final TrendSource _source;
  final DateTime _time;
  final double _hotness;

  TrendSnapshot(this._source, this._time, this._hotness);

  TrendSource getSource() {
    return _source;
  }
  DateTime getTime() {
    return _time;
  }
  double getHotness() {
    return _hotness;
  }
}