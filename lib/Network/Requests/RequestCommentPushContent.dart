import 'package:json_annotation/json_annotation.dart';
part 'RequestCommentPushContent.g.dart';


@JsonSerializable(nullable:false)
class RequestCommentPushContent {
  String parentId;
  String contentId;
  String userId;
  String comments;

  RequestCommentPushContent({
    this.parentId,
    this.contentId,
    this.userId,
    this.comments,
  });

  factory RequestCommentPushContent.fromJson(Map<String, dynamic> json) =>  _$RequestCommentPushContentFromJson(json);
  Map<String, dynamic> toJson() => _$RequestCommentPushContentToJson(this);


}