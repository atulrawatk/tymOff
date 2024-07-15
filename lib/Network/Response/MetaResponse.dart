import 'package:json_annotation/json_annotation.dart';
part 'MetaResponse.g.dart';

@JsonSerializable(nullable: false)
class MetaResponse
{
  int statusCode ;
  String message;
  bool success;


  List<MetaData> data;


  MetaResponse({
    this.statusCode,
    this.message,
    this.success,
    this.data

  });
  factory MetaResponse.fromJson(Map<String, dynamic> json) =>  _$MetaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MetaResponseToJson(this);

}
@JsonSerializable(nullable: false)

class MetaData
{

  MetaData();
  List<MetaGenres> genres;
  List<MetaFormat> formats;

  factory MetaData.fromJson(Map<String, dynamic> json) =>  _$MetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$MetaDataToJson(this);

}

@JsonSerializable(nullable: false)
class MetaGenres{
  int id;
  String name;
  MetaGenres({
    this.id,
    this.name,
});
  factory MetaGenres.fromJson(Map<String, dynamic> json) =>  _$MetaGenresFromJson(json);
  Map<String, dynamic> toJson() => _$MetaGenresToJson(this);

}


@JsonSerializable(nullable: false)
class MetaFormat{
  int id;
  String name;
  MetaFormat({
    this.id,
    this.name,
  });
  factory MetaFormat.fromJson(Map<String, dynamic> json) =>  _$MetaFormatFromJson(json);
  Map<String, dynamic> toJson() => _$MetaFormatToJson(this);

}

