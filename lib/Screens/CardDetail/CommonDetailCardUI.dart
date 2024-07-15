import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/CommentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventDetailPageChangeListener.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Network/Utils/ContentActionApiCalls.dart';
import 'package:tymoff/Screens/CardDetail/CommentView.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Article.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Text.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Youtube.dart';
import 'package:tymoff/Screens/CardDetail/ContentBottomTextUI.dart';
import 'package:tymoff/Screens/CustomWidgets/CommentWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/DownlaodWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/LikeWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ShareWidget.dart';
import 'package:tymoff/Screens/Dialogs/ReportDialogWidget.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/DotsIndicator.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';

import 'CommonDetailCard.dart';
import 'CommonDetailCardUI_Video.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io' show Platform;

class CommonDetailCardUI extends StatefulWidget {
  ActionContentData cardDetailData;
  Function moreOptionModalBottomSheet;
  CommentBloc _commentBloc;
  double skew;
  Function removeContent;
  AppContentType contentType;

  CommonDetailCardUI(this.cardDetailData, this.moreOptionModalBottomSheet,
      this._commentBloc, this.skew,
      {this.removeContent}) {
    String contentUrl;
    try {
      contentUrl = cardDetailData?.contentUrl[0].url;
    } catch(e) {}

    contentType = ContentTypeUtils.getType(cardDetailData.typeId, contentUrl: contentUrl);
  }

  @override
  _CommonDetailCardUIState createState() => _CommonDetailCardUIState();
}

