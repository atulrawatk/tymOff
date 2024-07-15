// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifiedOtpResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiedOtpResponse _$VerifiedOtpResponseFromJson(Map<String, dynamic> json) {
  return VerifiedOtpResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    data: VerifiedOtpResult.fromJson(json['data'] as Map<String, dynamic>),
  )..success = json['success'] as bool;
}

Map<String, dynamic> _$VerifiedOtpResponseToJson(
        VerifiedOtpResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
      'success': instance.success,
    };

VerifiedOtpResult _$VerifiedOtpResultFromJson(Map<String, dynamic> json) {
  return VerifiedOtpResult(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    age: json['age'] as int,
    address: json['address'] as String,
    picUrl: json['picUrl'] as String,
    countryId: json['countryId'] as int,
    languageId: json['languageId'] as int,
    addedTs: json['addedTs'] as String,
    modifiedTime: json['modifiedTime'] as String,
    socialType: json['socialType'] as String,
    flowType: json['flowType'] as String,
    isOtpVerified: json['isOtpVerified'] as bool,
  );
}

Map<String, dynamic> _$VerifiedOtpResultToJson(VerifiedOtpResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'address': instance.address,
      'picUrl': instance.picUrl,
      'countryId': instance.countryId,
      'languageId': instance.languageId,
      'addedTs': instance.addedTs,
      'modifiedTime': instance.modifiedTime,
      'socialType': instance.socialType,
      'flowType': instance.flowType,
      'isOtpVerified': instance.isOtpVerified,
    };
