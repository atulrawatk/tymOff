// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeletePostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletePostResponse _$DeletePostResponseFromJson(Map<String, dynamic> json) {
  return DeletePostResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$DeletePostResponseToJson(DeletePostResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
