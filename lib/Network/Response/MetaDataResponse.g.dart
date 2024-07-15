// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MetaDataResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaDataResponse _$MetaDataResponseFromJson(Map<String, dynamic> json) {
  return MetaDataResponse(
    statusCode: json['statusCode'] as int,
    message: json['message'] as String,
    success: json['success'] as bool,
    data: MetaDataResponseData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MetaDataResponseToJson(MetaDataResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

MetaDataResponseData _$MetaDataResponseDataFromJson(Map<String, dynamic> json) {
  return MetaDataResponseData(
    genres: (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    formats: (json['formats'] as List)
        ?.map((e) => e == null
            ? null
            : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    languages: (json['languages'] as List)
        ?.map((e) => e == null
            ? null
            : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    countries: (json['countries'] as List)
        ?.map((e) => e == null
            ? null
            : MetaDataCountryResponseDataCommon.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
    report: (json['report'] as List)
        ?.map((e) => e == null
            ? null
            : MetaDataResponseDataCommon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MetaDataResponseDataToJson(
        MetaDataResponseData instance) =>
    <String, dynamic>{
      'genres': instance.genres,
      'formats': instance.formats,
      'languages': instance.languages,
      'countries': instance.countries,
      'report': instance.report,
    };

MetaDataResponseDataCommon _$MetaDataResponseDataCommonFromJson(
    Map<String, dynamic> json) {
  return MetaDataResponseDataCommon(
    id: json['id'] as int,
    name: json['name'] as String,
    nameUtf8: json['nameUtf8'] as String,
  );
}

Map<String, dynamic> _$MetaDataResponseDataCommonToJson(
        MetaDataResponseDataCommon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameUtf8': instance.nameUtf8,
    };

MetaDataCountryResponseDataCommon _$MetaDataCountryResponseDataCommonFromJson(
    Map<String, dynamic> json) {
  return MetaDataCountryResponseDataCommon(
    id: json['id'] as int,
    name: json['name'] as String,
    isoCode: json['isoCode'] as String,
    unCode: json['unCode'] as String,
    diallingCode: json['diallingCode'] as int,
  );
}

Map<String, dynamic> _$MetaDataCountryResponseDataCommonToJson(
        MetaDataCountryResponseDataCommon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isoCode': instance.isoCode,
      'unCode': instance.unCode,
      'diallingCode': instance.diallingCode,
    };
