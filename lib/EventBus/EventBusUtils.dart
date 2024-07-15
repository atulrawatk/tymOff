
import 'package:event_bus/event_bus.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppEnums.dart';

import 'EventModels/EventAppThemeChanged.dart';
import 'EventModels/EventContentInfoChange.dart';
import 'EventModels/EventDetailCardChange.dart';
import 'EventModels/EventDetailPageChangeListener.dart';
import 'EventModels/EventRefreshContent.dart';
import 'EventModels/EventTakeABreak.dart';

EventBus eventBus = EventBus();

class EventBusUtils {
  static void eventTakeABreak_Break() {
    EventTakeABreak eventTakeABreak = EventTakeABreak(eventStatus: TAKE_A_BREAK_STATUS.BREAK);
    eventBus.fire(eventTakeABreak);
  }

  static void eventTakeABreak_Resume() {
    EventTakeABreak eventTakeABreak = EventTakeABreak(eventStatus: TAKE_A_BREAK_STATUS.RESUME);
    eventBus.fire(eventTakeABreak);
  }

  static void eventTakeABreak_Set() {
    EventTakeABreak eventTakeABreak = EventTakeABreak(eventStatus: TAKE_A_BREAK_STATUS.BREAK_SET);
    eventBus.fire(eventTakeABreak);
  }

  static void eventAppThemeChange() async {
    var theme = await SharedPrefUtil.getTheme();

    EventAppThemeChanged eventAppThemeChanged = EventAppThemeChanged(theme: theme);
    eventBus.fire(eventAppThemeChanged);
  }

  static void eventDetailCardChange(String contentId, {DIRECTION direction = DIRECTION.NEXT}) {
    EventDetailCardChange eventDetailCardChange = EventDetailCardChange(contentId, direction: direction);
    eventBus.fire(eventDetailCardChange);
  }

  static void eventDetailCardDoNotChange(String contentId, {DIRECTION direction = DIRECTION.NEXT}) {
    EventDetailCardDoNotChange eventDetailCardDoNotChange = EventDetailCardDoNotChange(contentId, direction: direction);
    eventBus.fire(eventDetailCardDoNotChange);
  }

  static void eventRefreshContent() {
    EventRefreshContent eventRefreshContent = EventRefreshContent(true);
    eventBus.fire(eventRefreshContent);
  }

  static void eventDetailPageChange() {
    EventDetailPageChangeListener eventRefreshContent = EventDetailPageChangeListener(true);
    eventBus.fire(eventRefreshContent);
  }

  static void eventContentInfoUpdate(ActionContentData dataToUpdate) {
    EventContentInfoChange _event = EventContentInfoChange(dataToUpdate: dataToUpdate, contentChangeType: ContentChangeType.UPDATE);
    eventBus.fire(_event);
  }

  static void eventContentInfoDelete(ActionContentData dataToUpdate) {
    EventContentInfoChange _event = EventContentInfoChange(dataToUpdate: dataToUpdate, contentChangeType: ContentChangeType.DELETE);
    eventBus.fire(_event);
  }
}