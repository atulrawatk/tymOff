// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackRequest _$FeedbackRequestFromJson(Map<String, dynamic> json) {
  return FeedbackRequest(
    subject: json['subject'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$FeedbackRequestToJson(FeedbackRequest instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'title': instance.title,
      'description': instance.description,
    };
