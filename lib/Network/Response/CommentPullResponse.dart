import 'package:json_annotation/json_annotation.dart';
part 'CommentPullResponse.g.dart';


@JsonSerializable(nullable: true)

class CommentPullResponse
{
  int statusCode ;
  String message;
  bool success;
  int totalPages;
  int totalElements;
  CommentPullData data;

  CommentPullResponse({
    this.statusCode,
    this.message,
    this.success,
    this.totalPages,
    this.totalElements,
    this.data
  });
  factory CommentPullResponse.fromJson(Map<String, dynamic> json) =>  _$CommentPullResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommentPullResponseToJson(this);

}
@JsonSerializable(nullable: true)

class CommentPullData
{

  List<CommentPullDataList> dataList;


  CommentPullData ({
    this.dataList,
  });
  factory CommentPullData.fromJson(Map<String, dynamic> json) =>  _$CommentPullDataFromJson(json);
  Map<String, dynamic> toJson() => _$CommentPullDataToJson(this);
}

@JsonSerializable(nullable: true)
class CommentPullDataList{

  int parentId;
  int contentId;
  String comments;
  String commentTime;
  CommentUserData user;
  String commentText;

  CommentPullDataList ({
    this.parentId,
    this.contentId,
    this.comments,
    this.commentTime,
    this.user,
    this.commentText,
  });

  factory CommentPullDataList.fromJson(Map<String, dynamic> json) =>  _$CommentPullDataListFromJson(json);
  Map<String, dynamic> toJson() => _$CommentPullDataListToJson(this);

}

@JsonSerializable(nullable: true)
class CommentUserData{
  int id;
  String name;
  String phone;
  String gender;
  String picUrl;

  CommentUserData({
    this.id,
    this.name,
    this.phone,
    this.gender,
    this.picUrl
});

  factory CommentUserData.fromJson(Map<String, dynamic> json) =>  _$CommentUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$CommentUserDataToJson(this);

}


