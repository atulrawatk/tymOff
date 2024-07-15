import 'dart:io';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'DraftUploadContentRequestToServer.g.dart';

@JsonSerializable(nullable: true)
class DraftUploadContentRequestToServer {
  Map<String, RequestDraftUploadData> data = Map();

  DraftUploadContentRequestToServer({
    this.data,
  }) {
    if (data == null) {
      data = Map();
    }
  }

  factory DraftUploadContentRequestToServer.fromJson(
          Map<String, dynamic> json) =>
      _$DraftUploadContentRequestToServerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DraftUploadContentRequestToServerToJson(this);
}

@JsonSerializable(nullable: true)
class RequestDraftUploadData {
  String localId;

  String title;
  String description;
  String richTextStory;
  String url;

  Map<int, MetaDataResponseDataCommon> hmSelectedItemsGenre = Map();
  Map<int, MetaDataResponseDataCommon> hmSelectedItemsLanguage = Map();
  Map<String, RequestUploadDataFileInfo> mapOfMediaMetaData = Map();
  String storyData;
  int tempInt;

  UploadUIActive contentType;

  String draftCreatedDateTime =
      DateTime.now().millisecondsSinceEpoch.toString();

  RequestDraftUploadData(
    this.contentType, {
    this.title,
    this.description,
    this.richTextStory,
    this.url,
    this.hmSelectedItemsGenre,
    this.hmSelectedItemsLanguage,
    this.mapOfMediaMetaData,
    this.storyData,
    this.localId,
  }) {
    if (localId == null) {
      localId = Uuid().v1();
    }
    draftCreatedDateTime = DateTime.now().millisecondsSinceEpoch.toString();
  }

  factory RequestDraftUploadData.fromJson(Map<String, dynamic> json) =>
      _$RequestDraftUploadDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDraftUploadDataToJson(this);

  String getUID() => localId;

  String getDescription() => description ?? "";

  List<File> getUploadFileList() {
    List<File> mediaFiles = List();
    mapOfMediaMetaData.forEach((key, fileInfo) {
      File file = File(fileInfo.mediaFilePath);
      mediaFiles.add(file);
    });

    return mediaFiles;
  }
}

@JsonSerializable(nullable: true)
class RequestUploadDataFileInfo {
  List<int> thumbnail;
  String mediaFileName;
  String mediaFilePath;

  RequestUploadDataFileInfo(this.mediaFileName, this.mediaFilePath,
      {this.thumbnail});

  factory RequestUploadDataFileInfo.fromJson(Map<String, dynamic> json) =>
      _$RequestUploadDataFileInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUploadDataFileInfoToJson(this);

  String getUID() => mediaFileName;

  Uint8List getThumbnail() {
    try {
      var thumbnailNew = Uint8List.fromList(thumbnail);
      return thumbnailNew;
    } catch(e){
      return null;
    }
  }

  Future<void> generateThumbnail() async {
    thumbnail =  await VideoThumbnail.thumbnailData(
      video: mediaFilePath,
      imageFormat: ImageFormat.JPEG,
      maxHeightOrWidth: 600,
      quality: 100,
    );

    return;
  }
}
