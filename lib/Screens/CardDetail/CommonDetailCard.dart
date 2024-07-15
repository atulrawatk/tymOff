import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/CommentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';

import '../../main.dart';
import 'CommonDetailCardUI.dart';

const int rotataionDelta = 18;
double angleSkew = 0.0;
bool isSeakBarEnable = false;

class CommonDetailCard extends StatefulWidget {
  BuildContext context;
  ActionContentData cardDetailData;
  Function dismissContent;
  Function removeContent;
  Function swipeRight;
  Function swipeLeft;

  Size screenSize;

  CommonDetailCard(
      {this.context,
      this.cardDetailData,
      this.dismissContent,
      this.removeContent,
      this.swipeRight,
      this.swipeLeft}) {
    screenSize = MediaQuery.of(context).size;
  }

  @override
  _CommonDetailCardState createState() =>
      _CommonDetailCardState(this.cardDetailData);
}

class _CommonDetailCardState extends State<CommonDetailCard> {
  var typeId;
  var contentType;

  ActionContentData _cardDetailData;
  AccountBloc accountBloc;

  _CommonDetailCardState(this._cardDetailData);

  CommentBloc _commentBloc;

  MetaDataResponse metaDataResponse;
  MetaDataResponseDataCommon _metaReportData;

  void _reportContentChange(MetaDataResponseDataCommon _metaReportData) {
    this._metaReportData = _metaReportData;
  }

  @override
  void initState() {
    _hitAndGetContentDetail();

    typeId = widget.cardDetailData.typeId;
    contentType = ContentTypeUtils.getType(typeId);

    handleCardChangeTimer();

    super.initState();
  }

  void handleCardChangeTimer() {
    if (contentType != null) {
      if (!_isCardChangeEventTriggered) {
        if (contentType != AppContentType.video) {
          _setTimerForNextCard();
        }
      }
    }
  }

  bool _isCardChangeEventTriggered = false;
  Timer _timerNextCard;

