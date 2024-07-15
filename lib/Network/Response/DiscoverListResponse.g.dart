// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DiscoverListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverListResponse _$DiscoverListResponseFromJson(Map<String, dynamic> json) {
  return DiscoverListResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : DiscoverData.fromJson(json['data'] as Map<String, dynamic>),
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$DiscoverListResponseToJson(
        DiscoverListResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
      'success': instance.success,
    };

DiscoverData _$DiscoverDataFromJson(Map<String, dynamic> json) {
  return DiscoverData(
    discover: (json['discover'] as List)
        ?.map((e) => e == null
            ? null
            : DiscoverListData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DiscoverDataToJson(DiscoverData instance) =>
    <String, dynamic>{
      'discover': instance.discover,
    };

DiscoverListData _$DiscoverListDataFromJson(Map<String, dynamic> json) {
  return DiscoverListData(
    id: json['id'] as int,
    name: json['name'] as String,
    message: json['message'] as String,
    contentList: (json['contentList'] as List)
        ?.map((e) => e == null
            ? null
            : DiscoverContentList.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DiscoverListDataToJson(DiscoverListData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'message': instance.message,
      'contentList': instance.contentList,
    };

DiscoverContentList _$DiscoverContentListFromJson(Map<String, dynamic> json) {
  return DiscoverContentList(
    id: json['id'] as int,
    typeId: json['typeId'] as int,
    contentUrl: (json['contentUrl'] as List)
        ?.map((e) =>
            e == null ? null : ContentUrl.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DiscoverContentListToJson(
        DiscoverContentList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeId': instance.typeId,
      'contentUrl': instance.contentUrl,
    };

ContentUrl _$ContentUrlFromJson(Map<String, dynamic> json) {
  return ContentUrl(
    id: json['id'] as int,
    url: json['url'] as String,
    dimensions: json['dimensions'] as String,
    thumbnailImage: json['thumbnailImage'] as String,
  );
}

Map<String, dynamic> _$ContentUrlToJson(ContentUrl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'dimensions': instance.dimensions,
      'thumbnailImage': instance.thumbnailImage,
    };
