import 'package:json_annotation/json_annotation.dart';
part 'CacheApiHandler.g.dart';

@JsonSerializable(nullable: false)
class CacheApiHandler {
  Map<String, String> hashMapOfCacheRequest = Map();

  CacheApiHandler({this.hashMapOfCacheRequest});

  factory CacheApiHandler.fromJson(Map<String, dynamic> json) =>
      _$CacheApiHandlerFromJson(json);

  Map<String, dynamic> toJson() => _$CacheApiHandlerToJson(this);
}