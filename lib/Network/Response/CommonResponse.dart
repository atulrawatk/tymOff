import 'package:json_annotation/json_annotation.dart';

part 'CommonResponse.g.dart';

@JsonSerializable(nullable: true)
class CommonResponse {
  int statusCode;
  String message;
  bool success;

  CommonResponse(
      {this.statusCode,
      this.message,
      this.success,});

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);

  bool isSuccess() {
    return statusCode != null && success != null && statusCode == 200 && success;
  }
}
