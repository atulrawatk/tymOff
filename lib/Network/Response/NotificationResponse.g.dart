// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return NotificationResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: json['data'] == null
        ? null
        : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotificationResponseToJson(
        NotificationResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return NotificationData(
    dataList: (json['dataList'] as List)
        ?.map((e) => e == null
            ? null
            : ResponseNotificationDataList.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'dataList': instance.dataList,
    };

ResponseNotificationDataList _$ResponseNotificationDataListFromJson(
    Map<String, dynamic> json) {
  return ResponseNotificationDataList(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    createdDateTime: json['createdDateTime'] as String,
    notificationType: json['notificationType'] as String,
    contentMain: json['contentMain'] == null
        ? null
        : ActionContentData.fromJson(
            json['contentMain'] as Map<String, dynamic>),
  )..discoverData = json['discoverData'] == null
      ? null
      : DiscoverListData.fromJson(json['discoverData'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ResponseNotificationDataListToJson(
        ResponseNotificationDataList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdDateTime': instance.createdDateTime,
      'notificationType': instance.notificationType,
      'contentMain': instance.contentMain,
      'discoverData': instance.discoverData,
    };

DiscoverData _$DiscoverDataFromJson(Map<String, dynamic> json) {
  return DiscoverData(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$DiscoverDataToJson(DiscoverData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
