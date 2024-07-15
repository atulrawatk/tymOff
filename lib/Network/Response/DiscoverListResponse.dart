import 'package:json_annotation/json_annotation.dart';
part 'DiscoverListResponse.g.dart';

@JsonSerializable(nullable: true)

class DiscoverListResponse{
  int statusCode;
  String message;
  DiscoverData data;
  bool success;

  DiscoverListResponse({
    this.statusCode,
    this.message,
    this.data,
    this.success
});

  factory DiscoverListResponse.fromJson(Map<String, dynamic> json) =>  _$DiscoverListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverListResponseToJson(this);

}



@JsonSerializable(nullable: true)

class DiscoverData{
  List<DiscoverListData> discover;

  DiscoverData({
    this.discover
});

  factory DiscoverData.fromJson(Map<String, dynamic> json) =>  _$DiscoverDataFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverDataToJson(this);

}

@JsonSerializable(nullable: true)

class DiscoverListData{
  int id;
  String name;
  String message;
  List<DiscoverContentList> contentList;

  DiscoverListData({
    this.id,
    this.name,
    this.message,
    this.contentList
});

  factory DiscoverListData.fromJson(Map<String, dynamic> json) =>  _$DiscoverListDataFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverListDataToJson(this);

}

@JsonSerializable(nullable: true)
class DiscoverContentList{
  int id;
  int typeId;
  List<ContentUrl> contentUrl;

  DiscoverContentList({
    this.id,
    this.typeId,
    this.contentUrl
});

  factory DiscoverContentList.fromJson(Map<String, dynamic> json) =>  _$DiscoverContentListFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverContentListToJson(this);

}

@JsonSerializable(nullable: true)
class ContentUrl{
  int id;
  String url;
  String dimensions;
  String thumbnailImage;

  ContentUrl({
    this.id,
    this.url,
    this.dimensions,
    this.thumbnailImage,
});

  factory ContentUrl.fromJson(Map<String, dynamic> json) =>  _$ContentUrlFromJson(json);
  Map<String, dynamic> toJson() => _$ContentUrlToJson(this);

}