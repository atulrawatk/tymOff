// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppSetContentScrollTimer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSetContentScrollTimer _$AppSetContentScrollTimerFromJson(
    Map<String, dynamic> json) {
  return AppSetContentScrollTimer(
    seconds: json['seconds'] as int,
    isReminderSet: json['isReminderSet'] as bool,
  );
}

Map<String, dynamic> _$AppSetContentScrollTimerToJson(
        AppSetContentScrollTimer instance) =>
    <String, dynamic>{
      'seconds': instance.seconds,
      'isReminderSet': instance.isReminderSet,
    };
