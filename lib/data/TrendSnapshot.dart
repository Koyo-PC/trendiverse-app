import '../data/TrendSource.dart';

class TrendSnapshot {
  final DateTime _time;
  final int _hotness;

  TrendSnapshot(this._time, this._hotness);

  DateTime getTime() {
    return _time;
  }
  int getHotness() {
    return _hotness;
  }
}