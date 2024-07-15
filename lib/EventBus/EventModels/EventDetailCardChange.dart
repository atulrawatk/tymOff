

enum DIRECTION {
  PREVIOUS, NEXT
}

class EventDetailCardChange {
  DIRECTION direction;
  String contentIdToChange;

  EventDetailCardChange(this.contentIdToChange, {this.direction = DIRECTION.NEXT});
}

class EventDetailCardDoNotChange {
  DIRECTION direction;
  String contentIdToChange;

  EventDetailCardDoNotChange(this.contentIdToChange, {this.direction = DIRECTION.NEXT});
}