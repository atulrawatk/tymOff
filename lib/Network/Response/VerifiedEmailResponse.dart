import 'package:json_annotation/json_annotation.dart';
part 'VerifiedEmailResponse.g.dart';

@JsonSerializable(nullable: false)
class VerifiedEmailResponse {

  int statusCode;
  String message;
  VerifiedEmailResult data;
  bool success;

  VerifiedEmailResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory VerifiedEmailResponse.fromJson(Map<String, dynamic> json) => _$VerifiedEmailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedEmailResponseToJson(this);
}
@JsonSerializable(nullable: false)
class VerifiedEmailResult {

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

  VerifiedEmailResult({
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

  factory VerifiedEmailResult.fromJson(Map<String, dynamic> json) => _$VerifiedEmailResultFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedEmailResultToJson(this);
}
