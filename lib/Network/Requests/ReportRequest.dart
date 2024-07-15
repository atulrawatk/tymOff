import 'package:json_annotation/json_annotation.dart';
part 'ReportRequest.g.dart';


@JsonSerializable(nullable:false)
class ReportRequest {
  String contentId;
  String reportId;
  String reportText;

  ReportRequest({
    this.contentId,
    this.reportId,
    this.reportText,
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>  _$ReportRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);


}
