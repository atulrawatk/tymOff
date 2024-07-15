import 'package:json_annotation/json_annotation.dart';

part 'PutActionLikeResponse.g.dart';

@JsonSerializable(nullable: false)
class PutActionLikeResponse {
  int statusCode;
  String message;
  bool success;

  PutActionLikeResponse({
    this.statusCode,
    this.message,
    this.success,
  });

  factory PutActionLikeResponse.fromJson(Map<String, dynamic> json) => _$PutActionLikeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PutActionLikeResponseToJson(this);
}
