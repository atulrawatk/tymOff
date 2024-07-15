// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetActionListLikeResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActionListLikeResponse _$GetActionListLikeResponseFromJson(
    Map<String, dynamic> json) {
  return GetActionListLikeResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$GetActionListLikeResponseToJson(
        GetActionListLikeResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
