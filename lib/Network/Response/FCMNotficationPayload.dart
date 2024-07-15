import 'package:json_annotation/json_annotation.dart';

import 'FCMNotficationPayloadEvent.dart';
part 'FCMNotficationPayload.g.dart';


@JsonSerializable(nullable: true)
class FCMNotficationPayload {
  String noti_key;
  String noti_code;
  String noti_type;
  String noti_data;

  FCMNotficationPayload({
    this.noti_key,
    this.noti_code,
    this.noti_type,
    this.noti_data,
  });

  factory FCMNotficationPayload.fromJson(Map<String, dynamic> json) =>  _$FCMNotficationPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$FCMNotficationPayloadToJson(this);

}
