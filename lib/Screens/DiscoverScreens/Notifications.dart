import 'package:flutter/material.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/NotificationResponse.dart';
import 'package:tymoff/Screens/Notifications/EmptyNotificationScreen.dart';
import 'package:tymoff/Screens/Notifications/NotificationUI/NotificationUI.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

class Notifications extends StatefulWidget {
  String appTheme;
  Notifications(this.appTheme);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with AutomaticKeepAliveClientMixin  {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    hitNotification(context);
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    Widget mainWidget = Container();
    if(_notificationListResponse != null) {
      if((_notificationListResponse?.data?.dataList?.length ?? 0) > 0) {
        mainWidget = ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _notificationListResponse?.data?.dataList?.length,
                itemBuilder: (BuildContext context, int index) {

              return Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    buildNotificationUI(_notificationListResponse?.data?.dataList[index]),
                  ],
                ),
              );
              });
      } else {
        mainWidget = EmptyNotificationScreen();
      }
    } else {
      mainWidget = Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefreshNotificationList,
      child: mainWidget,
    );
  }

  Future<void> _onRefreshNotificationList() async {
    //Holding pull to refresh loader widget for 2 sec.
    //You can fetch data from server.
    await new Future.delayed(const Duration(seconds: 1));
    _refreshScreen();
  }

  void _refreshScreen() {
    hitNotification(context);
  }

  bool getNotificationTypeDiscover(ResponseNotificationDataList notificationDataList){
    if(notificationDataList != null){
      if(notificationDataList.notificationType  ==  "DISCOVER"){
        return false;
      }
    }
    return true;
  }

  Widget buildNotificationUI(ResponseNotificationDataList notificationDataList) {
    return  getNotificationTypeDiscover(notificationDataList) ?  NotificationUI(notificationDataList)
          : GestureDetector(

              child:  Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                padding: EdgeInsets.only(left: 18.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: CustomWidget.getText(notificationDataList.title,style: Theme.of(context).textTheme.title),
                        ),
                    Expanded(
                        flex: 0,
                        child: Container(
                            height: 30.0,
//                        color: Colors.red,
                            alignment: Alignment.center,
                            child: CustomWidget.getText(DateTimeUtils().formatTime(notificationDataList.createdDateTime),
                                style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0))))

                    //child: CustomWidget.getText(getNotificationFormattedDate(notificationDataList.createdDateTime), style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0))))
                  ],
                ),
              ),
              onTap: (){
                NavigatorUtils.moveToContentDiscoverScreen(context, notificationDataList.discoverData.id, notificationDataList.discoverData.name);
              },
    );
  }

 /*String getNotificationFormattedDate(String createdDateTime) {
    try {
      PrintUtils.printLog("Munish -> notiCreatedDateTime -> START");
      var notiCreatedDateTime = DateTime.parse(createdDateTime);
      PrintUtils.printLog("Munish -> notiCreatedDateTime -> $notiCreatedDateTime");
      //var parsedNotiCreatedDateTime = DateFormat("MMM dd, yyyy").format(notiCreatedDateTime);
      var parsedNotiCreatedDateTime = TimeOfDay.fromDateTime(notiCreatedDateTime).toString();
      PrintUtils.printLog("Munish -> parsedNotiCreatedDateTime -> $parsedNotiCreatedDateTime");


      return parsedNotiCreatedDateTime;
    } catch(e){

    }

    return createdDateTime;
 }
*/

  NotificationResponse _notificationListResponse;

  hitNotification(BuildContext context) async{
    var _notificationListResponse = await ApiHandler.getNotification(context);
    if(_notificationListResponse != null) {
      if (_notificationListResponse.statusCode == 200) {
        if(mounted) {
          setState(() {
            this._notificationListResponse = _notificationListResponse;
          });
        }
        PrintUtils.printLog("Notification Api hit sucessfully");
      } else {
        PrintUtils.printLog("Error Occur in hitting Notification api");
      }
    } else {
      this._notificationListResponse = NotificationResponse();
    }
  }

}

