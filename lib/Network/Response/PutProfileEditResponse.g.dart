// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PutProfileEditResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutProfileEditResponse _$PutProfileEditResponseFromJson(
    Map<String, dynamic> json) {
  return PutProfileEditResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$PutProfileEditResponseToJson(
        PutProfileEditResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
