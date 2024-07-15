// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FCMNotficationPayload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FCMNotficationPayload _$FCMNotficationPayloadFromJson(
    Map<String, dynamic> json) {
  return FCMNotficationPayload(
    noti_key: json['noti_key'] as String,
    noti_code: json['noti_code'] as String,
    noti_type: json['noti_type'] as String,
    noti_data: json['noti_data'] as String,
  );
}

Map<String, dynamic> _$FCMNotficationPayloadToJson(
        FCMNotficationPayload instance) =>
    <String, dynamic>{
      'noti_key': instance.noti_key,
      'noti_code': instance.noti_code,
      'noti_type': instance.noti_type,
      'noti_data': instance.noti_data,
    };
