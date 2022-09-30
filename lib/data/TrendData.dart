import 'dart:core';
import 'package:flutter/material.dart';

import '../widgets/Tag.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/GoogleSource.dart';
import '../data/source/TwitterSource.dart';

class TrendData {
  final String _name;
  final List<TrendSnapshot> _historyData;

  TrendData(this._name, this._historyData);


  String getName() {
    return _name;
  }

  List<TrendSnapshot> getHistoryData() {
    return _historyData;
  }

  void clearHistoryData() {
    _historyData.clear();
    return;
  }

  void addHistoryData(TrendSnapshot snapshot) {
    _historyData.add(snapshot);
    return;
  }
}
