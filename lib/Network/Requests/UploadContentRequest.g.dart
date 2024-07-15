// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UploadContentRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadContentRequest _$UploadContentRequestFromJson(
    Map<String, dynamic> json) {
  return UploadContentRequest(
    dataList: (json['dataList'] as List)
        .map((e) => RequestUploadDataTemp.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UploadContentRequestToJson(
        UploadContentRequest instance) =>
    <String, dynamic>{
      'dataList': instance.dataList,
    };

RequestUploadDataTemp _$RequestUploadDataTempFromJson(
    Map<String, dynamic> json) {
  return RequestUploadDataTemp(
    localId: json['localId'] as String,
    contentId: json['contentId'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    url: json['url'] as String,
    typeId: json['typeId'] as int,
    languageId: (json['languageId'] as List).map((e) => e as int).toList(),
    catId: (json['catId'] as List).map((e) => e as int).toList(),
    isCreated: json['isCreated'] as bool,
  );
}

Map<String, dynamic> _$RequestUploadDataTempToJson(
        RequestUploadDataTemp instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'contentId': instance.contentId,
      'title': instance.title,
      'url': instance.url,
      'description': instance.description,
      'typeId': instance.typeId,
      'languageId': instance.languageId,
      'catId': instance.catId,
      'isCreated': instance.isCreated,
    };
