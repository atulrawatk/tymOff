import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventRefreshContent.dart';
import 'package:tymoff/Network/Api/ApiHandlerUtils.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/Others/EmptyScreen.dart';
import 'package:tymoff/Screens/Search/ContentFilterByGenreScreen.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

import 'ContentListingShimmerLoadingNew.dart';
import 'ContentListingTile.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class CustomScrollPhysics extends ScrollPhysics {
  @override
  ScrollPhysics applyTo(ScrollPhysics ancestor) {
    // TODO: implement applyTo
    return CustomScrollPhysics();
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // TODO: implement createBallisticSimulation
    return super.createBallisticSimulation(position, (velocity));
  }
}

enum DIRECTION { PREVIOUS, NEXT }

class ContentListing extends StatefulWidget {
  ContentBloc blocContent;
  bool _isContentTypeFilterVisible = false;
  bool _isGenreFilterVisible = false;
  bool _isGenreFilterSelectedVisible = false;
  bool _isAutoRefreshFeedAvailable = false;
  bool _isContentScrollPositionUpdateWithDetailScrollApplicable = true;
  bool _isGenresSelected = false;
  bool _isDeleteEnabled = false;
  bool _isShowFirstTimePreview = false;
  String _searchText = "";
  String _discoverId = "";

  final GetOffsetMethod getOffsetMethod;
  final SetOffsetMethod setOffsetMethod;
  Function functionScrollListener;

  ContentListing(
      {this.blocContent,
      bool isContentTypeFilterVisible,
      bool isGenreFilterVisible,
      bool isGenreFilterSelectedVisible,
      bool isGenresSelected,
      bool isAutoRefreshFeedAvailable,
      bool isContentScrollPositionUpdateWithDetailScrollApplicable,
      bool isDeleteEnabled,
      bool isShowPreviewEnabled,
      searchText: "",
      discoverId: "",
      this.getOffsetMethod,
      this.setOffsetMethod,
      this.functionScrollListener}) {
    _isContentTypeFilterVisible = AppUtils.isValid(isContentTypeFilterVisible,
        defaultReturn: _isContentTypeFilterVisible);
    _isGenreFilterVisible = AppUtils.isValid(isGenreFilterVisible,
        defaultReturn: _isGenreFilterVisible);
    _isGenreFilterSelectedVisible = AppUtils.isValid(
        isGenreFilterSelectedVisible,
        defaultReturn: _isGenreFilterSelectedVisible);
    _isGenresSelected =
        AppUtils.isValid(isGenresSelected, defaultReturn: _isGenresSelected);
    _isAutoRefreshFeedAvailable = AppUtils.isValid(isAutoRefreshFeedAvailable,
        defaultReturn: _isAutoRefreshFeedAvailable);
    _isContentScrollPositionUpdateWithDetailScrollApplicable = AppUtils.isValid(
        isContentScrollPositionUpdateWithDetailScrollApplicable,
        defaultReturn:
            _isContentScrollPositionUpdateWithDetailScrollApplicable);
    _isDeleteEnabled =
        AppUtils.isValid(isDeleteEnabled, defaultReturn: _isDeleteEnabled);
    _isShowFirstTimePreview = AppUtils.isValid(isShowPreviewEnabled,
        defaultReturn: _isShowFirstTimePreview);
    _searchText = searchText;
    _discoverId = discoverId;
  }

  updateSearchText(String searchText) {
    //contentListingState.setSeachText(searchText);
    blocContent?.updateSearchText(searchText);
  }

  clickOnIndex(int index) {
    blocContent?.clickOnIndex(index);
  }

  @override
  ContentListing_DynamicHeightState createState() =>
      ContentListing_DynamicHeightState();
}

