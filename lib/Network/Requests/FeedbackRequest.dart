import 'package:json_annotation/json_annotation.dart';
part 'FeedbackRequest.g.dart';


@JsonSerializable(nullable:false)

class FeedbackRequest
{
  String subject ;
  String title;
  String description;

  FeedbackRequest({
    this.subject,
    this.title,
    this.description,

  });

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) =>  _$FeedbackRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackRequestToJson(this);

}


