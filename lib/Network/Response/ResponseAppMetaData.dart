import 'package:json_annotation/json_annotation.dart';

import 'AppOTPScreenChecker.dart';
import 'AppSetContentScrollTimer.dart';
import 'AppTakeBreakReminder.dart';
part 'ResponseAppMetaData.g.dart';


@JsonSerializable(nullable:true)
class ResponseAppMetaData {
  int dateMetaDataLastSyncFromServer;
  bool isOnBoardingAlreadyShowed;
  bool isFirstTimeContentCardClickEventCompleted;
  bool isFirstTimeContentCardScrollEventCompleted;
  AppSetContentScrollTimer appSetContentScrollTimer;
  AppTakeBreakReminder appTakeBreakReminder;
  AppOTPScreenChecker appOTPScreenChecker;

  ResponseAppMetaData({
    this.dateMetaDataLastSyncFromServer,
    this.isOnBoardingAlreadyShowed,
    this.isFirstTimeContentCardClickEventCompleted,
    this.isFirstTimeContentCardScrollEventCompleted,
    this.appSetContentScrollTimer,
    this.appTakeBreakReminder,
    this.appOTPScreenChecker,
  });

  factory ResponseAppMetaData.fromJson(Map<String, dynamic> json) =>
      _$ResponseAppMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseAppMetaDataToJson(this);
}


