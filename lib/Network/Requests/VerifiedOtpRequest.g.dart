// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifiedOtpRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiedOtpRequest _$VerifiedOtpRequestFromJson(Map<String, dynamic> json) {
  return VerifiedOtpRequest(
    email: json['email'] as String,
    otp: json['otp'] as String,
  );
}

Map<String, dynamic> _$VerifiedOtpRequestToJson(VerifiedOtpRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
    };
