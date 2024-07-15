import 'package:json_annotation/json_annotation.dart';

part 'PutProfileEditResponse.g.dart';

@JsonSerializable(nullable: false)
class PutProfileEditResponse {
  int statusCode;
  String message;
  bool success;

  PutProfileEditResponse({
    this.statusCode,
    this.message,
    this.success,
  });

  factory PutProfileEditResponse.fromJson(Map<String, dynamic> json) =>_$PutProfileEditResponseFromJson(json);
  Map<String, dynamic> toJson() =>_$PutProfileEditResponseToJson(this);
}
