import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:trendiverse/data/TrendSource.dart';

import 'data/TrendData.dart';
import 'data/TrendSnapshot.dart';

class TrenDiverseAPI {
  static final TrenDiverseAPI _instance = TrenDiverseAPI._internal();

  TrenDiverseAPI._internal();

  factory TrenDiverseAPI() {
    return _instance;
  }

  static const String serverIp = "138.2.55.39";
  static const Duration cacheLife = Duration(minutes: 5);

  // final DateFormat _dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'zz");

  Future<String> _requestAPIStr(int port, String location,
      {Map<String, dynamic>? query}) async {
    var response = await http.get(
      Uri.http(
        '$serverIp:$port',
        location,
        query ?? {},
      ),
    );
    return response.body;
  }

  Future<Map<String, dynamic>> _requestAPI(int port, String location,
      {Map<String, dynamic>? query}) async {
    return json.decode(await _requestAPIStr(port, location, query: query));
  }

  static MapEntry<DateTime, List<int>> cachedList =
      MapEntry(DateTime.fromMillisecondsSinceEpoch(0), []);

  // list of current trends
  Future<List<int>> getList() async {
    if (cachedList.value.length > 1 &&
        cachedList.key.difference(DateTime.now()).compareTo(cacheLife) < 0) {
      return cachedList.value;
    }

    Map<String, dynamic> result = await _requestAPI(8081, "/showTrend");
    // debugPrint('${result["list"] as List<Map<String, dynamic>>}');
    // List<CurrentTrendData> data = (result["list"] as List<Map<String, dynamic>>).map((element) {CurrentTrendData.fromJson(element)}).toList();
    // return data;
    List trendList = result["list"];
    trendList.sort((a, b) {
      return (b["hotness"] as int).compareTo(a["hotness"] as int);
    });
    var list = trendList.map((element) {
      return element["id"] as int;
    }).toList();
    cachedList = MapEntry(DateTime.now(), list);
    return list;
  }

  static MapEntry<DateTime, List<Map<String, dynamic>>> cachedAllData =
      MapEntry(DateTime.fromMillisecondsSinceEpoch(0), []);

  Future<List<Map<String, dynamic>>> getAllData() async {
    if (cachedAllData.value.length > 1 &&
        cachedAllData.key.difference(DateTime.now()).compareTo(cacheLife) < 0) {
      return cachedAllData.value;
    }
    Map<String, dynamic> result = await _requestAPI(8081, "/getList");
    var data = <Map<String, dynamic>>[];
    for (int i = 0; i < (result["list"] as List).length; i++) {
      data.add(result["list"][i]);
    }
    data.sort((a, b) => b["id"].compareTo(a["id"]));
    cachedAllData = MapEntry(DateTime.now(), data);
    return data;
  }

  static Map<int, MapEntry<DateTime, TrendData>> cachedData = {};

  // hotness history of specific trend
  Future<TrendData> getData(int id) async {
    if (cachedData.containsKey(id) &&
        cachedData[id]!.key.difference(DateTime.now()).compareTo(cacheLife) <
            0) {
      return cachedData[id]!.value;
    }
    var predictData = await getPredictData(id);
    TrendData data = TrendData(
        id,
        await getName(id),
        predictData.value
            .where((element) =>
                predictData.value.indexOf(element) % 10 == 0 ||
                predictData.value
                        .firstWhere((el) => el.getSource() == TrendSource.ai) ==
                    element ||
                predictData.value.lastWhere(
                        (el) => el.getSource() == TrendSource.twitter) ==
                    element ||
                predictData.value.indexOf(element) ==
                    predictData.value.length - 1)
            .toList(),
        sourceId: predictData.key);
    cachedData[id] = MapEntry(DateTime.now(), data);
    return data;
  }

  static Map<int, String> cachedName = {};

  Future<String> getName(int id) async {
    if (cachedName.containsKey(id)) return cachedName[id]!;
    String result = await _requestAPIStr(8081, "/getNameById",
        query: {"id": id.toString()});
    // List<TrendSnapshot> snapshots = (result["list"] as List).map((e) { return TrendSnapshot(_dateFormat.parse(e["date"]), e["hotness"]);}).toList();
    var name = result.substring(1, result.length - 1);
    cachedName[id] = name;
    return name;
  }

  static Map<int, MapEntry<DateTime, String>> cachedPredictedData = {};

  Future<MapEntry<int, List<TrendSnapshot>>> getPredictData(int id) async {
    String result;
    if (cachedPredictedData.containsKey(id) &&
        cachedPredictedData[id]!
                .key
                .difference(DateTime.now())
                .compareTo(cacheLife) <
            0) {
      result = cachedPredictedData[id]!.value;
    } else {
      result = await _requestAPIStr(8800, "/", query: {"id": id.toString()});
      cachedPredictedData[id] = MapEntry(DateTime.now(), result);
    }
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    Map requestData = jsonDecode(result) as Map;
    var data = MapEntry(
        requestData["id"] as int,
        (requestData["data"] as List).map((e) {
          var date = format.parse(e["date"]).subtract(const Duration(hours: 9));
          if (date.compareTo(DateTime.now()) == 1) {
            return TrendSnapshot(date, e["hotness"].toInt(), TrendSource.ai);
          } else {
            return TrendSnapshot(
                date, e["hotness"].toInt(), TrendSource.twitter);
          }
        }).toList());
    final firstAi = data.value
        .firstWhere((element) => element.getSource() == TrendSource.ai);
    data.value.add(TrendSnapshot(
        firstAi.getTime(), firstAi.getHotness(), TrendSource.twitter));
    return data;
  }

  Future<List<String>> getPopular(int id) async {
    var result = await _requestAPIStr(8081, "/getPopularDataById",
        query: {"id": id.toString()});
    Map data = jsonDecode(result) as Map;
    return (data["list"] as List).cast<String>();
  }
}
