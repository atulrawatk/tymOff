import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/Notifications/CommonNotificationContainerUI.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

class NotificationUI_Video extends StatefulWidget {

  final ActionContentData contentMain;
  NotificationUI_Video(this.contentMain);

  @override
  _NotificationUI_VideoState createState() => _NotificationUI_VideoState();
}

class _NotificationUI_VideoState extends State<NotificationUI_Video> {


  @override
  Widget build(BuildContext context) {
    Widget mainWidget = Container();

    if(widget.contentMain != null) {
      if((widget?.contentMain?.contentUrl?.length ?? 0) > 1) {
        mainWidget = multipleVideoWidget(widget.contentMain.contentUrl);
      } else {
        mainWidget = singleVideoUI();
      }
    }

    return mainWidget;
  }

  Widget multipleVideoWidget(List<ContentUrlData> contentUrl){
    return Container(
      height: 140,
      child: ListView.builder(
          itemCount: (contentUrl?.length ?? 0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, indexChildContent) {
            return Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 1.0, right: 1.0),
                    child: CommonNotificationContainerUI(contentUrl[indexChildContent].url,widthOfContainer: 130,heightOfContainer: 140,)),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: playArrowWidget(),
                )

              ],
            );
          }
      ),
    );

  }

  Widget singleVideoUI(){
    return Stack(
      children: <Widget>[
        Container(
          height: 120,
          margin: EdgeInsets.only(left: 1.0, right: 1.0),
          child: CommonNotificationContainerUI(widget.contentMain.contentUrl[0].url,widthOfContainer: MediaQuery.of(context).size.width,heightOfContainer: 120,),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: playArrowWidget(),
        )

      ],
    );
  }

  Widget playArrowWidget() {
    Widget widgetPlay = Container(
      alignment: Alignment(0.0, 0.0),
      child: Image.asset(
        "assets/play.png",
        scale: 2.5,
        color: ColorUtils.whiteColor,
      ),
    );
    return widgetPlay;
  }

}
