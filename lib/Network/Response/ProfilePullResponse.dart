import 'package:json_annotation/json_annotation.dart';
part 'ProfilePullResponse.g.dart';


@JsonSerializable(nullable:false)

class ProfileGetResponse
{
  int statusCode ;
  String message;
  bool success;
  ProfileGetData data;

  ProfileGetResponse({
    this.statusCode,
    this.message,
    this.success,
    this.data

  });

  factory ProfileGetResponse.fromJson(Map<String, dynamic> json) =>  _$ProfileGetResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileGetResponseToJson(this);

}
@JsonSerializable(nullable: false)

class ProfileGetData
{

  String name;
  String email;
  String phone;
  String modifiedTime;
  String gender;
  int id;
  int age;
  int countryId;
  int languageId;
  String  addedTs;
  bool isOtpVerified;



  ProfileGetData ({
    this.name,
    this.email,
    this.phone,
    this.modifiedTime,
    this.age,
    this.gender,
    this.languageId,
    this.countryId,
    this.isOtpVerified,
    this.id,this.addedTs,

  });

  factory ProfileGetData.fromJson(Map<String, dynamic> json) =>  _$ProfileGetDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileGetDataToJson(this);
}


