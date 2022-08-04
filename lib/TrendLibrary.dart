import 'package:trendiverse/TrendiverseAPI.dart';
import 'package:trendiverse/data/source/GoogleSource.dart';

import '../data/TrendData.dart';
import 'data/TrendSnapshot.dart';
import 'data/source/TwitterSource.dart';

class TrendLibrary {
  static final TrendLibrary _instance = TrendLibrary._internal();

  TrendLibrary._internal();

  factory TrendLibrary() {
    return _instance;
  }

  Map<String, TrendData> cache = {};

  Future<TrendData> getTrendData(String name) async {
    if (cache.containsKey(name)) {
      return cache[name]!;
    }
    final APITrendInfo info = await TrendiverseAPI().getInfo(name);
    var category = info.category;
    var related = info.related;
    var data = TrendData(name, category: category, related: related);
    info.data.twitter.forEach((part) =>
        data.addHistoryData(
            TrendSnapshot(TwitterSource(), part.date, part.hotness))
    );
    info.data.google.forEach((part) =>
        data.addHistoryData(
            TrendSnapshot(GoogleSource(), part.date, part.hotness))
    );
    cache[name] = data;
    return data;
  }
}
