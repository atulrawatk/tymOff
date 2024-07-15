// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfilePutRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePutRequest _$ProfilePutRequestFromJson(Map<String, dynamic> json) {
  return ProfilePutRequest(
    name: json['name'] as String,
    phone: json['phone'] as String,
    countryId: json['countryId'] as int,
    languageId: json['languageId'] as int,
    gender: json['gender'] as String,
    age: json['age'] as int,
  );
}

Map<String, dynamic> _$ProfilePutRequestToJson(ProfilePutRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'countryId': instance.countryId,
      'languageId': instance.languageId,
      'gender': instance.gender,
      'age': instance.age,
    };
