// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) {
  return FeedbackResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$FeedbackResponseToJson(FeedbackResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };
