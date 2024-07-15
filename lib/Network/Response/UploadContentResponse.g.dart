// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UploadContentResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadContentResponse _$UploadContentResponseFromJson(
    Map<String, dynamic> json) {
  return UploadContentResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: json['data'] == null
        ? null
        : UploadData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UploadContentResponseToJson(
        UploadContentResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

UploadData _$UploadDataFromJson(Map<String, dynamic> json) {
  return UploadData(
    dataList: (json['dataList'] as List)
        ?.map((e) => e == null
            ? null
            : ResponseUploadContentData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UploadDataToJson(UploadData instance) =>
    <String, dynamic>{
      'dataList': instance.dataList,
    };

ResponseUploadContentData _$ResponseUploadContentDataFromJson(
    Map<String, dynamic> json) {
  return ResponseUploadContentData(
    localId: json['localId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    typeId: json['typeId'] as int,
    languageId: (json['languageId'] as List)?.map((e) => e as String)?.toList(),
    catId: (json['catId'] as List)?.map((e) => e as String)?.toList(),
    isCreated: json['isCreated'] as bool,
    contentId: json['contentId'] as int,
  );
}

Map<String, dynamic> _$ResponseUploadContentDataToJson(
        ResponseUploadContentData instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'title': instance.title,
      'description': instance.description,
      'typeId': instance.typeId,
      'languageId': instance.languageId,
      'catId': instance.catId,
      'isCreated': instance.isCreated,
      'contentId': instance.contentId,
    };
