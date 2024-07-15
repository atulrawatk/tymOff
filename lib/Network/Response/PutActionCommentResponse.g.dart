// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PutActionCommentResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutActionCommentResponse _$PutActionCommentResponseFromJson(
    Map<String, dynamic> json) {
  return PutActionCommentResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
  )..data = json['data'] == null
      ? null
      : CommentPullDataList.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PutActionCommentResponseToJson(
        PutActionCommentResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };
