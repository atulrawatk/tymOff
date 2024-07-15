import 'package:json_annotation/json_annotation.dart';
part 'VerifiedEmailRequest.g.dart';

@JsonSerializable(nullable:true)
class VerifiedEmailRequest
{
  String email ;
  String flowType;
  String socialType;

  VerifiedEmailRequest({
    this.email,
    this.flowType,
    this.socialType

  });

  factory VerifiedEmailRequest.fromJson(Map<String, dynamic> json) =>  _$VerifiedEmailRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedEmailRequestToJson(this);

}


