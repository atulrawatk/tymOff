import 'package:json_annotation/json_annotation.dart';
part 'SearchHintResponse.g.dart';


@JsonSerializable(nullable:false)

class SearchHintResponse
{
  int statusCode ;
  String message;
  bool success;
  int totalPages;
  int totalElements;

  List<String> data;
  SearchHintResponse({
    this.statusCode,
    this.message,
    this.success,
    this.totalPages,
    this.totalElements,
    this.data

  });

  factory SearchHintResponse.fromJson(Map<String, dynamic> json) =>  _$SearchHintResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchHintResponseToJson(this);

}


