import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:trendiverse/LocalStrage.dart';

import 'data/TrendData.dart';
import 'data/TrendSnapshot.dart';
import 'data/source/AISource.dart';
import 'data/source/TwitterSource.dart';

class TrenDiverseAPI {
  static final TrenDiverseAPI _instance = TrenDiverseAPI._internal();

  TrenDiverseAPI._internal();

  factory TrenDiverseAPI() {
    return _instance;
  }

  // Load config from shared preferences
  // final DateFormat _dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'zz");

  static int count = 0;

  Future<String> _requestAPIStr(int port, String location,
      {Map<String, dynamic>? query}) async {
    var response = await http.get(
      Uri.http(
        '${LocalStrage().getServerIp()}:$port',
        location,
        query ?? {},
      ),
    );
    print(count++);
    print(location);
    print(query);
    return response.body;
  }

  Future<Map<String, dynamic>> _requestAPI(int port, String location,
      {Map<String, dynamic>? query}) async {
    return json.decode(await _requestAPIStr(port, location, query: query));
  }

  // list of current trends
  Future<List<int>> getList() async {
    Map<String, dynamic> result = await _requestAPI(8081, "/showTrend");
    // debugPrint('${result["list"] as List<Map<String, dynamic>>}');
    // List<CurrentTrendData> data = (result["list"] as List<Map<String, dynamic>>).map((element) {CurrentTrendData.fromJson(element)}).toList();
    // return data;
    List trendList = result["list"];
    trendList.sort((a, b) {
      return (b["hotness"] as int).compareTo(a["hotness"] as int);
    });
    return trendList.map((element) {
      return element["id"] as int;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    Map<String, dynamic> result = await _requestAPI(8081, "/getList");
    // debugPrint('${result["list"] as List<Map<String, dynamic>>}');
    // List<CurrentTrendData> data = (result["list"] as List<Map<String, dynamic>>).map((element) {CurrentTrendData.fromJson(element)}).toList();
    // return data;
    var data = <Map<String, dynamic>>[];
    for (int i = 0; i < (result["list"] as List).length; i++) {
      data.add(result["list"][i]);
    }
    // for (var element in (result["list"] as List<Map<String, String>>)) {
    //   data.add(element);
    // }
    data.sort((a, b) => b["id"].compareTo(a["id"]));
    return data;
  }

  static Map<int, MapEntry<DateTime, TrendData>> cachedData = {};
  static const Duration cacheLife = Duration(minutes: 5);

  // hotness history of specific trend
  Future<TrendData> getData(int id) async {
    if (cachedData.containsKey(id) &&
        cachedData[id]!.key.difference(DateTime.now()).compareTo(cacheLife) >
            0) {
      return cachedData[id]!.value;
    }
    Map<String, dynamic> result =
        await _requestAPI(8081, "/getDataById", query: {"id": id.toString()});
    List<TrendSnapshot> snapshots = (result["list"] as List).map((e) {
      return TrendSnapshot(
          _dateFormat.parse(e["date"]), e["hotness"], TwitterSource());
    }).toList();
    snapshots.addAll(await getPredictData(id));
    TrendData data = TrendData(id, await getName(id), snapshots);
    cachedData[id] = MapEntry(DateTime.now(), data);
    return data;
  }

  static Map<int, String> cachedName = {};

  Future<String> getName(int id) async {
    if (cachedName.containsKey(id)) return Future.value(cachedName[id]);
    String result = await _requestAPIStr(8081, "/getNameById",
        query: {"id": id.toString()});
    // List<TrendSnapshot> snapshots = (result["list"] as List).map((e) { return TrendSnapshot(_dateFormat.parse(e["date"]), e["hotness"]);}).toList();
    var name = result.substring(1, result.length - 1);
    cachedName[id] = name;
    return name;
  }

  Future<List<TrendSnapshot>> getPredictData(int id) async {
    String result =
        await _requestAPIStr(8800, "/", query: {"id": id.toString()});
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
    return ((jsonDecode(result) as Map)["data"] as List)
        .map((e) => TrendSnapshot(
            format.parse(e["date"]).subtract(const Duration(hours: 9)),
            e["hotness"].toInt(),
            AISource()))
        .toList();
  }
}
