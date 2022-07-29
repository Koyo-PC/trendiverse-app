import '../data/TrendData.dart';

class TrendLibrary {
  static final TrendLibrary _instance = TrendLibrary._internal();

  TrendLibrary._internal();

  factory TrendLibrary() {
    return _instance;
  }

  Map<String, TrendData> cache = {};

  TrendData getTrendData(String name) {
    if (cache.containsKey(name)) {
      return cache[name]!;
    }
    // TODO: get from api
    var category = "";
    var related = ["test1", "test2"];
    var data = TrendData(name /*,category: category*/, related: related);
    cache[name] = data;
    return data;
  }
}
