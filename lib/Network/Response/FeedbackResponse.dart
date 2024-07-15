import 'package:json_annotation/json_annotation.dart';
part 'FeedbackResponse.g.dart';


@JsonSerializable(nullable:false)

class FeedbackResponse
{
  int statusCode ;
  String message;
  bool success;

  FeedbackResponse({
    this.statusCode,
    this.message,
    this.success,

  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>  _$FeedbackResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);

}


