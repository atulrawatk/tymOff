// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentDefault.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentDefault _$ContentDefaultFromJson(Map<String, dynamic> json) {
  return ContentDefault(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: (json['data'] as List)
        .map((e) => ContentDefaultData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ContentDefaultToJson(ContentDefault instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

ContentDefaultData _$ContentDefaultDataFromJson(Map<String, dynamic> json) {
  return ContentDefaultData(
    id: json['id'] as int,
    contentTitle: json['contentTitle'] as String,
    typeId: json['typeId'] as int,
    contentValue: json['contentValue'] as String,
    contentUrl: json['contentUrl'] as String,
    modifiedTime: json['modifiedTime'] as String,
    contentStatus: json['contentStatus'] as String,
    viewCount: json['viewCount'] as int,
    likeCount: json['likeCount'] as int,
    dislikeCount: json['dislikeCount'] as int,
    favCount: json['favCount'] as int,
    downloadCount: json['downloadCount'] as int,
    reportCount: json['reportCount'] as int,
  );
}

Map<String, dynamic> _$ContentDefaultDataToJson(ContentDefaultData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentTitle': instance.contentTitle,
      'typeId': instance.typeId,
      'contentValue': instance.contentValue,
      'contentUrl': instance.contentUrl,
      'modifiedTime': instance.modifiedTime,
      'contentStatus': instance.contentStatus,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'favCount': instance.favCount,
      'downloadCount': instance.downloadCount,
      'reportCount': instance.reportCount,
    };
