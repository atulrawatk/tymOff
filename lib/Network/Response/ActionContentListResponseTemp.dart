import 'package:json_annotation/json_annotation.dart';
part 'ActionContentListResponseTemp.g.dart';


@JsonSerializable(nullable:true)
class ActionContentListResponseTemp
{
int statusCode ;
String message;
ActionContentDataTemp data;
ActionContentListResponseTemp({
  this.statusCode,
  this.message,
  this.data
});

factory ActionContentListResponseTemp.fromJson(Map<String, dynamic> json) =>  _$ActionContentListResponseTempFromJson(json);
Map<String, dynamic> toJson() => _$ActionContentListResponseTempToJson(this);

}

@JsonSerializable(nullable: true)
class ActionContentDataTemp
{
  int totalRecords;
  List<ActionContentDataUserTemp> userList;

  ActionContentDataTemp ({
    this.totalRecords,
    this.userList,
  });

  factory ActionContentDataTemp.fromJson(Map<String, dynamic> json) =>  _$ActionContentDataTempFromJson(json);
  Map<String, dynamic> toJson() => _$ActionContentDataTempToJson(this);
}


@JsonSerializable(nullable: true)
class ActionContentDataUserTemp
{
  int id;
  String fullName;
  String email;
  String userStatus;
  String bio;
  String country;
  String countryName;
  String image;
  String thumbnailImage;

  ActionContentDataUserTemp ({
    this.id,
    this.fullName,
    this.email,
    this.userStatus,
    this.bio,
    this.country,
    this.countryName,
    this.image,
    this.thumbnailImage,
  });

  factory ActionContentDataUserTemp.fromJson(Map<String, dynamic> json) =>  _$ActionContentDataUserTempFromJson(json);
  Map<String, dynamic> toJson() => _$ActionContentDataUserTempToJson(this);
}


