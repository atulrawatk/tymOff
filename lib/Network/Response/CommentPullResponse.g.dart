// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentPullResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentPullResponse _$CommentPullResponseFromJson(Map<String, dynamic> json) {
  return CommentPullResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    totalPages: json['totalPages'] as int,
    totalElements: json['totalElements'] as int,
    data: json['data'] == null
        ? null
        : CommentPullData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommentPullResponseToJson(
        CommentPullResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'data': instance.data,
    };

CommentPullData _$CommentPullDataFromJson(Map<String, dynamic> json) {
  return CommentPullData(
    dataList: (json['dataList'] as List)
        ?.map((e) => e == null
            ? null
            : CommentPullDataList.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommentPullDataToJson(CommentPullData instance) =>
    <String, dynamic>{
      'dataList': instance.dataList,
    };

CommentPullDataList _$CommentPullDataListFromJson(Map<String, dynamic> json) {
  return CommentPullDataList(
    parentId: json['parentId'] as int,
    contentId: json['contentId'] as int,
    comments: json['comments'] as String,
    commentTime: json['commentTime'] as String,
    user: json['user'] == null
        ? null
        : CommentUserData.fromJson(json['user'] as Map<String, dynamic>),
    commentText: json['commentText'] as String,
  );
}

Map<String, dynamic> _$CommentPullDataListToJson(
        CommentPullDataList instance) =>
    <String, dynamic>{
      'parentId': instance.parentId,
      'contentId': instance.contentId,
      'comments': instance.comments,
      'commentTime': instance.commentTime,
      'user': instance.user,
      'commentText': instance.commentText,
    };

CommentUserData _$CommentUserDataFromJson(Map<String, dynamic> json) {
  return CommentUserData(
    id: json['id'] as int,
    name: json['name'] as String,
    phone: json['phone'] as String,
    gender: json['gender'] as String,
    picUrl: json['picUrl'] as String,
  );
}

Map<String, dynamic> _$CommentUserDataToJson(CommentUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'gender': instance.gender,
      'picUrl': instance.picUrl,
    };
