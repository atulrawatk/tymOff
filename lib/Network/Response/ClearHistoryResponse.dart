import 'package:json_annotation/json_annotation.dart';
part 'ClearHistoryResponse.g.dart';

@JsonSerializable(nullable: true)
class ClearHistoryResponse{
  int statusCode;
  String message;
  bool success;


  ClearHistoryResponse({
    this.statusCode,
    this.message,
    this.success
  });

  factory ClearHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ClearHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClearHistoryResponseToJson(this);

}