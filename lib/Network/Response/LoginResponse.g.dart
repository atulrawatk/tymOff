// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

LoginResponseData _$LoginResponseDataFromJson(Map<String, dynamic> json) {
  return LoginResponseData(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    token: json['token'] as String,
    isOtpVerified: json['isOtpVerified'] as bool,
  )
    ..gender = json['gender'] as String
    ..age = json['age'] as int
    ..address = json['address'] as String
    ..picUrl = json['picUrl'] as String
    ..countryId = json['countryId'] as int
    ..languageId = json['languageId'] as int
    ..addedTs = json['addedTs'] as String
    ..modifiedTime = json['modifiedTime'] as String
    ..socialType = json['socialType'] as String
    ..flowType = json['flowType'] as String;
}

Map<String, dynamic> _$LoginResponseDataToJson(LoginResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'age': instance.age,
      'address': instance.address,
      'picUrl': instance.picUrl,
      'countryId': instance.countryId,
      'languageId': instance.languageId,
      'addedTs': instance.addedTs,
      'modifiedTime': instance.modifiedTime,
      'socialType': instance.socialType,
      'flowType': instance.flowType,
      'token': instance.token,
      'isOtpVerified': instance.isOtpVerified,
    };
