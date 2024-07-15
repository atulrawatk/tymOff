import 'package:json_annotation/json_annotation.dart';
part 'AppSetContentScrollTimer.g.dart';


@JsonSerializable(nullable:true)
class AppSetContentScrollTimer {
  int seconds;
  bool isReminderSet;

  AppSetContentScrollTimer({
    this.seconds,
    this.isReminderSet,
  }) {
    notifyChange();
  }

  factory AppSetContentScrollTimer.fromJson(Map<String, dynamic> json) =>
      _$AppSetContentScrollTimerFromJson(json);

  Map<String, dynamic> toJson() => _$AppSetContentScrollTimerToJson(this);

  void notifyChange() {
    if(seconds != null && (seconds > 0)) {
      isReminderSet = true;
    } else {
      isReminderSet = false;
    }
  }

  bool isSecondsValid() {
    if(seconds != null) {
      return true;
    }
    return false;
  }
}


