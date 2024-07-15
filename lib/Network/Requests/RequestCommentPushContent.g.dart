// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestCommentPushContent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestCommentPushContent _$RequestCommentPushContentFromJson(
    Map<String, dynamic> json) {
  return RequestCommentPushContent(
    parentId: json['parentId'] as String,
    contentId: json['contentId'] as String,
    userId: json['userId'] as String,
    comments: json['comments'] as String,
  );
}

Map<String, dynamic> _$RequestCommentPushContentToJson(
        RequestCommentPushContent instance) =>
    <String, dynamic>{
      'parentId': instance.parentId,
      'contentId': instance.contentId,
      'userId': instance.userId,
      'comments': instance.comments,
    };
