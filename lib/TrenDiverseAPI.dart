import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:trendiverse/data/TrendData.dart';
import 'package:trendiverse/data/TrendSnapshot.dart';
import 'package:trendiverse/data/source/AISource.dart';
import 'package:trendiverse/data/source/TwitterSource.dart';

import 'AppConfig.dart';

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
    final SharedPreferences config = await AppConfig().getConfig();
    var response = await http.get(
      Uri.http(
        '${config.getString('server_ip')}:$port',
        location,
        query ?? {},
      ),
    );
    print(count++);
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
    for(int i = 0; i < (result["list"] as List).length; i++) {
      data.add(result["list"][i]);
    }
    // for (var element in (result["list"] as List<Map<String, String>>)) {
    //   data.add(element);
    // }
    data.sort((a,b) => b["id"].compareTo(a["id"]));
    return data;
  }

  static Map<int, TrendData> cachedData = {};

  // hotness history of specific trend
  Future<TrendData> getData(int id) async {
    if (cachedData.containsKey(id)) return cachedData[id]!;
    Map<String, dynamic> result =
        await _requestAPI(8081, "/getDataById", query: {"id": id.toString()});
    List<TrendSnapshot> snapshots = (result["list"] as List).map((e) {
      return TrendSnapshot(
          _dateFormat.parse(e["date"]), e["hotness"], TwitterSource());
    }).toList();
    snapshots.addAll(await getPredictData(id));
    TrendData data = TrendData(id, await getName(id), snapshots);
    cachedData[id] = data;
    return data;
  }

  TrendData? getCachedData(int id) {
    return cachedData[id];
  }

  Future<String> getName(int id) async {
    String result = await _requestAPIStr(8081, "/getNameById",
        query: {"id": id.toString()});
    // List<TrendSnapshot> snapshots = (result["list"] as List).map((e) { return TrendSnapshot(_dateFormat.parse(e["date"]), e["hotness"]);}).toList();
    return result.substring(1, result.length - 1);
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

// when you change this file, run this command to regenerate the code:
// `$ flutter packages pub run build_runner build`

// @JsonSerializable()
// class CurrentTrendData {
//   CurrentTrendData(this.id, this.hotness, this.name);
//
//   int id;
//   int hotness;
//   String name;
//
//   factory CurrentTrendData.fromJson(Map<String, dynamic> json) =>
//       _$CurrentTrendDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$CurrentTrendDataToJson(this);
// }

// @JsonSerializable()
// class TrendList {
//   TrendList(this.google, this.twitter);
//
//   int id;
//   int hotness;
//   String name;
//
//   factory TrendList.fromJson(Map<String, dynamic> json) =>
//       _$TrendListFromJson(json);
//
//   Map<String, dynamic> toJson() => _$TrendListToJson(this);
// }
/*
@JsonSerializable()
class APITrendInfo {

  // String category;
  // List<int> related;
  APITrendData data;

  APITrendInfo(this.category, this.related, this.data);

  factory APITrendInfo.fromJson(Map<String, dynamic> json) =>
      _$APITrendInfoFromJson(json);

  Map<String, dynamic> toJson() => _$APITrendInfoToJson(this);
}
*/
// @JsonSerializable()
// class APITrendData {
//   APITrendData(this.date, this.hotness);
//
//   DateTime date;
//   double hotness;
//
//   factory APITrendData.fromJson(Map<String, dynamic> json) =>
//       _$APITrendDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$APITrendDataToJson(this);
// }
