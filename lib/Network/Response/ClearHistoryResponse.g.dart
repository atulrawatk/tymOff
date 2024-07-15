// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClearHistoryResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClearHistoryResponse _$ClearHistoryResponseFromJson(Map<String, dynamic> json) {
  return ClearHistoryResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$ClearHistoryResponseToJson(
        ClearHistoryResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
