import 'package:json_annotation/json_annotation.dart';
part 'RequestFilterContent.g.dart';


@JsonSerializable(nullable:false)
class RequestFilterContent {
  List<int> formatsList;
  List<int> genresList;
  String contentSearch;
  String discoverId;

  RequestFilterContent({
    this.formatsList,
    this.genresList,
    this.contentSearch,
    this.discoverId
  });

  factory RequestFilterContent.fromJson(Map<String, dynamic> json) =>  _$RequestFilterContentFromJson(json);
  Map<String, dynamic> toJson() => _$RequestFilterContentToJson(this);

  RequestFilterContent getRequest() {
    if(this.formatsList == null) {
      this.formatsList = new List();
    }
    if(this.genresList == null) {
      this.genresList = new List();
    }
    return this;
  }
}