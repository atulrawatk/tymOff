// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentDetailResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentDetailResponse _$ContentDetailResponseFromJson(
    Map<String, dynamic> json) {
  return ContentDetailResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: ActionContentData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ContentDetailResponseToJson(
        ContentDetailResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };
