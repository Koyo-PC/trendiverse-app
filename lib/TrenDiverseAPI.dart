import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:trendiverse/data/TrendData.dart';

import 'AppConfig.dart';

part 'TrenDiverseAPI.g.dart';

class TrenDiverseAPI {
  static final TrenDiverseAPI _instance = TrenDiverseAPI._internal();

  TrenDiverseAPI._internal();

  factory TrenDiverseAPI() {
    return _instance;
  }

  // Load config from shared preferences
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd-HH-mm-ss');

  Future<Map<String, dynamic>> _requestAPI(int port, String location,
      {Map<String, dynamic>? query}) async {
    final SharedPreferences config = await AppConfig().getConfig();
    var response = await http.get(
      Uri.http(
        '${config.getString('server_ip')}:$port',
        location,
        query ?? {},
      ),
    );
    return json.decode(response.body);
  }

  // list of current trends
  Future<List<CurrentTrendData>> getList() async {
    Map<String, dynamic> result = await _requestAPI(8081, "/showTrend");
    // debugPrint('${result["list"] as List<Map<String, dynamic>>}');
    // List<CurrentTrendData> data = (result["list"] as List<Map<String, dynamic>>).map((element) {CurrentTrendData.fromJson(element)}).toList();
    // return data;
    return (result["list"] as List)/*.cast<Map<String, dynamic>>()*/.map((element) {return CurrentTrendData.fromJson(element);}).toList();
  }

  // hotness history of specific trend
  Future<APITrendInfo> getData(int id) async {
    Map<String, dynamic> result =
        await _requestAPI(8081, "/getDataById", query: {"id": id});
    APITrendInfo data = APITrendInfo.fromJson(result["list"]);
    return data;
  }
}

// when you change this file, run this command to regenerate the code:
// `$ flutter packages pub run build_runner build`

@JsonSerializable()
class CurrentTrendData {
  CurrentTrendData(this.id, this.hotness, this.name);

  int id;
  int hotness;
  String name;

  factory CurrentTrendData.fromJson(Map<String, dynamic> json) =>
      _$CurrentTrendDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentTrendDataToJson(this);
}

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

@JsonSerializable()
class APITrendInfo {

  String category;
  List<int> related;
  APITrendData data;

  APITrendInfo(this.category, this.related, this.data);

  factory APITrendInfo.fromJson(Map<String, dynamic> json) =>
      _$APITrendInfoFromJson(json);

  Map<String, dynamic> toJson() => _$APITrendInfoToJson(this);
}

@JsonSerializable()
class APITrendData {
  APITrendData(this.google, this.twitter);

  List<APITrendDataPart> google;
  List<APITrendDataPart> twitter;

  factory APITrendData.fromJson(Map<String, dynamic> json) =>
      _$APITrendDataFromJson(json);

  Map<String, dynamic> toJson() => _$APITrendDataToJson(this);
}

@JsonSerializable()
class APITrendDataPart {
  APITrendDataPart(this.date, this.hotness);

  DateTime date;
  double hotness;

  factory APITrendDataPart.fromJson(Map<String, dynamic> json) =>
      _$APITrendDataPartFromJson(json);

  Map<String, dynamic> toJson() => _$APITrendDataPartToJson(this);
}