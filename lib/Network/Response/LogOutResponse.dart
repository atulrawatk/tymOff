import 'package:json_annotation/json_annotation.dart';
part 'LogOutResponse.g.dart';

@JsonSerializable(nullable: true)
class LogOutResponse{
  int statusCode;
  String message;
  bool success;


  LogOutResponse({
    this.statusCode,
    this.message,
    this.success
});

  factory LogOutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogOutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LogOutResponseToJson(this);

}