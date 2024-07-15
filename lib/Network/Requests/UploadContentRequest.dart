import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';

part 'UploadContentRequest.g.dart';

@JsonSerializable(nullable:false)
class UploadContentRequest {
  List<RequestUploadDataTemp> dataList;

  UploadContentRequest({
    this.dataList,
  });
  factory UploadContentRequest.fromJson(Map<String, dynamic> json) =>  _$UploadContentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UploadContentRequestToJson(this);
}

@JsonSerializable(nullable: false)
class RequestUploadDataTemp
{
  String localId;
  int contentId;
  String title;
  String url;
  String description;
  int typeId;
  List<int> languageId;
  List<int> catId;
  bool isCreated;

  RequestUploadDataTemp ({
    this.localId,
    this.contentId,
    this.title,
    this.description,
    this.url,
    this.typeId,
    this.languageId,
    this.catId,
    this.isCreated,
  });

  factory RequestUploadDataTemp.fromJson(Map<String, dynamic> json) =>  _$RequestUploadDataTempFromJson(json);
  Map<String, dynamic> toJson() => _$RequestUploadDataTempToJson(this);
}


