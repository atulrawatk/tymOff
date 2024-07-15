import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventDetailCardChange.dart';
import 'package:tymoff/Network/Api/ApiHandlerUtils.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Utils/ContentActionApiCalls.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCard.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SizeConfig.dart';

import 'CommonDetailCardUI_Video.dart';

class CardDetailPage extends StatefulWidget {

  final List<ActionContentData> content;
  final int _initialPage;
  final ContentBloc _blocContent;
  final int _DEFAULT_THRESHOLD_LOAD_MORE_CONTENT = 5;

  CardDetailPage(this._blocContent, this.content, this._initialPage);

  @override
  _CardDetailPageState createState() => _CardDetailPageState(this.content);
}

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[]);

class _CardDetailPageState extends State<CardDetailPage> {
  static final riContentListingKey1 = const Key('__RIKEY1_CardDetailPage__');
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  PageController _controller;
  var currentPageValue = 0.0;

  var hmContentDoNotScroll = HashMap<String, String>();

  void initState() {
    super.initState();

    _controller = PageController(
        initialPage: widget._initialPage, keepPage: true, viewportFraction: 1);
    _addPageViewListener();
    _setObservables();

    currentPageValue = widget._initialPage.toDouble();
    _setTimerForNextCard();
    //contentListingScrollToIndex(currentPageValue.toInt());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //_buttonController.dispose();
    super.dispose();
    contentListingScrollToIndex(currentPageValue.toInt());
    AppUtils.screenKeepOn(false);
    hmContentDoNotScroll.clear();
  }


  Timer _timerNextCard;
  int _cardChangeCount = 0;

  void _setTimerForNextCard() async {
    bool isFirstTimeContentCardScrollEventCompleted = await SharedPrefUtil.isFirstTimeContentCardScrollEventCompleted();

    int scrollTimer = Constant.DEFAULT_DETAIL_CARD_SCROLL_TIME;
    if (!isFirstTimeContentCardScrollEventCompleted) {
      scrollTimer = (scrollTimer ~/ 5);

      print(
          "Munish Thakur -> _setTimerForNextCard() Trigger Set after $scrollTimer seconds");
      _timerNextCard = Timer.periodic(Duration(seconds: scrollTimer), (_) {
        if(_cardChangeCount > 2) {
          _timerNextCard?.cancel();
          SharedPrefUtil.setIsFirstContentCardScrollEventCompleted(true);
        } else {
          print("Munish Thakur -> CardDetailPage -> _setTimerForNextCard() Trigger Fired after $scrollTimer seconds");
          EventBusUtils.eventDetailCardChange(
              _content[_cardChangeCount].id.toString());
        }
        ++_cardChangeCount;
      });
    }
  }

  List<ActionContentData> _content = List();

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  String radioValue = "";

  _CardDetailPageState(List<ActionContentData> content) {
    _content = content;
  }

  void newContentlist(List<ActionContentData> contentList) {
    try {
      if (mounted && contentList.length > 0) {
        setState(() {
          _content.clear();
          _content.addAll(contentList);
        });
      } else if (contentList.length > 0) {
        _content.clear();
        _content.addAll(contentList);
      }
    } catch (e) {
      PrintUtils.printLog(
          "Munish Thakur -> CardDetailPage -> newContentlist() -> Exception: ${e.toString()}");
    }
  }

