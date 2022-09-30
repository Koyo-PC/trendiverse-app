import 'dart:core';
import 'package:flutter/material.dart';

import '../widgets/Tag.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/GoogleSource.dart';
import '../data/source/TwitterSource.dart';

class TrendData {
  final String _name;
  final String? _category;
  final List<int> _related;

  TrendData(this._name, {String? category, List<int>? related}) : _category = category, _related = related ?? [];

  final List<TrendSnapshot> _historyData = [];

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

  List<Tag> getTags() {
    bool hasGoogleSource = _historyData.any((element) => element.getSource() is GoogleSource);
    bool hasTwitterSource = _historyData.any((element) => element.getSource() is TwitterSource);
    return [
      if (hasGoogleSource)
        Tag(
          "Google",
          const Color.fromRGBO(15, 157, 88, 1),
          Colors.white,
          30,
          margin: const EdgeInsets.all(5),
        ),
      if (hasTwitterSource)
        Tag(
          "Twitter",
          const Color.fromRGBO(29, 161, 242, 1),
          Colors.white,
          30,
          margin: const EdgeInsets.all(5),
        ),
      if(!hasTwitterSource && !hasGoogleSource)
        Tag(
          "エラー: データが存在しません",
          const Color.fromRGBO(255, 0, 0, 1),
          Colors.white,
          30,
          margin: const EdgeInsets.all(5),
        ),
    ];
  }

  String? getCategory() {
    // TODO カテゴリの色
    return _category;
  }

  List<int> getRelated() {
    return _related;
  }
}
