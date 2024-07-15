// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentSearch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentSearch _$ContentSearchFromJson(Map<String, dynamic> json) {
  return ContentSearch(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: (json['data'] as List)
        .map((e) => SearchContentData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ContentSearchToJson(ContentSearch instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

SearchContentData _$SearchContentDataFromJson(Map<String, dynamic> json) {
  return SearchContentData(
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

Map<String, dynamic> _$SearchContentDataToJson(SearchContentData instance) =>
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
