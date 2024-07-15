// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestFetchContent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestFetchContent _$RequestFetchContentFromJson(Map<String, dynamic> json) {
  return RequestFetchContent(
    searchText: json['searchText'] as String,
    pagination: RequestFetchContentPagination.fromJson(
        json['pagination'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RequestFetchContentToJson(
        RequestFetchContent instance) =>
    <String, dynamic>{
      'searchText': instance.searchText,
      'pagination': instance.pagination,
    };

RequestFetchContentPagination _$RequestFetchContentPaginationFromJson(
    Map<String, dynamic> json) {
  return RequestFetchContentPagination(
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
  );
}

Map<String, dynamic> _$RequestFetchContentPaginationToJson(
        RequestFetchContentPagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
