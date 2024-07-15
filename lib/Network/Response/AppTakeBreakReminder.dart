import 'package:json_annotation/json_annotation.dart';
part 'AppTakeBreakReminder.g.dart';


@JsonSerializable(nullable:true)
class AppTakeBreakReminder {
  int hour;
  int minutes;
  bool isReminderSet;

  AppTakeBreakReminder({
    this.hour,
    this.minutes,
    this.isReminderSet,
  }) {
    notifyChange();
  }

  factory AppTakeBreakReminder.fromJson(Map<String, dynamic> json) =>
      _$AppTakeBreakReminderFromJson(json);

  Map<String, dynamic> toJson() => _$AppTakeBreakReminderToJson(this);

  void notifyChange() {
    if(hour != null && minutes != null && (hour > 0 || minutes > 0)) {
      isReminderSet = true;
    } else {
      isReminderSet = false;
    }
  }

  bool isHoursValid() {
    if(hour != null && hour > 0) {
      return true;
    }
    return false;
  }

  bool isMinutesValid() {
    if(minutes != null && minutes > 0) {
      return true;
    }
    return false;
  }
}


