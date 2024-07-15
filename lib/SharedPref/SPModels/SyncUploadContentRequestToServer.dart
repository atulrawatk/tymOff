import 'package:json_annotation/json_annotation.dart';

import 'DraftUploadContentRequestToServer.dart';

part 'SyncUploadContentRequestToServer.g.dart';

@JsonSerializable(nullable: true)
class SyncUploadContentRequestToServer {
  Map<String, RequestUploadDataToServer> data = Map();

  SyncUploadContentRequestToServer({
    this.data,
  }) {
    if (data == null) {
      data = Map();
    }
  }

  factory SyncUploadContentRequestToServer.fromJson(Map<String, dynamic> json) =>
      _$SyncUploadContentRequestToServerFromJson(json);

  Map<String, dynamic> toJson() => _$SyncUploadContentRequestToServerToJson(this);
}

@JsonSerializable(nullable: true)
class RequestUploadDataToServer {

  int contentId;
  int typeId;
  String taskId;
  RequestDraftUploadData requestDraftUploadData;
  bool isCreated;
  bool isUploaded;

  int uploadTaskStatus;
  int totalProgressOfUploadFiles;
  int totalSizeOfUploadFiles;

  RequestUploadDataToServer({
    this.contentId,
    this.typeId,
    this.isCreated,
    this.isUploaded,
    this.totalProgressOfUploadFiles,
    this.totalSizeOfUploadFiles,
    this.taskId,
  });

  factory RequestUploadDataToServer.fromJson(Map<String, dynamic> json) =>
      _$RequestUploadDataToServerFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUploadDataToServerToJson(this);

  String getUID() => contentId.toString();

  String getTaskId() => taskId;
}
