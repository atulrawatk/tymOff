import 'package:json_annotation/json_annotation.dart';

part 'GetActionListLikeResponse.g.dart';

@JsonSerializable(nullable: false)
class GetActionListLikeResponse {
  int statusCode;
  String message;
  bool success;

  GetActionListLikeResponse({
    this.statusCode,
    this.message,
    this.success,
  });

  factory GetActionListLikeResponse.fromJson(Map<String, dynamic> json) => _$GetActionListLikeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetActionListLikeResponseToJson(this);
}
