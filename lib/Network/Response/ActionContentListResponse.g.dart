// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActionContentListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionContentListResponse _$ActionContentListResponseFromJson(
    Map<String, dynamic> json) {
  return ActionContentListResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    totalElements: json['totalElements'] as int,
    totalPages: json['totalPages'] as int,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : ActionContentData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    lastUpdatedTime: json['lastUpdatedTime'] as int,
  );
}

Map<String, dynamic> _$ActionContentListResponseToJson(
        ActionContentListResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'data': instance.data,
      'lastUpdatedTime': instance.lastUpdatedTime,
    };

ActionContentData _$ActionContentDataFromJson(Map<String, dynamic> json) {
  return ActionContentData(
    id: json['id'] as int,
    contentTitle: json['contentTitle'] as String,
    isDeleted: json['isDeleted'] as bool,
    typeId: json['typeId'] as int,
    contentValue: json['contentValue'] as String,
    contentUrl: (json['contentUrl'] as List)
        ?.map((e) => e == null
            ? null
            : ContentUrlData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    contentStatus: json['contentStatus'] as String,
    isLike: json['isLike'] as bool,
    isFavorite: json['isFavorite'] as bool,
    viewCount: json['viewCount'] as int,
    likeCount: json['likeCount'] as int,
    dislikeCount: json['dislikeCount'] as int,
    favCount: json['favCount'] as int,
    downloadCount: json['downloadCount'] as int,
    reportCount: json['reportCount'] as int,
    sharingUrl: json['sharingUrl'] as String,
  );
}

Map<String, dynamic> _$ActionContentDataToJson(ActionContentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentTitle': instance.contentTitle,
      'typeId': instance.typeId,
      'contentValue': instance.contentValue,
      'isDeleted': instance.isDeleted,
      'contentUrl': instance.contentUrl,
      'contentStatus': instance.contentStatus,
      'isLike': instance.isLike,
      'isFavorite': instance.isFavorite,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'favCount': instance.favCount,
      'downloadCount': instance.downloadCount,
      'reportCount': instance.reportCount,
      'sharingUrl': instance.sharingUrl,
    };

ContentUrlData _$ContentUrlDataFromJson(Map<String, dynamic> json) {
  return ContentUrlData(
    id: json['id'] as int,
    url: json['url'] as String,
    dimensions: json['dimensions'] as String,
    thumbnailImage: json['thumbnailImage'] as String,
    height: (json['height'] as num)?.toDouble(),
    width: (json['width'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ContentUrlDataToJson(ContentUrlData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'dimensions': instance.dimensions,
      'height': instance.height,
      'width': instance.width,
      'thumbnailImage': instance.thumbnailImage,
    };
