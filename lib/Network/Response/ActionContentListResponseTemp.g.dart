// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActionContentListResponseTemp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionContentListResponseTemp _$ActionContentListResponseTempFromJson(
    Map<String, dynamic> json) {
  return ActionContentListResponseTemp(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : ActionContentDataTemp.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActionContentListResponseTempToJson(
        ActionContentListResponseTemp instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

ActionContentDataTemp _$ActionContentDataTempFromJson(
    Map<String, dynamic> json) {
  return ActionContentDataTemp(
    totalRecords: json['totalRecords'] as int,
    userList: (json['userList'] as List)
        ?.map((e) => e == null
            ? null
            : ActionContentDataUserTemp.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActionContentDataTempToJson(
        ActionContentDataTemp instance) =>
    <String, dynamic>{
      'totalRecords': instance.totalRecords,
      'userList': instance.userList,
    };

ActionContentDataUserTemp _$ActionContentDataUserTempFromJson(
    Map<String, dynamic> json) {
  return ActionContentDataUserTemp(
    id: json['id'] as int,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    userStatus: json['userStatus'] as String,
    bio: json['bio'] as String,
    country: json['country'] as String,
    countryName: json['countryName'] as String,
    image: json['image'] as String,
    thumbnailImage: json['thumbnailImage'] as String,
  );
}

Map<String, dynamic> _$ActionContentDataUserTempToJson(
        ActionContentDataUserTemp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'userStatus': instance.userStatus,
      'bio': instance.bio,
      'country': instance.country,
      'countryName': instance.countryName,
      'image': instance.image,
      'thumbnailImage': instance.thumbnailImage,
    };
