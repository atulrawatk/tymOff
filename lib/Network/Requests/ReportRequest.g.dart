// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReportRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) {
  return ReportRequest(
    contentId: json['contentId'] as String,
    reportId: json['reportId'] as String,
    reportText: json['reportText'] as String,
  );
}

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'reportId': instance.reportId,
      'reportText': instance.reportText,
    };
