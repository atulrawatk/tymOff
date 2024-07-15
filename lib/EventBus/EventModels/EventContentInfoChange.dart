import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/AppEnums.dart';

class EventContentInfoChange {
  ActionContentData dataToUpdate;
  ContentChangeType contentChangeType;

  EventContentInfoChange({this.dataToUpdate, this.contentChangeType});

  void setEvent(
      ActionContentData dataToUpdate, ContentChangeType contentChangeType) {
    this.dataToUpdate = dataToUpdate;
    this.contentChangeType = contentChangeType;
  }
}
