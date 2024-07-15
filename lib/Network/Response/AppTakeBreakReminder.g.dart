// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppTakeBreakReminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppTakeBreakReminder _$AppTakeBreakReminderFromJson(Map<String, dynamic> json) {
  return AppTakeBreakReminder(
    hour: json['hour'] as int,
    minutes: json['minutes'] as int,
    isReminderSet: json['isReminderSet'] as bool,
  );
}

Map<String, dynamic> _$AppTakeBreakReminderToJson(
        AppTakeBreakReminder instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minutes': instance.minutes,
      'isReminderSet': instance.isReminderSet,
    };
