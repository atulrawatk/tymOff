// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestFilterContent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestFilterContent _$RequestFilterContentFromJson(Map<String, dynamic> json) {
  return RequestFilterContent(
    formatsList: (json['formatsList'] as List).map((e) => e as int).toList(),
    genresList: (json['genresList'] as List).map((e) => e as int).toList(),
    contentSearch: json['contentSearch'] as String,
    discoverId: json['discoverId'] as String,
  );
}

Map<String, dynamic> _$RequestFilterContentToJson(
        RequestFilterContent instance) =>
    <String, dynamic>{
      'formatsList': instance.formatsList,
      'genresList': instance.genresList,
      'contentSearch': instance.contentSearch,
      'discoverId': instance.discoverId,
    };
