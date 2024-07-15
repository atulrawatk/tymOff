// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LogOutResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogOutResponse _$LogOutResponseFromJson(Map<String, dynamic> json) {
  return LogOutResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$LogOutResponseToJson(LogOutResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
