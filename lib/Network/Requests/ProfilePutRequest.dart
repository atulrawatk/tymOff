import 'package:json_annotation/json_annotation.dart';
part 'ProfilePutRequest.g.dart';


@JsonSerializable(nullable:false)

class ProfilePutRequest
{
  String name;
  String phone;
  int countryId;
  int languageId;
  String gender;
  int age;

  ProfilePutRequest({
    this.name,
    this.phone,
    this.countryId,
    this.languageId,
    this.gender,
    this.age,

  });

  factory ProfilePutRequest.fromJson(Map<String, dynamic> json) =>  _$ProfilePutRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProfilePutRequestToJson(this);

}
