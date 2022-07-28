import 'dart:core';

import 'package:flutter/material.dart';
import 'package:trendiverse/data/source/GoogleSource.dart';
import 'package:trendiverse/data/source/TwitterSource.dart';

import '../widgets/Tag.dart';
import '../data/TrendSnapshot.dart';

class TrendData {
  final String _name;
  final String? _category;

  TrendData(this._name, {String? category}) : _category = category;

  List<TrendSnapshot> _historyData = [];

  String getName() {
    return _name;
  }

  List<TrendSnapshot> getHistoryData() {
    return _historyData;
  }

  TrendData addHistoryData(TrendSnapshot snapshot) {
    _historyData.add(snapshot);
    return this;
  }

  List<Tag> getTags() {
    return [
      if (_historyData.any((element) => element.getSource() is GoogleSource))
        Tag(
          "Google",
          Color.fromRGBO(15, 157, 88, 1),
          Colors.white,
          30,
          margin: const EdgeInsets.all(5),
        ),
      if (_historyData.any((element) => element.getSource() is TwitterSource))
        Tag(
          "Twitter",
          Color.fromRGBO(29, 161, 242, 1),
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
}
