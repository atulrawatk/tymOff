import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
part 'RequestEditProfile.g.dart';


@JsonSerializable(nullable:false)
class RequestEditProfile {
  String name;
  String phone;
  int countryId;
  int languageId;
  String gender;
  int Age;
  String address;
  String email;

  RequestEditProfile({
    this.name,
    this.phone,
    this.gender,
    this.countryId,
    this.Age,
    this.languageId,
    this.address,
    this.email,
  });

  factory RequestEditProfile.fromJson(Map<String, dynamic> json) =>  _$RequestEditProfileFromJson(json);
  Map<String, dynamic> toJson() => _$RequestEditProfileToJson(this);

  static Future<RequestEditProfile> fromSharedPreferenceUserData() async{
    RequestEditProfile requestEditProfile = RequestEditProfile();
    try {
      var loginResponse = await SharedPrefUtil.getLoginData();
      var userData = loginResponse.data;
      requestEditProfile.name = userData.name;
      requestEditProfile.countryId = userData.countryId;
      requestEditProfile.languageId = userData.languageId;
      requestEditProfile.gender = userData.gender;
      requestEditProfile.address = userData.address;
      requestEditProfile.email = userData.email;
      requestEditProfile.phone = userData.phone;
    } catch(e) {

    }

    return requestEditProfile;
  }
}