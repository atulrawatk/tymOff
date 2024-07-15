import 'package:json_annotation/json_annotation.dart';
part 'VerifiedOtpResponse.g.dart';

@JsonSerializable(nullable: false)
class VerifiedOtpResponse {

  int statusCode;
  String message;
  VerifiedOtpResult data;
  bool success;

  VerifiedOtpResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory VerifiedOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifiedOtpResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedOtpResponseToJson(this);
}
@JsonSerializable(nullable: false)
class VerifiedOtpResult {

  int id;
  String name;
  String email;
  int age;
  String address;
  String picUrl;
  int countryId;
  int languageId;
  String addedTs;
  String modifiedTime;
  String socialType;
  String flowType;
  bool isOtpVerified;

  VerifiedOtpResult({
    this.id,
    this.name,
    this.email,
    this.age,
    this.address,
    this.picUrl,
    this.countryId,
    this.languageId,
    this.addedTs,
    this.modifiedTime,
    this.socialType,
    this.flowType,
    this.isOtpVerified,

  });

  factory VerifiedOtpResult.fromJson(Map<String, dynamic> json) => _$VerifiedOtpResultFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedOtpResultToJson(this);
}
