import 'package:json_annotation/json_annotation.dart';

part 'LoginResponse.g.dart';

@JsonSerializable(nullable: true)
class LoginResponse {
  int statusCode;
  String message;
  bool success;
  LoginResponseData data;

  LoginResponse({
    this.statusCode,
    this.message,
    this.data,
    this.success,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  bool isSuccess() {
    return statusCode != null && success != null && statusCode == 200 && success;
  }
}

@JsonSerializable(nullable: true)
class LoginResponseData {
  int id;
  String name;
  String email;
  String phone;
  String gender;
  int age;
  String address;
  String picUrl;
  int countryId;
  int languageId;
  String addedTs;
  String modifiedTime;
  String socialType;
  String flowType;
  String token;
  bool isOtpVerified;

  LoginResponseData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.token,
    this.isOtpVerified,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);
}