class _CommonDetailCardUIState extends State<CommonDetailCardUI>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  AccountBloc accountBloc;

  bool _visible = true;
  MediaQueryData _mediaQuery;

  PhotoViewScaleStateController _controllerStatePhotoView;
  double scaleCopy;

  @override
  void didChangeDependencies() {
    _mediaQuery = MediaQuery.of(context);
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    _hideShowAlbumNavigationArrows();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controllerStatePhotoView = PhotoViewScaleStateController();

    _setTimerForNavigationArrowsOpacity();

    _setObservables();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int count = 0;
  void _setObservables() {
    _controllerImageAlbum.addListener(() {
      _hideShowAlbumNavigationArrows();
    });

    var type = widget.contentType;

    if (type == AppContentType.image) {
      eventBus.on<EventDetailPageChangeListener>().listen((event) {
        if (event.isRefreshTriggered) {
          _scaleImageViewToOriginalState();
        }
      });
    }
  }

  void _scaleImageViewToOriginalState() {
    _controllerStatePhotoView.scaleState = PhotoViewScaleState.initial;
  }

  Timer timerAlbumNavigationArrows;
  bool _isNavigationVisibleForcefully = true;

  void _hideShowAlbumNavigationArrows() {
    setState(() {

      if(mounted) {
        _isNavigationVisibleForcefully = true;
        timerAlbumNavigationArrows = Timer.periodic(Duration(milliseconds: 500), (_) {
          _isNavigationVisibleForcefully = false;
          timerAlbumNavigationArrows?.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return cardDetailUI();
  }

/* page view builder */
  final _controllerImageAlbum = new PageController();

  static const _kDuration = const Duration(milliseconds: 200);

  static const _kCurve = Curves.ease;

  var opacityOfNavigation = 1.0;

  Widget getContentContainerWidget() {
    Widget widgetToShow;
    var type = widget.contentType;

    if (type == AppContentType.image) {
      widgetToShow = createPageViewBuilder(widget.cardDetailData.contentUrl);
    } else if (type == AppContentType.video) {
      widgetToShow = CommonDetailCardUI_Video(
          widget.cardDetailData, PlayerType.DETAIL_CARD_CONTROLL);
    } else if (type == AppContentType.text) {
      widgetToShow = getContentContainerWidgetTextOnly();
    } else if (type == AppContentType.article) {
      widgetToShow = CommonDetailCardUI_Article(widget.cardDetailData);
    } else if (type == AppContentType.youtube) {
      widgetToShow = CommonDetailCardUI_Youtube(widget.cardDetailData);
    }
    return widgetToShow;
  }


  Widget getContentContainerWidgetTextOnly() {
    Widget textWidget;

    textWidget = Padding(
      padding: const EdgeInsets.all(16.0),
      child: CommonDetailCardUI_Text(
        widget.cardDetailData,
        fontSize: 24.0,
        textColor: ColorUtils.whiteColor,
      ),
    );

    return textWidget;
  }

  int _imageAlbumPositionSelected = 0;

  void pageChanged(int index) {
    setState(() {
      _imageAlbumPositionSelected = index;
    });
  }

  /// image or album UI method
  Widget createPageViewBuilder(List<ContentUrlData> contentUrl) {
    return (contentUrl != null && (contentUrl?.length ?? 0) > 1)
        ? showImageGallery(contentUrl)
        : showImageWidget(contentUrl[0]);
  }

  Stack showImageGallery(List<ContentUrlData> contentUrl) {
    return Stack(
    children: <Widget>[
      new PageView.builder(
        physics: new NeverScrollableScrollPhysics(),
        controller: _controllerImageAlbum,
        itemCount: contentUrl.length,
        onPageChanged: (index) {
          pageChanged(index);
        },
        itemBuilder: (BuildContext context, int index) {
          return showImageWidget(contentUrl[index]);
        },
      ),
      new Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: new Container(
          color: Colors.black12,
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: DotsIndicator(
              context,
              selectedColor: Colors.white,
              unSelectedColor: Colors.grey[500],
              controller: _controllerImageAlbum,
              itemCount:
              widget?.cardDetailData?.contentUrl?.length ?? 0,
              onPageSelected: (int page) {
                _controllerImageAlbum.animateToPage(
                  page,
                  duration: _kDuration,
                  curve: _kCurve,
                );
              },
            ),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: _previousAlbumPic,
                child: AnimatedOpacity(
                  opacity: isBackwardArrowVisible() ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                      margin: EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Icon(Icons.arrow_back_ios,
                          size: 36.0, color: ColorUtils.iconDetailScreenColor.withOpacity(0.4)),
                      color: Colors.transparent),
                )),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: _nextAlbumPic,
                child: AnimatedOpacity(
                  opacity:
                  isForwardArrowVisible(contentUrl) ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                      margin: EdgeInsets.all(16.0),
                      alignment: Alignment.centerRight,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Icon(Icons.arrow_forward_ios,
                          size: 36.0, color: ColorUtils.iconDetailScreenColor.withOpacity(0.6)),
                      color: Colors.transparent),
                )),
          ),
        ],
      )
    ],
  );
  }

  Widget showImageWidget(ContentUrlData contentData) {

    Widget imageWidget = Container();

    Widget widgetCustomImage =  Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Center(
        child: Stack(
          children: <Widget>[

            CachedNetworkImage(
              imageUrl: contentData.url,
              fit: BoxFit.contain,
              placeholder: (context, url) => getThumbnailImageWidget(contentData),
              placeholderFadeInDuration: Duration(seconds: 1),
              fadeInCurve: Curves.easeInOutCubic,
              fadeInDuration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );

    imageWidget = PhotoView.customChild(child: widgetCustomImage, childSize: const Size(220.0, 250.0),
      initialScale: PhotoViewComputedScale.contained,
    maxScale: 10.0,
    minScale: PhotoViewComputedScale.contained * 0.5,
    enableRotation: false,
    scaleStateController: _controllerStatePhotoView,);

    return imageWidget;
  }

  Widget getThumbnailImageWidget(ContentUrlData contentData) {
    return CachedNetworkImage(
      imageUrl: contentData.thumbnailImage,
    );
  }

  bool isForwardArrowVisible(List<ContentUrlData> contentUrl) {
    bool _isVisible = false;
    if (contentUrl != null && contentUrl.length > 1) {
      var lastIndex = (contentUrl.length) - 1;
      if (_imageAlbumPositionSelected < lastIndex) {
        _isVisible = true;
      }
    }

    return (_isVisible && _isNavigationVisibleForcefully);
  }

  bool isBackwardArrowVisible() {
    bool _isVisible = false;
    if (-_imageAlbumPositionSelected == 0)
      _isVisible = false;
    else
      _isVisible = true;

    return (_isVisible && _isNavigationVisibleForcefully);
  }

  void _previousAlbumPic() {
    _controllerImageAlbum.previousPage(
        duration: new Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  void _nextAlbumPic() {
    _controllerImageAlbum.nextPage(
        duration: new Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  bool isLike() {
    return widget.cardDetailData?.isLike ?? false;
  }

  hitLikeApi() {
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

  bool isBottomTextVisibility = false;

  Widget cardDetailUI() {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: <Widget>[
        Container(
          //height: SizeConfig.screenHeight,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              color: Color(0xff050505),
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                            fit: StackFit.expand,
                            overflow: Overflow.clip,
                            children: <Widget>[

                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: StreamBuilder<StateOfAccount>(
                                    initialData: accountBloc.getAccountState(),
                                    stream: accountBloc.accountStateObservable,
                                    builder: (context, snapshot) {
                                      return GestureDetector(
                                        child: Center(
                                          child: getContentContainerWidget(),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            isBottomTextVisibility = true;
                                          });
                                        },
                                        onDoubleTap: () {
                                          accountBloc.isUserLoggedIn(snapshot?.data)? hitLikeApi() : CustomWidget.showReportContentDialog(context);
                                        },
                                      );
                                    }
                                ),
                              ),

                              /// This code functionality is removed by Andesh..
                              /*_isImageContent()
                            ? Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: contentBottomSupportText(),
                        )
                            : Container()*/
                            ]),
                        flex: 8,
                      ),
                      Visibility(
                        visible: isBottomTextVisibility,
                        child:  !(widget.cardDetailData.contentValue == null ||
                            widget.cardDetailData.contentValue == "") ?
                        Expanded(
                          child : widget.contentType == AppContentType.image ? ContentBottomTextUI(widget.cardDetailData): Container(height: 0.0,width: 0.0,),
                          flex: widget.contentType == AppContentType.image ? 1 : 0,
                        ): Container(height: 0.0,width: 0.0,),
                      ),

                    ],
                  ),
                  flex: 5,
                ),


                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                      color: Color(0xff050505),
                      //color: Colors.yellow,
                      child: bottomSection()),
                  flex: 1,
                ),
              ],
            )),
        makeAnimatedTinderLikeEventUI(
            "assets/like_stamp.png", _getLikeOpacity(), Alignment.topLeft, 330),
        makeAnimatedTinderLikeEventUI("assets/dislike_stamp.png",
            _getDisLikeOpacity(), Alignment.topRight, 30)
      ],
    );
  }

  Widget makeAnimatedTinderLikeEventUI(String _imageAsset, double _opacity,
      AlignmentGeometry _alignment, int _rotationAngle) {
    return Container(
      margin: EdgeInsets.only(top: 60, left: 4.0, right: 4.0),
      alignment: _alignment,
      child: Opacity(
        //opacity: 1,
        opacity: _opacity,
        child: RotationTransition(
            turns: new AlwaysStoppedAnimation(_rotationAngle / 360),
            child: Image.asset(_imageAsset)),
      ),
    );
  }

  /// bottom section UI (like, superlike, more option, comment, report, share)
  Widget bottomSection() {
    var contentUrl;
    if ((widget?.cardDetailData?.contentUrl?.length ?? 0) > 0) {
      contentUrl = widget.cardDetailData.contentUrl[0];
    }
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 400),
      // visible: _isVisible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: LikeWidget(
                          widget.cardDetailData,
                          isComingFromListing: false,
                          iconSize: 2.8,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: CommentWidget(
                          widget.cardDetailData,
                          iconSize : 3.0,
                          commentBloc: widget._commentBloc,
                        ),

                        flex: 2,
                      ),
                    ],
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      width: 50.0,
                      alignment: Alignment.centerLeft,
                      padding:  EdgeInsets.only( left:8.0,top: 4.0,bottom: 4.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Theme
                            .of(context)
                            .unselectedWidgetColor,
                        size: 18.0,
                      ),
                    ),
                    onTap: () {
                      widget.moreOptionModalBottomSheet(
                        context,
                      );

                      EventBusUtils.eventDetailCardDoNotChange(
                          widget.cardDetailData.id.toString());
                    },
                  ),
                  flex: 0,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ReportDialogWidget(
                          contentId: widget.cardDetailData.id,
                          context1: context,
                          iconSize: 3.0,
                          removeContent: widget.removeContent,
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: DownloadWidget(contentUrl, contentId: widget.cardDetailData.id, contentType: widget.contentType),
                        flex: 2,
                      ),
                    ],
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: ShareWidget(
                    isComingFromListing: false,
                    iconSize: 3.0,
                    cardDetailData: widget.cardDetailData,
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                  flex: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  moveToCommentScreen() {
    NavigatorUtils.moveToCommentsScreen(
        context, widget.cardDetailData.id.toString(), widget._commentBloc);
  }

  /// UI for Comment Bottom Sheet
  void commentBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder<CommentPullResponse>(
            initialData: widget._commentBloc.getComments(),
            stream: widget._commentBloc.commentObservable,
            builder: (context, snapshot) {
              return snapshot?.data != null
                  ? Container(
                color: Theme
                    .of(context)
                    .backgroundColor,
                child: new Column(
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
                              child: CustomWidget.getText(
                                  'See all comments',
                                  fontSize: 16.0,
                                  textColor:
                                  ColorUtils.textSelectedColor),
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // close the bottom sheet..

                                NavigatorUtils.moveToCommentsScreen(
                                    context,
                                    widget.cardDetailData.id.toString(),
                                    widget._commentBloc);
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

  double _getLikeOpacity() {
    if (widget.skew > 0) {
      var opacity = (widget.skew / (rotataionDelta / 6));
      return _validOpacity(opacity);
    }
    return 0;
  }

  double _getDisLikeOpacity() {
    if (widget.skew < 0) {
      var opacity = ((-widget.skew) / (rotataionDelta / 6));
      return _validOpacity(opacity);
    }
    return 0;
  }

  double _validOpacity(opacity) {
    if (opacity < 0) {
      return 0;
    } else if (opacity > 1) {
      return 1;
    } else {
      return opacity;
    }
  }

  void _setTimerForNavigationArrowsOpacity() {
    Timer.periodic(Duration(seconds: 10), (_) {
      if (mounted) {
        setState(() {
          opacityOfNavigation = 0.0;
        });
      }
    });
  }
}