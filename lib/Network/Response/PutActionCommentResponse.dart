import 'package:json_annotation/json_annotation.dart';

import 'CommentPullResponse.dart';

part 'PutActionCommentResponse.g.dart';

@JsonSerializable(nullable: true)
class PutActionCommentResponse {
  int statusCode;
  String message;
  bool success;
  CommentPullDataList data;

  PutActionCommentResponse({
    this.statusCode,
    this.message,
    this.success,
  });

  factory PutActionCommentResponse.fromJson(Map<String, dynamic> json) => _$PutActionCommentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PutActionCommentResponseToJson(this);
}
