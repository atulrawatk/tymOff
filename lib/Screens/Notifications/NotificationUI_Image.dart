import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/Strings.dart';

import 'CommonNotificationContainerUI.dart';

class NotificationUI_Image extends StatefulWidget {

  final ActionContentData contentMain;
  NotificationUI_Image(this.contentMain);

  @override
  _NotificationUI_ImageState createState() => _NotificationUI_ImageState();
}

class _NotificationUI_ImageState extends State<NotificationUI_Image> {

  @override
  Widget build(BuildContext context) {

    Widget mainWidget = Container();

      if(widget.contentMain != null) {
        if((widget?.contentMain?.contentUrl?.length ?? 0) > 1) {
          mainWidget = multipleImageUI(widget.contentMain.contentUrl);
        } else {
          mainWidget = singleImageUI();
        }
      }

    return mainWidget;
  }

  Widget multipleImageUI(List<ContentUrlData> contentUrl){
    return Container(
      height: 140,
      child: ListView.builder(
        itemCount: contentUrl.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, indexChildContent) {
          return  Container(
              margin: EdgeInsets.only(left: 1.0, right: 1.0),
              child: CommonNotificationContainerUI(contentUrl[indexChildContent].url));
        }
      ),
    );

  }

  Widget singleImageUI(){
    return Container(
      height: 120,
        margin: EdgeInsets.only(left: 1.0, right: 1.0),
        child: CommonNotificationContainerUI(widget.contentMain.contentUrl[0].url,widthOfContainer: MediaQuery.of(context).size.width,),
    );
  }
}
