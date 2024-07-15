import 'package:json_annotation/json_annotation.dart';
part 'UploadContentResponse.g.dart';


@JsonSerializable(nullable:true)
class UploadContentResponse {
  int statusCode ;
  String message;
  bool success;
  UploadData data;

  UploadContentResponse({
    this.statusCode,
    this.message,
    this.success,
    this.data

  });

  factory UploadContentResponse.fromJson(Map<String, dynamic> json) =>  _$UploadContentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadContentResponseToJson(this);

}
@JsonSerializable(nullable: true)
class UploadData {
  List<ResponseUploadContentData> dataList;
  UploadData ({
    this.dataList,
  });

  factory UploadData.fromJson(Map<String, dynamic> json) =>  _$UploadDataFromJson(json);
  Map<String, dynamic> toJson() => _$UploadDataToJson(this);
}

@JsonSerializable(nullable: true)
class ResponseUploadContentData {
    String localId;
    String title;
    String description;
    int typeId;
    List<String> languageId;
    List<String> catId;
    bool isCreated;
    int contentId;
  ResponseUploadContentData ({
     this.localId,
    this.title,
    this.description,
    this.typeId,
    this.languageId,
    this.catId,
    this.isCreated,
    this.contentId,
  });

  factory ResponseUploadContentData.fromJson(Map<String, dynamic> json) =>  _$ResponseUploadContentDataFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseUploadContentDataToJson(this);

    String getLocalUID() => localId;
    String getServerUID() => contentId.toString();
}

