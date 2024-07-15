// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FCMNotficationPayloadEvent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FCMNotficationPayloadEvent _$FCMNotficationPayloadEventFromJson(
    Map<String, dynamic> json) {
  return FCMNotficationPayloadEvent(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    notificationType: json['notificationType'] as String,
    discoverData: json['discoverData'] == null
        ? null
        : DiscoverListData.fromJson(
            json['discoverData'] as Map<String, dynamic>),
    contentMain: json['contentMain'] == null
        ? null
        : ActionContentData.fromJson(
            json['contentMain'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FCMNotficationPayloadEventToJson(
        FCMNotficationPayloadEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'notificationType': instance.notificationType,
      'discoverData': instance.discoverData,
      'contentMain': instance.contentMain,
    };
