import 'package:json_annotation/json_annotation.dart';
part 'ContentDefault.g.dart';


@JsonSerializable(nullable:false)

class ContentDefault
{
  int statusCode ;
  String message;
  bool success;

  List<ContentDefaultData> data;
  ContentDefault({
    this.statusCode,
    this.message,
    this.success,
    this.data

  });

  factory ContentDefault.fromJson(Map<String, dynamic> json) =>  _$ContentDefaultFromJson(json);
  Map<String, dynamic> toJson() => _$ContentDefaultToJson(this);

}
@JsonSerializable(nullable: false)

class ContentDefaultData
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

  ContentDefaultData ({
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

  factory ContentDefaultData.fromJson(Map<String, dynamic> json) =>  _$ContentDefaultDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContentDefaultDataToJson(this);
}


