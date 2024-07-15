import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';

part 'ActionContentListResponse.g.dart';

@JsonSerializable(nullable: true)
class ActionContentListResponse {
  int statusCode;

  String message;
  bool success;
  int totalElements;
  int totalPages;
  List<ActionContentData> data;
  int lastUpdatedTime;

  ActionContentListResponse(
      {this.statusCode,
      this.message,
      this.success,
      this.totalElements,
      this.totalPages,
      this.data,
      this.lastUpdatedTime});

  factory ActionContentListResponse.fromJson(Map<String, dynamic> json) =>
      _$ActionContentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActionContentListResponseToJson(this);
}

@JsonSerializable(nullable: true)
class ActionContentData {
  int id;
  String contentTitle;
  int typeId;
  String contentValue;
  bool isDeleted;
  List<ContentUrlData> contentUrl;

  //String modifiedTime;
  String contentStatus;
  bool isLike;
  bool isFavorite;
  int viewCount;
  int likeCount;
  int dislikeCount;
  int favCount;
  int downloadCount;
  int reportCount;
  String sharingUrl;

  ActionContentData({
    this.id,
    this.contentTitle,
    this.isDeleted,
    this.typeId,
    this.contentValue,
    this.contentUrl,
    // this.modifiedTime,
    this.contentStatus,
    this.isLike,
    this.isFavorite,
    this.viewCount,
    this.likeCount,
    this.dislikeCount,
    this.favCount,
    this.downloadCount,
    this.reportCount,
    this.sharingUrl,
  });

  factory ActionContentData.fromJson(Map<String, dynamic> json) =>
      _$ActionContentDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActionContentDataToJson(this);

  ActionContentData clone(ActionContentData cloneTo) {
    cloneTo.id = id;
    cloneTo.contentTitle = contentTitle;
    cloneTo.typeId = typeId;
    cloneTo.contentValue = contentValue;
    cloneTo.contentUrl = contentUrl;
    cloneTo.contentStatus = contentStatus;
    cloneTo.isLike = isLike;
    cloneTo.isFavorite = isFavorite;
    cloneTo.viewCount = viewCount;
    cloneTo.likeCount = likeCount;
    cloneTo.dislikeCount = dislikeCount;
    cloneTo.favCount = favCount;
    cloneTo.downloadCount = downloadCount;
    cloneTo.reportCount = reportCount;

    EventBusUtils.eventContentInfoUpdate(cloneTo);

    return cloneTo;
  }
}

@JsonSerializable(nullable: true)
class ContentUrlData {
  int id;
  String url;
  String dimensions;
  double height = 100.0;
  double width = 150.0;
  String thumbnailImage;

  ContentUrlData({this.id, this.url, this.dimensions, this.thumbnailImage, this.height, this.width});

  factory ContentUrlData.fromJson(Map<String, dynamic> json) =>
      _$ContentUrlDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContentUrlDataToJson(this);
}
