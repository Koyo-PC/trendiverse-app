// import 'package:trendiverse/TrenDiverseAPI.dart';
// import 'package:trendiverse/data/source/AISource.dart';
//
// import '../data/TrendData.dart';
// import 'data/TrendSnapshot.dart';
// import 'data/source/TwitterSource.dart';
//
// class TrendLibrary {
//   static final TrendLibrary _instance = TrendLibrary._internal();
//
//   TrendLibrary._internal();
//
//   factory TrendLibrary() {
//     return _instance;
//   }
//
//   // Map<String, TrendData> cache = {};
//   Map<String, APITrendData> cache = {};
//
//   Future<List<APITrendData>> getTrendData(int id) async {
//     if (cache.containsKey(id.toString())) {
//       return cache[id.toString()]!;
//     }
//     // final APITrendInfo info = await TrenDiverseAPI().getData(id);
//     // var category = info.category;
//     // var related = info.related;
//     // var data = TrendData(id.toString(), category: category, related: related);
//     var data = await TrenDiverseAPI().getData(id);
//     // info.data.twitter.forEach((part) =>
//     //     data.addHistoryData(
//     //         TrendSnapshot(TwitterSource(), part.date, part.hotness))
//     // );
//     // info.data.google.forEach((part) =>
//     //     data.addHistoryData(
//     //         TrendSnapshot(GoogleSource(), part.date, part.hotness))
//     // );
//     cache[id.toString()] = data;
//     return data;
//   }
// }
