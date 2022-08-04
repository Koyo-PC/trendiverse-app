import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'AppConfig.dart';

part 'TrendiverseAPI.g.dart';

class TrendiverseAPI {
  static final TrendiverseAPI _instance = TrendiverseAPI._internal();

  TrendiverseAPI._internal();

  factory TrendiverseAPI() {
    return _instance;
  }

  // Load config from shared preferences
  final Map<String, DateTime> _lastRequest = {
    "/list": DateTime.fromMillisecondsSinceEpoch(0),
    "/data": DateTime.fromMillisecondsSinceEpoch(0),
    "/info": DateTime.fromMillisecondsSinceEpoch(0),
  };
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd-HH-mm-ss');

  Future<Map<String, dynamic>> _requestAPI(String location,
      {Map<String, dynamic>? query}) async {
    final SharedPreferences config = await AppConfig().getConfig();
    var response = await http.get(
      Uri.http(
        '${config.getString('server_ip')}:${config.getInt('server_port')}',
        location,
        {
          "last_request": _dateFormat.format(_lastRequest[location]!),
        }..addAll(query ?? {}),
      ),
    );
    _lastRequest[location] = DateTime.now();
    return json.decode(response.body);
  }

  // list of current trends
  Future<TrendList> getList() async {
    Map<String, dynamic> result = await _requestAPI("/list");
    TrendList data = TrendList.fromJson(result);
    return data;
  }

  // hotness history of specific trend
  Future<APITrendInfo> getInfo(String name) async {
    Map<String, dynamic> result =
        await _requestAPI("/info", query: {"name": name});
    APITrendInfo data = APITrendInfo.fromJson(result);
    return data;
  }
}

// flutter packages pub run build_runner build

@JsonSerializable()
class TrendList {
  TrendList(this.google, this.twitter);

  List<String> google;
  List<String> twitter;

  factory TrendList.fromJson(Map<String, dynamic> json) =>
      _$TrendListFromJson(json);

  Map<String, dynamic> toJson() => _$TrendListToJson(this);
}

@JsonSerializable()
class APITrendInfo {

  String category;
  List<String> related;
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