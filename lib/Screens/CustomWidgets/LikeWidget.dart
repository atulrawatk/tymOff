import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Network/Utils/ContentActionApiCalls.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';

class LikeWidget extends StatefulWidget {

  final double iconSize;
  final bool isComingFromListing;
  final ActionContentData cardDetailData;
  final Color color;

  LikeWidget(this.cardDetailData,
      {this.iconSize, this.isComingFromListing, this.color});

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  // bool isLike = false;
  AccountBloc accountBloc;

  ContentDetailResponse response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /* if(cardDetailData != null){
       setState(() {
         isLike = cardDetailData.isLike;
       });
     }*/
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }

  bool isLike() {
    return widget.cardDetailData?.isLike ?? false;
  }

  hitApi() {
    ContentActionApiCalls.hitLikeApi(
        context, this, !isLike(), widget.cardDetailData,
        func1: toggleIconAndData);
  }

  void toggleIconAndData() {
    if (isLike()) {
      setState(() {
        widget.cardDetailData.isLike = false;
        if (widget.cardDetailData.likeCount > 0) {
          --widget.cardDetailData.likeCount;
        }
      });
    } else {
      SnackBarUtil.showSnackBar(context, "Liked");
      setState(() {
        widget.cardDetailData.isLike = true;
        ++widget.cardDetailData.likeCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshot) {
            return widget.isComingFromListing == true
                ? Container(
                    width: 40.0,
                    color: Colors.transparent,
                    padding:
                        const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: isLike()
                              ? Image.asset(
                                  "assets/Superlike_active.png",
                                  scale: 4.0,
                                )
                              : Image.asset(
                                  "assets/heart_unfill.png",
                                  scale: 4.0,
                                ),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        CustomWidget.getText(
                            AppUtils.getFormattedInt(
                                    widget.cardDetailData?.likeCount) ??
                                "0",
                            style: Theme.of(context).textTheme.body1)
                      ],
                    ),
                  )
                : GestureDetector(
                    child: Container(
                      // height: 50.0,
                      width: 50.0,
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          isLike()
                              ? Image.asset(
                                  "assets/Superlike_active.png",
                                  scale: widget.iconSize,
                                )
                              : Image.asset(
                                  "assets/Superlike_inactive.png",
                                  scale: widget.iconSize,
                                  color: widget.color,
                                ),
                          SizedBox(
                            width: 5.0,
                          ),
                          CustomWidget.getText(
                              (AppUtils.getFormattedInt(
                                      widget.cardDetailData?.likeCount) +
                                  " Likes"),
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                      color: widget.color, fontSize: 14.0)),
                        ],
                      ),
                    ),
                    onTap: () {
                      AnalyticsUtils?.analyticsUtils?.eventlikeButtonClicked();
                      accountBloc.isUserLoggedIn(snapshot?.data)
                          ? hitApi()
                          : CustomWidget.showReportContentDialog(context);
                    },
                  );
          }),
    );
  }
}
