import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

class NotificationUI_Text extends StatefulWidget {

  final ActionContentData contentMain;
  NotificationUI_Text(this.contentMain);


  @override
  _NotificationUI_TextState createState() => _NotificationUI_TextState();
}

class _NotificationUI_TextState extends State<NotificationUI_Text> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomWidget.getHtmlText(context,widget?.contentMain?.contentValue,style: Theme.of(context).textTheme.title),
    );
  }
}
