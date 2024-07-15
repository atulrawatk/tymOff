// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IpCountryResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpCountryResponse _$IpCountryResponseFromJson(Map<String, dynamic> json) {
  return IpCountryResponse(
    area: json['area'] as String,
    usagetype: json['usagetype'] as String,
    op: json['op'] as String,
    ccode: json['ccode'] as String,
    code: json['code'] as String,
    city: json['city'] as String,
    lastUpdatedTime: json['lastUpdatedTime'] as int,
  );
}

Map<String, dynamic> _$IpCountryResponseToJson(IpCountryResponse instance) =>
    <String, dynamic>{
      'area': instance.area,
      'usagetype': instance.usagetype,
      'op': instance.op,
      'ccode': instance.ccode,
      'code': instance.code,
      'city': instance.city,
      'lastUpdatedTime': instance.lastUpdatedTime,
    };
