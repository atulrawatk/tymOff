// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppOTPScreenChecker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppOTPScreenChecker _$AppOTPScreenCheckerFromJson(Map<String, dynamic> json) {
  return AppOTPScreenChecker(
    json['mobile'] as String,
    json['countryCode'] as String,
  )..lastUpdatedTime = json['lastUpdatedTime'] as int;
}

Map<String, dynamic> _$AppOTPScreenCheckerToJson(
        AppOTPScreenChecker instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'countryCode': instance.countryCode,
      'lastUpdatedTime': instance.lastUpdatedTime,
    };