  void _setTimerForNextCard() async {

    var scrollTimerSP = await SharedPrefUtil.getAppContentScrollTimer();
    var scrollTimer = scrollTimerSP?.seconds;

    if (scrollTimer != null && scrollTimer > 0) {
      print(
          "Munish Thakur -> _setTimerForNextCard() Trigger Set after $scrollTimer seconds");
      _isCardChangeEventTriggered = true;
      _timerNextCard = Timer.periodic(Duration(seconds: scrollTimer), (_) {
        EventBusUtils.eventDetailCardChange(
            widget.cardDetailData.id.toString());
        _timerNextCard?.cancel();
      });
    }
  }

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    _commentBloc = CommentBloc(context);
    loadCommentData();
    getReportResponse();
    super.didChangeDependencies();
  }

  getReportResponse() async {
    var response = await SharedPrefUtil.getMetaData();
    if (response != null) {
      setState(() {
        metaDataResponse = response;
      });
    }
  }

  loadCommentData() {
    if (_cardDetailData != null) {
      _commentBloc.getCommentData(_cardDetailData.id.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timerNextCard?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return InkWell(
      child: Listener(
        key: new Key(_cardDetailData.id.toString() + "Listener"),
        onPointerMove: _listenerOnPointerMove,
        onPointerUp: _ListenerOnPointerUp,
        child: _dismissibleWidget(),
      ),
      onTap: _userDidSomeActionOnCardDetailScreen,
      onDoubleTap: _userDidSomeActionOnCardDetailScreen,
      onTapDown: _userDidSomeActionOnCardDetailScreenTapDown,
      onTapCancel: _userDidSomeActionOnCardDetailScreen,
    );
  }

  _userDidSomeActionOnCardDetailScreen() {
    print("Munish Thakur -> _userDidSomeActionOnCardDetailScreen()");

    //EventBusUtils.eventDetailCardDoNotChange(widget.cardDetailData.id.toString());
    //_timerNextCard?.cancel();
    //print("Timer cancel");
  }

  void _userDidSomeActionOnCardDetailScreenTapDown(TapDownDetails details) {
    _userDidSomeActionOnCardDetailScreen();
  }

  /// Content Detail Api Call Method
  void _hitAndGetContentDetail() async {
    // TEMP CODE - Munish
    //var contentDetailData = await ApiHandler.getContentDetailData(context, 2481);

    var contentDetailData =
        await ApiHandler.getContentDetailData(context, _cardDetailData.id);

    if (contentDetailData != null && contentDetailData.statusCode == 200) {
      if (mounted) {
        setState(() {
          contentDetailData.data.clone(_cardDetailData);
        });
      }
    }
  }

  Widget _dismissibleWidget() {
    return Dismissible(
      //key: Key(UniqueKey().toString()),
      key: new Key(_cardDetailData.id.toString()),
      //key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.3,
      onResize: dismissibleOnResize,
      onDismissed: dismissibleOnDismissed,
      child: new Transform.rotate(
        angle: (-1) * (pi / 90.0) * angleSkew,
        child: cardDetailUI(),
      ),
    );
  }

  void dismissibleOnResize() {}

  void dismissibleOnDismissed(DismissDirection direction) {
    setState(() {
      angleSkew = 0;
    });

    if (direction == DismissDirection.endToStart)
      widget.swipeLeft(_cardDetailData);
    else
      widget.swipeRight(_cardDetailData);

    widget.dismissContent(_cardDetailData);
    /*
    Future.delayed(const Duration(milliseconds: 500), ()ø {
      widget.dismissContent(_cardDetailData);
    });
*/
    //widget.swipeRight();

    PrintUtils.printLog("DismissibleOnDismissed() START ");
    //_controller.jumpToPage(1);
    /*
    int nextPage = _controller.page.floor() + 1;
    print("DismissibleOnDismissed() nextPage -> $nextPage ");
    if (nextPage < _cardDetailData.contentUrl.length) {
      _controller.jumpToPage(nextPage);
    }*/
    PrintUtils.printLog("DismissibleOnDismissed() END ");
  }

  void _listenerOnPointerMove(PointerMoveEvent event) {
    if (isSeakBarEnable && angleSkew == 0) {
      /*Skip update*/
    } else {
      setState(() {
        if (isSeakBarEnable) {
          angleSkew = 0;
        } else {
          angleSkew = angleSkew +
              rotataionDelta *
                  event.delta.dx /
                  MediaQuery.of(context).size.width;
        }
      });
    }
    //PrintUtils.printLog("Card Movement Value (skew): ${angleSkew}");
  }

  void _ListenerOnPointerUp(PointerUpEvent cancel) {
    setState(() {
      angleSkew = 0;
    });
  }

  void removeContentFunction() {
    widget.removeContent(_cardDetailData);
  }

  Widget cardDetailUI() {
    Widget cardDetailUI = Container();

    cardDetailUI = GestureDetector(
      child: CommonDetailCardUI(
          _cardDetailData, moreOptionModalBottomSheet, _commentBloc, angleSkew,
          removeContent: removeContentFunction),
      behavior: HitTestBehavior.opaque,
      onTap: _userDidSomeActionOnCardDetailScreen,
      onDoubleTap: _userDidSomeActionOnCardDetailScreen,
      onTapDown: _userDidSomeActionOnCardDetailScreenTapDown,
      onTapCancel: _userDidSomeActionOnCardDetailScreen,
    );
/*
    cardDetailUI = InkWell(
      child: CommonDetailCardUI(
          _cardDetailData, moreOptionModalBottomSheet, _commentBloc, angleSkew,
          removeContent: removeContentFunction),
      onTap: _userDidSomeActionOnCardDetailScreen,
      onDoubleTap: _userDidSomeActionOnCardDetailScreen,
      onTapDown: _userDidSomeActionOnCardDetailScreenTapDown,
      onTapCancel: _userDidSomeActionOnCardDetailScreen,
    );*/

    return cardDetailUI;
  }

  /// More Option Bottom Sheet UI
  void moreOptionModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Theme.of(context).backgroundColor,
              child: somethingBottom());
        });
  }

  Widget somethingBottom() {
    return Container(
      child: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: CustomWidget.getText(Strings.moreoptions,
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  height: 2.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                bottomSheetDetails("assets/copy_link.png", Strings.copylink,
                    "Add this link to your post", ontap: () {
                  dynamicLinksUtils.copyLinkToClipboard(context, _cardDetailData);
                }),
                SizedBox(
                  height: 20.0,
                ),
                bottomSheetDetails("assets/hide_post.png", Strings.hidePost,
                    Strings.dontWantToSeeThisPost, ontap: () {
                  accountBloc.isUserLoggedIn(snapshot?.data)
                      ? _hitHideApi()
                      : CustomWidget.showReportContentDialog(context);
                  AnalyticsUtils?.analyticsUtils?.eventHidepostButtonClicked();
                }),
                SizedBox(
                  height: 30.0,
                ),
              ],
            );
          }),
    );
  }

  /// Inside UI for More Option Bottom Sheet...
  Widget bottomSheetDetails(image, String text, String text1, {ontap}) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Image.asset(
              image,
              scale: 3.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomWidget.getText(text,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 14.0)),
                CustomWidget.getText(text1,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(fontSize: 12.0)),
              ],
            ),
          ],
        ),
      ),
      onTap: ontap,
    );
  }

  /// Report Content Api Call Method...

  _hitHideApi() async {
    var response = await ApiHandler.reportContentHide(
        context, widget.cardDetailData.id.toString(), "10", "Hide");

    if (response != null && response.statusCode == 200) {
      SnackBarUtil.showSnackBar(context, response.message);
    }

    Navigator.pop(context);
    widget.removeContent(_cardDetailData);
  }
}
