import 'package:json_annotation/json_annotation.dart';
part 'DeletePostResponse.g.dart';

@JsonSerializable(nullable: true)
class DeletePostResponse{
  int statusCode;
  String message;
  bool success;


  DeletePostResponse({
    this.statusCode,
    this.message,
    this.success
  });

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) => _$DeletePostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePostResponseToJson(this);

}