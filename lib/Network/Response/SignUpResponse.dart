import 'package:json_annotation/json_annotation.dart';
part 'SignUpResponse.g.dart';


@JsonSerializable(nullable:false)

class SignUpResponse
{
  int statusCode ;
  String message;
  bool success;

  SignUpResponse({
    this.statusCode,
    this.message,
    this.success,

  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>  _$SignUpResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);

}


