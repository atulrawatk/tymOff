import 'package:flutter/material.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/SizeConfig.dart';

class EmptyScreen extends StatefulWidget {
  final String profileActionType;
  EmptyScreen({this.profileActionType});

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen>
    with AutomaticKeepAliveClientMixin {

  SizeConfig sizeConfig = SizeConfig();

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    sizeConfig.init(context);
    super.didChangeDependencies();
  }

  String messageToShow(){
    String message = "No Content Found";
    switch(widget.profileActionType){
      case Constant.KEY_CONTENT_TYPE_UPLOAD :
        message = "No posts yet";
        break;
      case Constant.KEY_CONTENT_TYPE_LIKE :
        message = "No likes yet";
        break;
      case Constant.KEY_CONTENT_TYPE_FAVORITE :
        message = "No favorites yet";
        break;
      case Constant.KEY_CONTENT_TYPE_COMMENT :
        message = "No comments yet";
        break;
      case Constant.KEY_CONTENT_TYPE_DOWNLOAD :
        message = "No downloads yet";
        break;
      default :
        message = "No Content Found";
        break;
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
           //color: Colors.green,
           height: sizeConfig.screenHeight,
           width: sizeConfig.screenWidth,
           alignment: Alignment.center,
              child : CustomWidget.getText(messageToShow(),style: Theme.of(context).textTheme.title),
    );
  }
}
