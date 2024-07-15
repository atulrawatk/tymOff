import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';

import 'ActionContentListResponse.dart';
import 'FCMNotficationPayloadEvent.dart';
part 'FCMNotficationPayloadEvent.g.dart';

@JsonSerializable(nullable: true)
class FCMNotficationPayloadEvent {
  int id;
  String title;
  String description;
  String notificationType;
  DiscoverListData discoverData;
  ActionContentData contentMain;

  FCMNotficationPayloadEvent({
    this.id,
    this.title,
    this.description,
    this.notificationType,
    this.discoverData,
    this.contentMain,
  });

  factory FCMNotficationPayloadEvent.fromJson(Map<String, dynamic> json) =>  _$FCMNotficationPayloadEventFromJson(json);
  Map<String, dynamic> toJson() => _$FCMNotficationPayloadEventToJson(this);

}
