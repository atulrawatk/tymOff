import 'package:json_annotation/json_annotation.dart';
part 'VerifiedOtpRequest.g.dart';

@JsonSerializable(nullable:false)
class VerifiedOtpRequest
{
  String email ;
  String otp;

  VerifiedOtpRequest({
    this.email,
    this.otp,

  });

  factory VerifiedOtpRequest.fromJson(Map<String, dynamic> json) =>  _$VerifiedOtpRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedOtpRequestToJson(this);

}


