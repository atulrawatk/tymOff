import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

import '../CommonNotificationContainerUI.dart';

class NotificationUI_Weblink extends StatefulWidget {

  @override
  _NotificationUI_WeblinkState createState() => _NotificationUI_WeblinkState();
}

class _NotificationUI_WeblinkState extends State<NotificationUI_Weblink> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 4.0, right: 4.0),
        child: Column(
          children: <Widget>[
            CommonNotificationContainerUI(Strings.imageUrl,widthOfContainer: MediaQuery.of(context).size.width, heightOfContainer: 120,),
            SizedBox(height: 10.0,),
            CustomWidget.getText("Lorem ispum dolor sit amet, consectetur elit, sed do eiusmod tempor.Lorem ispum dolor sit amet, consectetur elit, sed do eiusmod tempor.")
          ],
        )
    );
  }
}
