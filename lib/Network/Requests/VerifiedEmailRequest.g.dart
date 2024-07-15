// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifiedEmailRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiedEmailRequest _$VerifiedEmailRequestFromJson(Map<String, dynamic> json) {
  return VerifiedEmailRequest(
    email: json['email'] as String,
    flowType: json['flowType'] as String,
    socialType: json['socialType'] as String,
  );
}

Map<String, dynamic> _$VerifiedEmailRequestToJson(
        VerifiedEmailRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'flowType': instance.flowType,
      'socialType': instance.socialType,
    };
