
enum TAKE_A_BREAK_STATUS {
  BREAK, RESUME, BREAK_SET
}

class EventTakeABreak {
  TAKE_A_BREAK_STATUS eventStatus;

  EventTakeABreak({this.eventStatus});

  void setEvent(TAKE_A_BREAK_STATUS eventStatus) {
    this.eventStatus = eventStatus;
  }
}