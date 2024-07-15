import 'package:json_annotation/json_annotation.dart';
part 'RequestFetchContent.g.dart';


@JsonSerializable(nullable:false)
class RequestFetchContent {
  String searchText;
  RequestFetchContentPagination pagination = RequestFetchContentPagination();

  RequestFetchContent({
    this.searchText,
    this.pagination,
  });


  factory RequestFetchContent.fromJson(Map<String, dynamic> json) =>  _$RequestFetchContentFromJson(json);
  Map<String, dynamic> toJson() => _$RequestFetchContentToJson(this);
}

@JsonSerializable(nullable:false)
class RequestFetchContentPagination {
  int page;
  int pageSize;

  RequestFetchContentPagination({
    this.page,
    this.pageSize,
  });


  factory RequestFetchContentPagination.fromJson(Map<String, dynamic> json) =>  _$RequestFetchContentPaginationFromJson(json);
  Map<String, dynamic> toJson() => _$RequestFetchContentPaginationToJson(this);
}