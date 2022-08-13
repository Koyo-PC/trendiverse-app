// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrenDiverseAPI.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendList _$TrendListFromJson(Map<String, dynamic> json) => TrendList(
      (json['google'] as List<dynamic>).map((e) => e as String).toList(),
      (json['twitter'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TrendListToJson(TrendList instance) => <String, dynamic>{
      'google': instance.google,
      'twitter': instance.twitter,
    };

APITrendInfo _$APITrendInfoFromJson(Map<String, dynamic> json) => APITrendInfo(
      json['category'] as String,
      (json['related'] as List<dynamic>).map((e) => e as String).toList(),
      APITrendData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$APITrendInfoToJson(APITrendInfo instance) =>
    <String, dynamic>{
      'category': instance.category,
      'related': instance.related,
      'data': instance.data,
    };

APITrendData _$APITrendDataFromJson(Map<String, dynamic> json) => APITrendData(
      (json['google'] as List<dynamic>)
          .map((e) => APITrendDataPart.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['twitter'] as List<dynamic>)
          .map((e) => APITrendDataPart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$APITrendDataToJson(APITrendData instance) =>
    <String, dynamic>{
      'google': instance.google,
      'twitter': instance.twitter,
    };

APITrendDataPart _$APITrendDataPartFromJson(Map<String, dynamic> json) =>
    APITrendDataPart(
      DateTime.parse(json['date'] as String),
      (json['hotness'] as num).toDouble(),
    );

Map<String, dynamic> _$APITrendDataPartToJson(APITrendDataPart instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'hotness': instance.hotness,
    };
