// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DraftUploadContentRequestToServer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftUploadContentRequestToServer _$DraftUploadContentRequestToServerFromJson(
    Map<String, dynamic> json) {
  return DraftUploadContentRequestToServer(
    data: (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : RequestDraftUploadData.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$DraftUploadContentRequestToServerToJson(
        DraftUploadContentRequestToServer instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

RequestDraftUploadData _$RequestDraftUploadDataFromJson(
    Map<String, dynamic> json) {
  return RequestDraftUploadData(
    _$enumDecodeNullable(_$UploadUIActiveEnumMap, json['contentType']),
    title: json['title'] as String,
    description: json['description'] as String,
    richTextStory: json['richTextStory'] as String,
    url: json['url'] as String,
    hmSelectedItemsGenre:
        (json['hmSelectedItemsGenre'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          int.parse(k),
          e == null
              ? null
              : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>)),
    ),
    hmSelectedItemsLanguage:
        (json['hmSelectedItemsLanguage'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          int.parse(k),
          e == null
              ? null
              : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>)),
    ),
    mapOfMediaMetaData:
        (json['mapOfMediaMetaData'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : RequestUploadDataFileInfo.fromJson(e as Map<String, dynamic>)),
    ),
    storyData: json['storyData'] as String,
    localId: json['localId'] as String,
  )
    ..tempInt = json['tempInt'] as int
    ..draftCreatedDateTime = json['draftCreatedDateTime'] as String;
}

Map<String, dynamic> _$RequestDraftUploadDataToJson(
        RequestDraftUploadData instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'title': instance.title,
      'description': instance.description,
      'richTextStory': instance.richTextStory,
      'url': instance.url,
      'hmSelectedItemsGenre': instance.hmSelectedItemsGenre
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'hmSelectedItemsLanguage': instance.hmSelectedItemsLanguage
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'mapOfMediaMetaData': instance.mapOfMediaMetaData,
      'storyData': instance.storyData,
      'tempInt': instance.tempInt,
      'contentType': _$UploadUIActiveEnumMap[instance.contentType],
      'draftCreatedDateTime': instance.draftCreatedDateTime,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UploadUIActiveEnumMap = {
  UploadUIActive.IMAGE: 'IMAGE',
  UploadUIActive.VIDEO: 'VIDEO',
  UploadUIActive.RICH_TEXT: 'RICH_TEXT',
  UploadUIActive.WEB_LINK: 'WEB_LINK',
  UploadUIActive.NONE: 'NONE',
};

RequestUploadDataFileInfo _$RequestUploadDataFileInfoFromJson(
    Map<String, dynamic> json) {
  return RequestUploadDataFileInfo(
    json['mediaFileName'] as String,
    json['mediaFilePath'] as String,
    thumbnail: (json['thumbnail'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$RequestUploadDataFileInfoToJson(
        RequestUploadDataFileInfo instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'mediaFileName': instance.mediaFileName,
      'mediaFilePath': instance.mediaFilePath,
    };
