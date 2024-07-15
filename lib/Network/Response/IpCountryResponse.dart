import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';

part 'IpCountryResponse.g.dart';

@JsonSerializable(nullable: true)
class IpCountryResponse {
  String area;
  String usagetype;
  String op;
  String ccode;
  String code;
  String city;
  int lastUpdatedTime;

  IpCountryResponse(
      {this.area,
      this.usagetype,
      this.op,
      this.ccode,
      this.code,
      this.city,
      this.lastUpdatedTime});

  factory IpCountryResponse.fromJson(Map<String, dynamic> json) =>
      _$IpCountryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IpCountryResponseToJson(this);

  void setLastUpdatedTime() {
    lastUpdatedTime = DateTimeUtils().currentMillisecondsSinceEpoch();
  }
}