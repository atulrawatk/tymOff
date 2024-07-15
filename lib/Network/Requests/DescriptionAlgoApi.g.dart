// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DescriptionAlgoApi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescriptionAlgoApi _$DescriptionAlgoApiFromJson(Map<String, dynamic> json) {
  return DescriptionAlgoApi(
    result: json['result'] == null
        ? null
        : DescriptionAlgoApiResult.fromJson(
            json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DescriptionAlgoApiToJson(DescriptionAlgoApi instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

DescriptionAlgoApiResult _$DescriptionAlgoApiResultFromJson(
    Map<String, dynamic> json) {
  return DescriptionAlgoApiResult(
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    metadata: json['metadata'] == null
        ? null
        : DescriptionAlgoApiMetadata.fromJson(
            json['metadata'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DescriptionAlgoApiResultToJson(
        DescriptionAlgoApiResult instance) =>
    <String, dynamic>{
      'images': instance.images,
      'metadata': instance.metadata,
    };

DescriptionAlgoApiMetadata _$DescriptionAlgoApiMetadataFromJson(
    Map<String, dynamic> json) {
  return DescriptionAlgoApiMetadata(
    statusCode: json['statusCode'] as int,
    summary: json['summary'] as String,
    title: json['title'] as String,
    thumbnail: json['thumbnail'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$DescriptionAlgoApiMetadataToJson(
        DescriptionAlgoApiMetadata instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'summary': instance.summary,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
    };
