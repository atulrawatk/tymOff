import 'package:json_annotation/json_annotation.dart';

part 'DescriptionAlgoApi.g.dart';

@JsonSerializable(nullable: true)

class DescriptionAlgoApi{
  DescriptionAlgoApiResult result;

  DescriptionAlgoApi({
    this.result,
});
  factory DescriptionAlgoApi.fromJson(Map<String, dynamic> json) =>_$DescriptionAlgoApiFromJson(json);
  Map<String, dynamic> toJson() =>_$DescriptionAlgoApiToJson(this);
}

@JsonSerializable(nullable: true)
class DescriptionAlgoApiResult{
  List<String> images;
  DescriptionAlgoApiMetadata metadata;

  DescriptionAlgoApiResult({
    this.images,
    this.metadata,
});
  factory DescriptionAlgoApiResult.fromJson(Map<String, dynamic> json) =>_$DescriptionAlgoApiResultFromJson(json);
  Map<String, dynamic> toJson() =>_$DescriptionAlgoApiResultToJson(this);

}

@JsonSerializable(nullable: true)
class DescriptionAlgoApiMetadata{
  int statusCode;
  String summary;
  String title;
  String thumbnail;
  String url;

  DescriptionAlgoApiMetadata({
   this.statusCode,
   this.summary,
   this.title,
    this.thumbnail,
    this.url
});
  factory DescriptionAlgoApiMetadata.fromJson(Map<String, dynamic> json) =>_$DescriptionAlgoApiMetadataFromJson(json);
  Map<String, dynamic> toJson() =>_$DescriptionAlgoApiMetadataToJson(this);


}