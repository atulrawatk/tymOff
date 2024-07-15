import 'package:json_annotation/json_annotation.dart';
part 'ContentSearch.g.dart';


@JsonSerializable(nullable:false)

class ContentSearch
{
  int statusCode ;
  String message;
  bool success;

  List<SearchContentData> data;
  ContentSearch({
    this.statusCode,
    this.message,
    this.success,
    this.data

  });

  factory ContentSearch.fromJson(Map<String, dynamic> json) =>  _$ContentSearchFromJson(json);
  Map<String, dynamic> toJson() => _$ContentSearchToJson(this);

}
@JsonSerializable(nullable: false)

class SearchContentData
{

  int id;
  String contentTitle;
  int typeId;
  String contentValue;
  String contentUrl;
  String modifiedTime;
  String contentStatus;
  int viewCount;
  int likeCount;
  int dislikeCount;
  int favCount;
  int downloadCount;
  int reportCount;

  SearchContentData ({
    this.id,
    this.contentTitle,
    this.typeId,
    this.contentValue,
    this.contentUrl,
    this.modifiedTime,
    this.contentStatus,
    this.viewCount,
    this.likeCount,
    this.dislikeCount,
    this.favCount,
    this.downloadCount,
    this.reportCount,


  });

  factory SearchContentData.fromJson(Map<String, dynamic> json) =>  _$SearchContentDataFromJson(json);
  Map<String, dynamic> toJson() => _$SearchContentDataToJson(this);
}