class ContentListing_DynamicHeightState extends State<ContentListing>
    with AutomaticKeepAliveClientMixin //,SingleTickerProviderStateMixin
{
  /* AnimationController _animationController;
  Animation<Color> animation;*/

  static const widgetTag = "ContentListing_DynamicHeightState";

  @override
  bool get wantKeepAlive {
    return true;
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>(debugLabel: widgetTag);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>(debugLabel: widgetTag);
  final riContentListingKey1 = const Key('__RIKEY1_$widgetTag __');
  final riContentListingKeyEmpty = const Key('__RIKEY1_Empty_$widgetTag __');

  ContentBloc blocContent;

  double _width = 0.0;
  int _cardHorizontalCount = 2;

  @override
  void deactivate() {
    super.deactivate();
  }

  /// dispose animation controller...
  @override
  void dispose() {
    //_animationController.dispose();
    super.dispose();
    //widget?.blocContent?.removeScrollToIndexListener();
  }

  @override
  void initState() {
    super.initState();

    _setTimerForUserGuideContainer();

    //setAnimation();
    _setScrollController();

    initializeScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initializeScreen() {
    if (ContentListingTile.isDynamicHeight) {
      {
        _width = MediaQuery.of(context).size.width;
        _cardHorizontalCount = _width ~/ ContentListingTile.cardWidth;

        if (_cardHorizontalCount < 2) {
          ContentListingTile.cardWidth = (_width - 10) / 2;
          _cardHorizontalCount = _width ~/ ContentListingTile.cardWidth;
        }
      }
    }

    if (widget.blocContent == null) {
      widget.blocContent = ContentBloc();
      setSeachText(widget._searchText);
      widget.blocContent.setDiscoverId(widget._discoverId);
    }

    _getMetaData();

    blocContent = widget.blocContent;

    blocContent.reloadContentList(false);
    setObservers();

    if (widget._isAutoRefreshFeedAvailable) {
      addFeedRefreshTimer();
      checkNewFeedAndShow();
    }
  }

  bool _showNewFeedChip = false;

  void addFeedRefreshTimer() {
    Timer.periodic(
        Duration(minutes: ApiHandlerUtils.contentFeedRefreshTimeInMinutes),
        (_) {
      checkNewFeedAndShow();
    });
  }

  void checkNewFeedAndShow() {
    try {
      DateTime firstLoadedDateTime =
          widget.blocContent.getFirstLoadedContentDateTime();

      bool showNewFeedChip =
          ApiHandlerUtils.isContentListingRefreshNeeded(firstLoadedDateTime);

      setShowFeedRefreshChip(showNewFeedChip);
    } catch (e) {
      print(
          "Munish Thakur -> ContentListing -> checkNewFeedAndShow() -> ${e.toString()}");
      setShowFeedRefreshChip(false);
    }
  }

  void setShowFeedRefreshChip(bool showNewFeedChip) {
    if (mounted) {
      setState(() {
        if (showNewFeedChip != null) {
          _showNewFeedChip = showNewFeedChip;
        }
      });
    }
  }

  void setSeachText(String searchText) {
    widget.blocContent.setSearchText(searchText);
  }

  AutoScrollController scrollControllerGridView;
  ScrollController scrollControllerEmptyView;

  var countScrollObserver = 0;

  void setObservers() {
    eventBus.on<EventRefreshContent>().listen((event) {
      blocContent.reloadContentList(true);
    });

    widget?.blocContent?.listScrollToIndexObservables?.listen((scrollPosition) {
      print(
          "Munish Thakur -> ContentListing -> widget?.blocContent?.listScrollToIndexObservables -> $scrollPosition -> countScrollObserver: $countScrollObserver");
      //if(countScrollObserver == 1) {
      _smoothScrollToIndex(scrollPosition);
      //}
      countScrollObserver++;
    });

    widget?.blocContent?.listClickOnIndexObservables?.listen((clickIndex) {});
  }

  void _setScrollController() {
    var initialScrollOffset = 0.0;
    if (widget.getOffsetMethod != null) {
      initialScrollOffset = widget.getOffsetMethod();
    }

    scrollControllerGridView =
        new AutoScrollController(initialScrollOffset: initialScrollOffset);
    scrollControllerEmptyView = new ScrollController();
  }

  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<ActionContentListResponse>(
        stream: blocContent.contentObservable,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldState,
            body: checkSnapshotAndReturnWidget(snapshot),

          );
        });
  }

  Widget checkSnapshotAndReturnWidget(AsyncSnapshot<ActionContentListResponse> snapshot) {
    if (snapshot.data != null && (snapshot?.data?.data?.length ?? 0) <= 0) {
      return emptyView();
    }
    
    return nestedScrollView(snapshot);
  }
  
  Widget nestedScrollView(AsyncSnapshot<ActionContentListResponse> snapshot) {
    return NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return getHeaderFilterWidgets();
        },
        body: _getContentListWidget(snapshot));
  }

  Widget emptyView() {
    Widget emptyScreenChild = Center(child: EmptyScreen(
      profileActionType: widget.blocContent.getProfileActionType(),
    ),);

    Widget listView = ListView(
      children: <Widget>[
        emptyScreenChild,
      ],
    );

    Widget contentUI = getWidgetWithPullToRefresh(listView);

    return contentUI;
  }

  void _loadMoreData({bool isHardRefresh = false}) {
    blocContent.getContentData(isHardRefresh: isHardRefresh);
  }

  List<Widget> getHeaderFilterWidgets() {
    List<Widget> listOfHeaderFilterWidget = List();

    if (widget._isGenreFilterVisible) {
      listOfHeaderFilterWidget.add(_getGenreFilterWidget());
    }
    if (widget._isContentTypeFilterVisible) {
      listOfHeaderFilterWidget.add(_getContentTypeFilterWidget());
    }

    if (widget._isGenreFilterSelectedVisible) {
      listOfHeaderFilterWidget.add(_getGenreSelectedFilterWidget());
    }

    return listOfHeaderFilterWidget;
  }

  // Filters

  void _getMetaData() async {
    var metaData = await SharedPrefUtil.getMetaData();
    setState(() {
      if (metaData?.data?.genres != null) {
        blocContent.listOfGenres.clear();
        blocContent.listOfGenres.addAll(metaData?.data?.genres);
      }
      if (metaData?.data?.formats != null) {
        blocContent.listOfContentTypeFilter.clear();
        blocContent.listOfContentTypeFilter.addAll(metaData?.data?.formats);
      }
    });
    print("Meta Data found");
  }

  void _setSelectionContentType(
    MetaDataResponseDataCommon contentItem, {
    bool isAddOnly = false,
    bool isDeleteOnly: false,
  }) {
    setState(() {
      blocContent.updateContentFilterSelection(contentItem,
          isAddOnly: isAddOnly, isDeleteOnly: isDeleteOnly);
    });
  }

  void _setSelectionGenre(
    MetaDataResponseDataCommon genreItem, {
    bool isAddOnly = false,
    bool isDeleteOnly: false,
  }) {
    setState(() {
      blocContent.updateGenreSelection(this, genreItem,
          isAddOnly: isAddOnly, isDeleteOnly: isDeleteOnly);
    });
  }

  Widget _getContentTypeFilterWidget() {
    return new SliverAppBar(
      forceElevated: false,
      pinned: true,
      bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 28.0,
              width: double.infinity,
              child: buildListOfContentFilters(context),
            ),
          ),
          preferredSize: Size(0.0, -2.0)),
    );
  }

  Widget _getGenreFilterWidget() {
    return new SliverAppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      pinned: true,
      bottom: PreferredSize(
          child: Container(
            height: 45.0,
            width: double.infinity,
            child: buildListOfGenres(context, blocContent.listOfGenres),
          ),
          preferredSize: Size(0.0, -10.0)),
    );
  }

  Widget _getGenreSelectedFilterWidget() {
    if (blocContent.getSelectedGenreItems().length > 0) {
      return new SliverAppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        pinned: true,
        bottom: PreferredSize(
            child: Container(
              height: 45.0,
              width: double.infinity,
              child: buildListOfSelectedGenres(
                  context, blocContent.getSelectedGenreItems()),
            ),
            preferredSize: Size(0.0, 0.0)),
      );
    } else {
      return new SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Container(),
          childCount: 0,
        ),
      );
    }
  }

  void _handleFirstTimeContentCardClickEvent(
      List<ActionContentData> data) async {
    try {
      bool isFirstTimeContentCardClickEventCompleted =
          await SharedPrefUtil.isFirstTimeContentCardClickEventCompleted();
      if (!isFirstTimeContentCardClickEventCompleted &&
          widget._isShowFirstTimePreview &&
          data != null) {
        widget._isShowFirstTimePreview = false;
        startTimeAndClickCard(data);
      }
    } catch (e) {
      PrintUtils.printLog(
          "Error in _handleFirstTimeAppOpenLogin() -> ${e.toString()}");
    }
  }

  Widget _getContentUIList(List<ActionContentData> data) {
    _handleFirstTimeContentCardClickEvent(data);

    return Container(
      color: Theme.of(context).backgroundColor,
      child: NotificationListener<ScrollNotification>(
        //key: riContentListingKey1,
        onNotification: (ScrollNotification scrollInfo) {
          double currentPixel = scrollInfo.metrics.pixels;

          _setScrollOffset(currentPixel);

          if (currentPixel == scrollInfo.metrics.maxScrollExtent) {
            _loadMoreData(isHardRefresh: false);
          }

          if (widget.functionScrollListener != null)
            widget.functionScrollListener(currentPixel);

          return true;
        },
        child: getWidgetWithPullToRefresh(staggeredGridViewContent(data)),
      ),
    );
  }

  Widget getWidgetWithPullToRefresh(Widget child) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefreshContentList,
      child: child,
    );
  }

  Widget _getShimmerList() {
    return Container(
      // color: Theme.of(context).backgroundColor,
      child: getWidgetWithPullToRefresh(ContentListingShimmerLoading()),
    );
  }

  void _setScrollOffset(double offsetData) {
    if (widget.setOffsetMethod != null && offsetData != null) {
      widget.setOffsetMethod(offsetData);
    }
  }

  void _smoothScrollToOffset(double offsetData) {
    try {
      if (scrollControllerGridView != null &&
          offsetData != null &&
          offsetData >= 0) {
        scrollControllerGridView.scrollToIndex(10);
      }
    } catch (e) {
      print("Munish -> Exception -> _smoothScrollToOffset() -> $e");
    }
  }

  var lastScrollIndex = 0;

  void _smoothScrollToIndex(int index) {
    try {
      if (widget._isContentScrollPositionUpdateWithDetailScrollApplicable) {
        if (((index - lastScrollIndex) > 4) ||
            ((index - lastScrollIndex) < -4)) {
          if (scrollControllerGridView != null && index != null && index >= 0) {
            //scrollControllerGridView.highlight(index, cancelExistHighlights: true);

            print(
                "Munish Thakur -> ContentListing -> _smoothScrollToIndex() -> Index -> $index, lastScrollIndex -> $lastScrollIndex");
            lastScrollIndex = index;
            scrollControllerGridView.scrollToIndex(index,
                duration: Duration(seconds: 1));
          }
        }
      }
    } catch (e) {
      print("Munish -> Exception -> _smoothScrollToOffset() -> $e");
    }
  }

  StaggeredGridView staggeredGridViewContent(List<ActionContentData> data) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      controller: scrollControllerGridView,
      physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
      itemCount: data.length,
      primary: false,
      crossAxisCount: (_cardHorizontalCount * _cardHorizontalCount),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      itemBuilder: (context, index) {
        ///Temp comment

        return AutoScrollTag(
          key: ValueKey(index),
          controller: scrollControllerGridView,
          index: index,
          child: new ContentListingTile(
            blocContent,
            index,
            data,
            isDeleteEnabled: widget._isDeleteEnabled,
          ),
          highlightColor: Colors.black.withOpacity(0.1),
        );

        //return new ContentListingTile(blocContent, index, data);
      },
      staggeredTileBuilder: (index) =>
          new StaggeredTile.fit(_cardHorizontalCount),
    );
  }

  Future<void> _onRefreshContentList() async {
    //Holding pull to refresh loader widget for 2 sec.
    //You can fetch data from server.
    setShowFeedRefreshChip(false);
    await new Future.delayed(const Duration(seconds: 1));
    blocContent.reloadContentList(true);
  }

  Widget _getContentDataUI(AsyncSnapshot<ActionContentListResponse> snapshot) {
    Widget contentUI;
    if (snapshot.data.data.length > 0) {
      contentUI = Stack(
        children: <Widget>[
          _getContentUIList(snapshot.data.data),
          Visibility(
            //visible: true,
            visible: _showNewFeedChip,
            child: Column(
              children: <Widget>[
                Center(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: 100.0,
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            color: ColorUtils.appbarIconColor.withOpacity(0.4),
                            //color: Colors.black.withOpacity(.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(24.0),
                        shape: BoxShape.rectangle,
                        //border: Border.all(color: Color(0xFFFEEBF1),width: 1.0 )
                      ),
                      /* decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.0,
                              color: ColorUtils.greyColor.withOpacity(0.9),
                              //color: Colors.black.withOpacity(.5),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Color(0xFFFEEBF1)),*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/new_feed.png",
                            scale: 5.0,
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          CustomWidget.getText(Strings.newFeed,
                              style: Theme.of(context).textTheme.body1)
                        ],
                      ),
                    ),
                    onTap: () {
                      widget.blocContent.reloadContentList(true);
                      setShowFeedRefreshChip(false);
                    },
                  ),
                ),
              ],
            ),
          ),
/*
          Visibility(
            visible: _isShowUserGuide,
            child: Padding(
              padding: const EdgeInsets.only(top : 20.0),
              child: new Align(
                alignment: Alignment.topRight,
                child: AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget child) {
                        return CustomPaint(
                          painter: ChatBubble(color: animation.value, alignment: Alignment.center),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            margin: EdgeInsets.only(right: 8.0, top: 4,left: 0.0),
                            child: Stack(
                              children: <Widget>[
                                CustomWidget.getText("Tap card to view more",style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.white,),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                        }
                ),
                ),
            ),
          ),*/
        ],
      );
    } else {
      contentUI = emptyView();
    }

    return contentUI;
  }

  bool _isShowUserGuide = true;
  Timer timerUserGuideCard;

  void _setTimerForUserGuideContainer() {
    timerUserGuideCard = Timer.periodic(Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {
          _isShowUserGuide = false;
        });
      }
      timerUserGuideCard?.cancel();
    });
  }

  var countRedrawContentListing = 0;
  var isShimmerShowed = false;

  Widget _getContentListWidget(
      AsyncSnapshot<ActionContentListResponse> snapshot) {
    //PrintUtils.printLog("Munish -> _getContentListWidget() -> ${++countRedrawContentListing}");
    Widget contentUI;

    if (snapshot.data != null) {
      contentUI = _getContentDataUI(snapshot);
    } else {
      var contentListingType = blocContent.getContentListingType();
      if (contentListingType == null) {
        contentUI = _getShimmerList();
      } else {
        if (contentListingType != ContentListingType.PROFILE) {
          contentUI = _getShimmerList();
        } else if (contentListingType == ContentListingType.PROFILE &&
            !isShimmerShowed) {
          isShimmerShowed = true;
          contentUI = _getShimmerList();
        } else {
          contentUI = Container();
        }
      }
    }

    return contentUI;
  }

  // UI
  genreButton(MetaDataResponseDataCommon genreItem, Color color, {onTap}) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            widget._isGenresSelected == true
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ContentFilterByGenreScreen(
                              blocContent,
                              name: blocContent.getSelectedContentTitle(),
                              selectedGenreItem: genreItem,
                            )))
                : _setSelectionGenre(genreItem, isAddOnly: true);
          },
          child: CustomWidget.getText(genreItem.name,
              fontWeight: FontWeight.w500,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: ColorUtils.whiteColor)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: color,
        ));
  }

  genreButtonSelected(
      MetaDataResponseDataCommon genreItem, int index, Color color,
      {onTap}) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Chip(
          label: Text(genreItem.name),
          deleteIcon: Icon(
            Icons.clear,
            size: 16.0,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          backgroundColor:
              Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
          deleteIconColor: Colors.grey,
          onDeleted: () {
            _setSelectionGenre(genreItem, isDeleteOnly: true);
          },
          avatar: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child: Text(genreItem.name.substring(0, 1))),
        ));
  }

  Widget buildListOfGenres(BuildContext context, List list) {
    return ListView.builder(
        shrinkWrap: true,
        //physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, int index) {
          return genreButton(
              list[index], ColorUtils().randomGenreColorByIndex(index));
        });
  }

  Widget buildListOfSelectedGenres(BuildContext context,
      LinkedHashMap<int, MetaDataResponseDataCommon> hmSelectedGenre) {
    var list = hmSelectedGenre.values.toList();

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, int index) {
          return genreButtonSelected(
              list[index], index, ColorUtils().randomGenreColorByIndex(index));
        });
  }

  Widget buildListOfContentFilters(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      child: ListView.builder(
          padding: EdgeInsets.only(left: 2.0, right: 12.0),
          scrollDirection: Axis.horizontal,
          itemCount: blocContent.listOfContentTypeFilter.length,
          itemBuilder: (context, int index) {
            var contentItem = blocContent.listOfContentTypeFilter[index];

            return InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 4.0, right: 4.0),
                alignment: Alignment.center,
                width: 90.0,
                decoration: BoxDecoration(
                  color: blocContent.isContentFilterSelected(contentItem)
                      ? ColorUtils.buttonSelectedColor
                      : Colors.transparent,
                  border: new Border.all(
                    width: 0.7,
                    color: blocContent.isContentFilterSelected(contentItem)
                        ? ColorUtils.buttonSelectedColor
                        : Theme.of(context).iconTheme.color.withOpacity(0.7),
                  ),
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(8.0)),
                ),
                child: CustomWidget.getText(
                  FileUtils.capitalizeString(
                      blocContent.listOfContentTypeFilter[index].name),
                  style: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: blocContent.isContentFilterSelected(contentItem)
                            ? ColorUtils.textSelectedColor
                            : Theme.of(context)
                                .iconTheme
                                .color
                                .withOpacity(0.7),
                      ),
                ),
              ),
              onTap: () {
                _setScrollOffset(0.0);
                _smoothScrollToOffset(0.0);
                _setSelectionContentType(contentItem);
                _setScrollController();
              },
            );
          }),
    );
  }

  void startTimeAndClickCard(List<ActionContentData> data) {
    Timer.periodic(Duration(seconds: 3), (_timer) {
      _timer.cancel();
      SharedPrefUtil.setIsFirstContentCardClickEventCompleted(true);
      NavigatorUtils.moveToContentDetailScreen(context, blocContent, data, 0);
    });
  }
}
