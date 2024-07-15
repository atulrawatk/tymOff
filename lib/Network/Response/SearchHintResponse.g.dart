// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SearchHintResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHintResponse _$SearchHintResponseFromJson(Map<String, dynamic> json) {
  return SearchHintResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    totalPages: json['totalPages'] as int,
    totalElements: json['totalElements'] as int,
    data: (json['data'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$SearchHintResponseToJson(SearchHintResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'data': instance.data,
    };
