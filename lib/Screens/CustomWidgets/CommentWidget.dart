import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/CommentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Screens/CardDetail/CommentView.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class CommentWidget extends StatefulWidget {
  final double iconSize;
  final bool isComingFromListing;
  final CommentBloc commentBloc;
  final ActionContentData cardDetailData;

  CommentWidget(this.cardDetailData,
      {this.iconSize, this.isComingFromListing, this.commentBloc});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
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

  void fireEventDetailCardDoNotChange() {
    if (widget?.cardDetailData?.id != null) {
      EventBusUtils.eventDetailCardDoNotChange(
          widget.cardDetailData.id.toString());
    }
  }

  moveToCommentScreen() {
    NavigatorUtils.moveToCommentsScreen(
        context, widget.cardDetailData.id.toString(), widget.commentBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommentPullResponse>(
        initialData: widget.commentBloc.getComments(),
        stream: widget.commentBloc.commentObservable,
        builder: (context, snapshot) {
          return buildMainView(context, snapshot);
        });
  }

  Widget buildMainView(
      BuildContext context, AsyncSnapshot<CommentPullResponse> snapshot) {
    return Container(
      child: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshotAccount) {
            return widget.isComingFromListing == true
                ? StreamBuilder<CommentPullResponse>(
                    initialData: widget.commentBloc.getComments(),
                    stream: widget.commentBloc.commentObservable,
                    builder: (context, snapshotComments) {
                      return GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 4.0, top: 4.0, bottom: 4.0),
                            color: Colors.transparent,
                            width: 40.0,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.asset("assets/comment.png",
                                        scale: 4.0,
                                        color:
                                            Theme.of(context).iconTheme.color)),
                                /* SizedBox(width: 2.0,),
                            CustomWidget.getText(snapshot?.data?.totalElements?.toString()?? "0",style: Theme.of(context).textTheme.body1),*/
                              ],
                            )),
                        onTap: () {
                          print("comment hit");
                          accountBloc.isUserLoggedIn(snapshotAccount?.data)
                              ? (snapshotComments
                                              ?.data?.data?.dataList?.length ??
                                          0) >
                                      0
                                  ? commentBottomSheet()
                                  : moveToCommentScreen()
                              : CustomWidget.showReportContentDialog(context);

                          fireEventDetailCardDoNotChange();
                        },
                      );
                    })
                : StreamBuilder<CommentPullResponse>(
                    initialData: widget.commentBloc.getComments(),
                    stream: widget.commentBloc.commentObservable,
                    builder: (context, snapshotComments) {
                      return GestureDetector(
                        child: Container(
                            // height: 50.0,
                            width: 50.0,
                            color: Colors.transparent,
                            padding: EdgeInsets.only(
                                left: 8.0, top: 4.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/comment.png",
                                    scale: widget.iconSize,
                                    color: ColorUtils.iconDetailScreenColor),
                                SizedBox(
                                  width: 5.0,
                                ),
                                CustomWidget.getText("Comment",
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            color: ColorUtils
                                                .textDetailScreenColor,
                                            fontSize: 14.0)),
                              ],
                            )),
                        onTap: () {
                          AnalyticsUtils?.analyticsUtils
                              ?.eventlikeButtonClicked();
                          accountBloc.isUserLoggedIn(snapshotAccount?.data)
                              ? (snapshotComments
                                              ?.data?.data?.dataList?.length ??
                                          0) >
                                      0
                                  ? commentBottomSheet()
                                  : moveToCommentScreen()
                              : CustomWidget.showReportContentDialog(context);
                          fireEventDetailCardDoNotChange();
                        },
                      );
                    });
          }),
    );
  }

  void commentBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder<CommentPullResponse>(
            initialData: widget.commentBloc.getComments(),
            stream: widget.commentBloc.commentObservable,
            builder: (context, snapshot) {
              return snapshot?.data != null
                  ? Container(
                      color: Theme.of(context).backgroundColor,
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18.0,
                                bottom: 12.0,
                                left: 14.0,
                                right: 14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomWidget.getText(
                                    (snapshot?.data?.totalElements
                                                ?.toString() ??
                                            "0") +
                                        " " +
                                        "comments",
                                    fontSize: 19.0,
                                    textColor: ColorUtils.blackColor,
                                    fontWeight: FontWeight.w500),
                                GestureDetector(
                                    child: Container(
                                      height: 25.0,
                                      color: Colors.transparent,
                                      child: CustomWidget.getText(
                                          'See all comments',
                                          fontSize: 16.0,
                                          textColor:
                                              ColorUtils.textSelectedColor),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop(); // close the bottom sheet..

                                      NavigatorUtils.moveToCommentsScreen(
                                          context,
                                          widget.cardDetailData.id.toString(),
                                          widget.commentBloc);

                                      fireEventDetailCardDoNotChange();
                                    }),
                              ],
                            ),
                          ),
                          (snapshot?.data?.data?.dataList?.length ?? 0) > 0
                              ? getCommentList(snapshot?.data?.data?.dataList)
                              : getNoCommentWidget()
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
            },
          );
        });
  }

  Widget getCommentList(List<CommentPullDataList> commentsList) {
    var sizeOfList =
        ((commentsList?.length ?? 0) > 2) ? 2 : (commentsList?.length ?? 0);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sizeOfList,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: CommentView(commentsList[index]),
        );
      },
    );
  }

  Widget getNoCommentWidget() {
    return Expanded(
      child: Center(
        child: Container(
          child: Text("Be the first to comment"),
        ),
      ),
    );
  }
}
