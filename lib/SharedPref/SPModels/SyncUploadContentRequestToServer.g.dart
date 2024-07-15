// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SyncUploadContentRequestToServer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncUploadContentRequestToServer _$SyncUploadContentRequestToServerFromJson(
    Map<String, dynamic> json) {
  return SyncUploadContentRequestToServer(
    data: (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : RequestUploadDataToServer.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$SyncUploadContentRequestToServerToJson(
        SyncUploadContentRequestToServer instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

RequestUploadDataToServer _$RequestUploadDataToServerFromJson(
    Map<String, dynamic> json) {
  return RequestUploadDataToServer(
    contentId: json['contentId'] as int,
    typeId: json['typeId'] as int,
    isCreated: json['isCreated'] as bool,
    isUploaded: json['isUploaded'] as bool,
    totalProgressOfUploadFiles: json['totalProgressOfUploadFiles'] as int,
    totalSizeOfUploadFiles: json['totalSizeOfUploadFiles'] as int,
    taskId: json['taskId'] as String,
  )
    ..requestDraftUploadData = json['requestDraftUploadData'] == null
        ? null
        : RequestDraftUploadData.fromJson(
            json['requestDraftUploadData'] as Map<String, dynamic>)
    ..uploadTaskStatus = json['uploadTaskStatus'] as int;
}

Map<String, dynamic> _$RequestUploadDataToServerToJson(
        RequestUploadDataToServer instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'typeId': instance.typeId,
      'taskId': instance.taskId,
      'requestDraftUploadData': instance.requestDraftUploadData,
      'isCreated': instance.isCreated,
      'isUploaded': instance.isUploaded,
      'uploadTaskStatus': instance.uploadTaskStatus,
      'totalProgressOfUploadFiles': instance.totalProgressOfUploadFiles,
      'totalSizeOfUploadFiles': instance.totalSizeOfUploadFiles,
    };
