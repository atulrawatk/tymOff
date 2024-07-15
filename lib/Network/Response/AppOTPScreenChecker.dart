import 'package:json_annotation/json_annotation.dart';
import 'package:tymoff/Network/Api/ApiHandlerUtils.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
part 'AppOTPScreenChecker.g.dart';

@JsonSerializable(nullable:true)
class AppOTPScreenChecker {
  String mobile;
  String countryCode;
  int lastUpdatedTime;

  AppOTPScreenChecker(this.mobile, this.countryCode) {
    _notifyChange();
  }

  factory AppOTPScreenChecker.fromJson(Map<String, dynamic> json) =>
      _$AppOTPScreenCheckerFromJson(json);

  Map<String, dynamic> toJson() => _$AppOTPScreenCheckerToJson(this);

  void setMobile(String _mobile) {
    this.mobile = _mobile;
    _notifyChange();
  }

  void setCountryCode(String _countryCode) {
    this.countryCode = _countryCode;
    _notifyChange();
  }

  void _notifyChange() {
    lastUpdatedTime = DateTimeUtils().currentMillisecondsSinceEpoch();
  }

  bool isExpired() {
    return ApiHandlerUtils.isShowOtpCacheExpired(lastUpdatedTime);
  }
}


