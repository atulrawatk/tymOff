import 'package:flutter/material.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
import 'package:tymoff/Network/Response/NotificationResponse.dart';
import 'package:tymoff/Screens/Notifications/NotificationUI/NotificationUI_Video.dart';
import 'package:tymoff/Screens/Notifications/NotificationUI/NotificationUI_Weblink.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import '../NotificationUI_Image.dart';


class NotificationUI extends StatefulWidget {

  final ResponseNotificationDataList notificationDataList;
  NotificationUI(this.notificationDataList);

  @override
  _NotificationUIState createState() => _NotificationUIState();
}

class _NotificationUIState extends State<NotificationUI> {

  @override
  Widget build(BuildContext context) {
    return  Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            color: Theme
                .of(context)
                .backgroundColor,
            child : GestureDetector(
                        child: buildNotificationList(),
                        onTap: () {
                        AnalyticsUtils?.analyticsUtils
                            ?.eventDiscovercontentButtonClicked();
                        NavigatorUtils.handleContentCardWithData(context, widget?.notificationDataList?.contentMain);
                        },
              )
    );
  }

  int getTypeId(){
    return widget?.notificationDataList?.contentMain?.typeId ?? 0;
  }

  Widget buildNotificationList() {
    var contentType = ContentTypeUtils.getType(getTypeId());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: CustomWidget.getText(
                      widget?.notificationDataList?.description,
                      style: Theme.of(context).textTheme.title),
                  )),
              Expanded(
                  flex: 0,
                  child: Container(
                      height: 30.0,
//                        color: Colors.red,
                      alignment: Alignment.center,
                      child: CustomWidget.getText(DateTimeUtils().formatTime(widget?.notificationDataList?.createdDateTime ?? DateTime.now().toString()),
                          style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0))))
            ],
          ),
          SizedBox(height: 4.0,),
          SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(left: 20.0,right: 10.0),
                //margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: getNotificationTypeWidget(contentType),
              )),
          SizedBox(height: 8.0,)
        ],
      ),
    );
  }

  Widget getNotificationTypeWidget(AppContentType type) {

    var contentMain = widget?.notificationDataList?.contentMain;
    Widget childWidget = Container();

    if (type == AppContentType.image) {
      childWidget = NotificationUI_Image(contentMain);
    } else if (type == AppContentType.video) {
      childWidget = NotificationUI_Video(contentMain);
    } else if (type == AppContentType.text) {
      //childWidget = NotificationUI_Text(contentMain);
      childWidget = Container();
    } else if (type == AppContentType.article) {
      childWidget = NotificationUI_Weblink();
    } else if (type == AppContentType.gif) {
      childWidget = NotificationUI_Image(contentMain);
    }
    return childWidget;
  }
}