  var isOpen = false;
  var isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: InkWell(
          child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.iconDetailScreenColor,
                size: 30.0,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0.0,
      ),
      body: _getContentUIList(),
    );
  }

  PageView buildPageView() {
    return PageView.builder(
        itemCount: _content?.length ?? 0,
        scrollDirection: Axis.vertical,
        controller: _controller,
        itemBuilder: (context, i) {
          return CommonDetailCard(
              context: context,
              cardDetailData: _content[i],
              dismissContent: dismissContent,
              removeContent: removeContent,
              swipeRight: swipeRight,
              swipeLeft: swipeLeft);
        });
  }

  Widget _getContentUIList() {
    return Container(
      color: Colors.black,
      // color: Theme.of(context).backgroundColor,
      child: NotificationListener<ScrollNotification>(
        key: riContentListingKey1,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefreshContentList,
          child: buildPageView(),
        ),
      ),
    );
  }

  Future<void> _onRefreshContentList() async {
    //Holding pull to refresh loader widget for 2 sec.
    //You can fetch data from server.

    await new Future.delayed(const Duration(seconds: 1));

    widget._blocContent
        .getContentData(contentAddDirection: ContentAddDirection.TOP);
    //widget._blocContent.reloadContentList(true);
    widget._blocContent.contentObservable.listen((contentList) {
      if (mounted) {
        setState(() {
          int pageToBeOn = ApiHandlerUtils.CONTENT_LOADING_SIZE;

          _content = contentList?.data;
          restartToContentDetailScreen(pageToBeOn);
        });
      }
    });

    //restartToContentDetailScreen(0);
  }

  void restartToContentDetailScreen(int page) {
    try {
      Navigator.pop(context);
      if(_content.length > 0) {
        NavigatorUtils.moveToContentDetailScreen(
            context, widget._blocContent, _content, page);
      }
    } catch (e) {
      print(
          "Munish Thakur -> CardDetailPage -> restartToContentDetailScreen() -> ${e.toString()}");
    }
  }

  void _addPageViewListener() {
    if (widget._blocContent != null) {
      _controller.addListener(() async {
        EventBusUtils.eventDetailPageChange();

        currentPageValue = _controller.page;

        await Future.forEach(hmVideoController?.keys, (_videoId) async {
          var contentData = _content[currentPageValue.floor()];
          int contentDataId = contentData.id;

          //PrintUtils.printLog("Munish -> contentDataId: $contentDataId, _videoId: $_videoId");
          try {
            var _videoController = hmVideoController[_videoId];
            if (contentDataId != _videoId) {
              _videoController?.pause();
            } else {
              _videoController?.play();
            }
          } catch (e) {
            PrintUtils.printLog(
                "Munish -> Pause video exception -> ${e.toString()}");
          }
        });

        setState(() {
          //PrintUtils.printLog("PageView currentPageValue -> $currentPageValue");
          if ((currentPageValue + widget._DEFAULT_THRESHOLD_LOAD_MORE_CONTENT) >
              (_content?.length ?? 0)) {
            PrintUtils.printLog("PageView end is near..");
            loadMoreData();
          }
        });
      });
    }
  }

  void contentListingScrollToIndex(int currentPageIndex) {
    if(currentPageIndex != null) {
      widget._blocContent.scrollToIndex(currentPageIndex.toInt());
    }
  }

  void loadMoreData() {
    widget._blocContent?.getContentData();
  }

  void _setObservables() {
    setEventBusObserver();
  }

  void setEventBusObserver() {
    eventBus.on<EventDetailCardChange>().listen((event) {
      changeCard(event);
    });

    eventBus.on<EventDetailCardDoNotChange>().listen((event) {
      doNotChangeCard(event);
    });
  }

  void doNotChangeCard(EventDetailCardDoNotChange event) {
    if (event != null && event.contentIdToChange != null) {
      print("Munish Thakur -> Event doNotChangeCard()");
      hmContentDoNotScroll[event.contentIdToChange] =
          event.direction.toString();
    }
  }

  bool _isCardCanScroll(String contentId) {
    if(contentId != null) {
      return !hmContentDoNotScroll.containsKey(contentId);
    }
    return false;
  }

  int _cardChangeDurationInMillis = 900;
  void changeCard(EventDetailCardChange event) {
    try {
      var _isCardCanChange = _isCardCanScroll(event.contentIdToChange);
      print("Munish Thakur -> Event changeCard() -> ${event.contentIdToChange}, cardCanChange: $_isCardCanChange");
      if (event != null && _isCardCanChange) {
        double currentPage = _controller.page;
        var contentData = _content[currentPage.floor()];
        String contentDataId = contentData.id.toString();
        if (contentDataId == event.contentIdToChange) {
          if (event.direction == DIRECTION.NEXT) {
            _controller.nextPage(
                duration: Duration(milliseconds: _cardChangeDurationInMillis), curve: Curves.easeIn);
          } else {
            _controller.previousPage(
                duration: Duration(milliseconds: _cardChangeDurationInMillis), curve: Curves.easeOut);
          }
        }
      }
    } catch (e) {}
  }

  dismissContent(ActionContentData contentToRemove) {
    if (_content.contains(contentToRemove)) {
      int currentPage = _controller.page.floor();

      setState(() {
        _content.remove(contentToRemove);
      });

      PrintUtils.printLog("");
      _content.insert(currentPage, contentToRemove);
      _controller.jumpToPage(currentPage + 1);
    }
  }

  dismissContentAgain(ActionContentData contentToRemove) {
    if (_content.contains(contentToRemove)) {
      _content.remove(contentToRemove);
    }
  }

  removeContent(ActionContentData contentToRemove) {
    if (_content.contains(contentToRemove)) {
      int currentPage = _controller.page.floor();
      _controller.jumpToPage(currentPage + 1);

      setState(() {
        _content.remove(contentToRemove);
      });

      restartToContentDetailScreen(currentPage);
    }
  }

  swipeRight(ActionContentData contentToRemove) {
    ContentActionApiCalls.hitLikeApi(context, this, true, contentToRemove, contentBloc: widget._blocContent);
  }

  swipeLeft(ActionContentData contentToRemove) {
    ContentActionApiCalls.hitFavouriteApi(context, this, true, contentToRemove);
  }
}
