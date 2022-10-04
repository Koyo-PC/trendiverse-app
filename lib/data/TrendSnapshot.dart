import '../data/TrendSource.dart';

class TrendSnapshot {
  final DateTime _time;
  final int _hotness;
  final TrendSource _source;

  TrendSnapshot(this._time, this._hotness, this._source);

  DateTime getTime() {
    return _time;
  }
  int getHotness() {
    return _hotness;
  }
  TrendSource getSource() {
    return _source;
  }
}