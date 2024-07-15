// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MetaResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaResponse _$MetaResponseFromJson(Map<String, dynamic> json) {
  return MetaResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: (json['data'] as List)
        .map((e) => MetaData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MetaResponseToJson(MetaResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) {
  return MetaData()
    ..genres = (json['genres'] as List)
        .map((e) => MetaGenres.fromJson(e as Map<String, dynamic>))
        .toList()
    ..formats = (json['formats'] as List)
        .map((e) => MetaFormat.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'genres': instance.genres,
      'formats': instance.formats,
    };

MetaGenres _$MetaGenresFromJson(Map<String, dynamic> json) {
  return MetaGenres(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$MetaGenresToJson(MetaGenres instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MetaFormat _$MetaFormatFromJson(Map<String, dynamic> json) {
  return MetaFormat(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$MetaFormatToJson(MetaFormat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
