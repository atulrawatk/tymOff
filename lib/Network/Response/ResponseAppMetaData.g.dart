// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseAppMetaData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseAppMetaData _$ResponseAppMetaDataFromJson(Map<String, dynamic> json) {
  return ResponseAppMetaData(
    dateMetaDataLastSyncFromServer:
        json['dateMetaDataLastSyncFromServer'] as int,
    isOnBoardingAlreadyShowed: json['isOnBoardingAlreadyShowed'] as bool,
    isFirstTimeContentCardClickEventCompleted:
        json['isFirstTimeContentCardClickEventCompleted'] as bool,
    isFirstTimeContentCardScrollEventCompleted:
        json['isFirstTimeContentCardScrollEventCompleted'] as bool,
    appSetContentScrollTimer: json['appSetContentScrollTimer'] == null
        ? null
        : AppSetContentScrollTimer.fromJson(
            json['appSetContentScrollTimer'] as Map<String, dynamic>),
    appTakeBreakReminder: json['appTakeBreakReminder'] == null
        ? null
        : AppTakeBreakReminder.fromJson(
            json['appTakeBreakReminder'] as Map<String, dynamic>),
    appOTPScreenChecker: json['appOTPScreenChecker'] == null
        ? null
        : AppOTPScreenChecker.fromJson(
            json['appOTPScreenChecker'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponseAppMetaDataToJson(
        ResponseAppMetaData instance) =>
    <String, dynamic>{
      'dateMetaDataLastSyncFromServer': instance.dateMetaDataLastSyncFromServer,
      'isOnBoardingAlreadyShowed': instance.isOnBoardingAlreadyShowed,
      'isFirstTimeContentCardClickEventCompleted':
          instance.isFirstTimeContentCardClickEventCompleted,
      'isFirstTimeContentCardScrollEventCompleted':
          instance.isFirstTimeContentCardScrollEventCompleted,
      'appSetContentScrollTimer': instance.appSetContentScrollTimer,
      'appTakeBreakReminder': instance.appTakeBreakReminder,
      'appOTPScreenChecker': instance.appOTPScreenChecker,
    };
