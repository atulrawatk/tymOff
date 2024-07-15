// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfilePullResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileGetResponse _$ProfileGetResponseFromJson(Map<String, dynamic> json) {
  return ProfileGetResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: ProfileGetData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileGetResponseToJson(ProfileGetResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

ProfileGetData _$ProfileGetDataFromJson(Map<String, dynamic> json) {
  return ProfileGetData(
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    modifiedTime: json['modifiedTime'] as String,
    age: json['age'] as int,
    gender: json['gender'] as String,
    languageId: json['languageId'] as int,
    countryId: json['countryId'] as int,
    isOtpVerified: json['isOtpVerified'] as bool,
    id: json['id'] as int,
    addedTs: json['addedTs'] as String,
  );
}

Map<String, dynamic> _$ProfileGetDataToJson(ProfileGetData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'modifiedTime': instance.modifiedTime,
      'gender': instance.gender,
      'id': instance.id,
      'age': instance.age,
      'countryId': instance.countryId,
      'languageId': instance.languageId,
      'addedTs': instance.addedTs,
      'isOtpVerified': instance.isOtpVerified,
    };
