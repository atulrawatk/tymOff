import 'package:flutter/material.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:tymoff/main.dart';

class ShareWidget extends StatefulWidget {
  final double iconSize;
  final bool isComingFromListing ;
  final ActionContentData cardDetailData;
  final Color color;

  ShareWidget({this.iconSize, this.isComingFromListing, this.cardDetailData,this.color});

  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fireEventDetailCardDoNotChange() {
    if(widget?.cardDetailData?.id != null) {
      EventBusUtils.eventDetailCardDoNotChange(
          widget.cardDetailData.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isComingFromListing==true? GestureDetector(
      child: Container(
        color: Colors.transparent,
        height: 50.0,
        width: 50.0,
        alignment: Alignment.center,
        padding:  EdgeInsets.only( left:8.0),
        child :Image.asset("assets/share_web48.png",scale: 4.5, color: Theme.of(context).iconTheme.color),
          ),
      onTap: () {
        eventShareTriggered(context);
      },
    ): GestureDetector(
      child: Container(
        color: Colors.transparent,
        //height: 50.0,
        width: 50.0,
        alignment: Alignment.centerLeft,
        padding:  EdgeInsets.only( left:8.0,top: 4.0,bottom: 4.0),
        child : Image.asset("assets/share_white.png",scale: widget.iconSize, color: widget.color),
      ),
      onTap: () {
        eventShareTriggered(context);
      },
    );
  }

  void eventShareTriggered(BuildContext context) async {
    var isInternetAvailable = await AppUtils.isInternetAvailable();
    if(isInternetAvailable) {
      dynamicLinksUtils.shareContent(widget.cardDetailData, context: context);
      AnalyticsUtils?.analyticsUtils?.eventShareButtonClicked();
      fireEventDetailCardDoNotChange();
    } else {
      ToastUtils.show(Strings.errorShareInternetNotConnected);
    }
  }
}
