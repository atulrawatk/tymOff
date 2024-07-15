// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestEditProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestEditProfile _$RequestEditProfileFromJson(Map<String, dynamic> json) {
  return RequestEditProfile(
    name: json['name'] as String,
    phone: json['phone'] as String,
    gender: json['gender'] as String,
    countryId: json['countryId'] as int,
    Age: json['Age'] as int,
    languageId: json['languageId'] as int,
    address: json['address'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$RequestEditProfileToJson(RequestEditProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'countryId': instance.countryId,
      'languageId': instance.languageId,
      'gender': instance.gender,
      'Age': instance.Age,
      'address': instance.address,
      'email': instance.email,
    };
