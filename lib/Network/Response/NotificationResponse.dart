import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
part 'NotificationResponse.g.dart';

@JsonSerializable(nullable: true)
class NotificationResponse{
  int statusCode;
  String message;
  bool success;
  NotificationData data;

  NotificationResponse({
    this.statusCode,
    this.message,
    this.success,
    this.data,
  });


  factory NotificationResponse.fromJson(Map<String, dynamic> json) => _$NotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

@JsonSerializable(nullable: true)
class NotificationData {
  List<ResponseNotificationDataList> dataList;

  NotificationData ({
    this.dataList,
  });
  factory NotificationData.fromJson(Map<String, dynamic> json) =>  _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable(nullable: true)
class ResponseNotificationDataList {
  int id;
  String title;
  String description;
  String createdDateTime;
  String notificationType;
  ActionContentData contentMain;
  DiscoverListData discoverData;

  ResponseNotificationDataList ({
    this.id,
    this.title,
    this.description,
    this.createdDateTime,
    this.notificationType,
    this.contentMain,
  });
  factory ResponseNotificationDataList.fromJson(Map<String, dynamic> json) =>  _$ResponseNotificationDataListFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseNotificationDataListToJson(this);
}

@JsonSerializable(nullable: true)
class DiscoverData{
  int id;
  String name;

  DiscoverData({
    this.id,
    this.name
});

  factory DiscoverData.fromJson(Map<String, dynamic> json) =>  _$DiscoverDataFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverDataToJson(this);

}
