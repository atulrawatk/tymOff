import 'package:json_annotation/json_annotation.dart';

part 'MetaDataResponse.g.dart';

@JsonSerializable(nullable: false)
class MetaDataResponse {
  int statusCode;

  String message;
  bool success;

  MetaDataResponseData data;

  MetaDataResponse({this.statusCode, this.message, this.success, this.data});

  factory MetaDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataResponseToJson(this);
}

@JsonSerializable(nullable: true)
class MetaDataResponseData {
  List<MetaDataResponseDataCommon> genres;
  List<MetaDataResponseDataCommon> formats;
  List<MetaDataResponseDataCommon> languages;
  List<MetaDataCountryResponseDataCommon> countries;
  List<MetaDataResponseDataCommon> report;



  MetaDataResponseData({
    this.genres,
    this.formats,
    this.languages,
    this.countries,
    this.report
  });

  factory MetaDataResponseData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataResponseDataToJson(this);
}

@JsonSerializable(nullable: false)
class MetaDataResponseDataCommon {
  int id;
  String name;
  String nameUtf8;

  MetaDataResponseDataCommon({
    this.id,
    this.name,
    this.nameUtf8,
  });

  factory MetaDataResponseDataCommon.fromJson(Map<String, dynamic> json) =>
      _$MetaDataResponseDataCommonFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataResponseDataCommonToJson(this);

  int getUID() => id;
}

@JsonSerializable(nullable: false)

class MetaDataCountryResponseDataCommon {
  int id;
  String name;
  String isoCode;
  String unCode;
  int diallingCode;

  MetaDataCountryResponseDataCommon({
    this.id,
    this.name,
    this.isoCode,
    this.unCode,
    this.diallingCode,
  });

  factory MetaDataCountryResponseDataCommon.fromJson(Map<String, dynamic> json) =>
      _$MetaDataCountryResponseDataCommonFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataCountryResponseDataCommonToJson(this);

  int getUID() => id;
}