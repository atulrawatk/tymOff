import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ContentDetailResponse.g.dart';

@JsonSerializable(nullable:false)
class ContentDetailResponse{
  int statusCode;
  String message;
  bool success;
  ActionContentData data;

  ContentDetailResponse({
    this.statusCode,
    this.message,
    this.success,
    this.data
});

  factory ContentDetailResponse.fromJson(Map<String, dynamic> json) =>  _$ContentDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ContentDetailResponseToJson(this);
}