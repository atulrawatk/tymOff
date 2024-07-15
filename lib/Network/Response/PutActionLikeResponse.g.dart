// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PutActionLikeResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutActionLikeResponse _$PutActionLikeResponseFromJson(
    Map<String, dynamic> json) {
  return PutActionLikeResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$PutActionLikeResponseToJson(
        PutActionLikeResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
