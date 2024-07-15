import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventRefreshContent.dart';
import 'package:tymoff/Network/Api/ApiHandlerCache.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Screens/Others/EmptyScreen.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/main.dart';

class Discover extends StatefulWidget {

  var discoverState = _DiscoverState();

  void discoverShouldRefresh() {
    discoverState.discoverShouldRefresh();
  }

  @override
  State createState() => discoverState;
}

class _DiscoverState extends State<Discover>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // full screen width and height
  double width;
  double height;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  DiscoverListResponse _discoverListResponse;
  final List<DiscoverListData> discoverListAllDiscoverList = List();
  final List<DiscoverListData> discoverListNormalDiscoverList = List();
  final List<DiscoverListData> discoverListUserSpecificDiscoverList = List();

  @override
  void initState() {
    super.initState();
    setObservers();
  }

  var _countRedrawWidget = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _refreshScreen();

    PrintUtils.printLog("Munish -> Discover -> didChangeDependencies() ${++_countRedrawWidget}");
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  void discoverShouldRefresh() {
    _getDiscoverListUserSpecific(context, isHardRefresh : true);
  }

  void setObservers() {
    eventBus.on<EventRefreshContent>().listen((event) {
      _onRefreshDiscoverList();
    });
  }

  _getDiscoverListNormal(BuildContext context, {bool isHardRefresh = false}) async {
    var discoverListResponse =
    await ApiHandlerCache.getDiscoverListResponse(context,isHardRefresh : isHardRefresh);
    if (discoverListResponse != null) {
      if (discoverListResponse.statusCode == 200) {

        if(discoverListResponse?.data?.discover != null) {
          discoverListNormalDiscoverList.clear();
          discoverListNormalDiscoverList.addAll(discoverListResponse.data.discover);
        }
        setStateDiscoverListResponse(discoverListResponse);

        PrintUtils.printLog("Discover Api hit sucessfully");
      } else {
        PrintUtils.printLog("Error Occur in hitting the api");
      }
    } else {
      setStateDiscoverListResponse(DiscoverListResponse());
    }
  }

  _getDiscoverListUserSpecific(BuildContext context,{bool isHardRefresh = false}) async {
    var discoverListResponse =
    await ApiHandlerCache.getDiscoverListUserSpecificResponse(context, isHardRefresh : isHardRefresh);
    if (discoverListResponse != null) {
      if (discoverListResponse.statusCode == 200) {

        if(discoverListResponse?.data?.discover != null) {
          discoverListUserSpecificDiscoverList.clear();
          discoverListUserSpecificDiscoverList.addAll(discoverListResponse.data.discover);
        }
        setStateDiscoverListResponse(discoverListResponse);

        PrintUtils.printLog("Discover Api hit sucessfully");
      } else {
        PrintUtils.printLog("Error Occur in hitting the api");
      }
    } else {
      setStateDiscoverListResponse(DiscoverListResponse());
    }
  }

  void setStateDiscoverListResponse(DiscoverListResponse discoverListResponse) {
    if(mounted) {
      setState(() {
        manipulateDiscoverList(discoverListResponse);
      });
    } else {
      manipulateDiscoverList(discoverListResponse);
    }
  }

  void manipulateDiscoverList(DiscoverListResponse discoverListResponse) {

    if(this._discoverListResponse?.data?.discover != null) {
      discoverListAllDiscoverList.clear();
      discoverListAllDiscoverList.addAll(discoverListNormalDiscoverList);
      discoverListAllDiscoverList.addAll(discoverListUserSpecificDiscoverList);

      _discoverListResponse?.data?.discover?.clear();
      _discoverListResponse?.data?.discover?.addAll(discoverListAllDiscoverList);
    } else {
      this._discoverListResponse = discoverListResponse;
    }
  }

  Widget getImageList(int index) {
    var contentList = _discoverListResponse?.data?.discover[index]?.contentList ?? List<DiscoverContentList>();

    var itemCount = contentList?.length ?? 0;
    if(itemCount >= 4){
      itemCount = 3;
    }

    if(itemCount > 0) {
      itemCount += 1;
    }

    var widgetList = Container(
        height: 120.0,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          itemCount: itemCount,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, indexChildContent) {

            Widget widgetDiscoverContentView = Container();

            if((indexChildContent + 1) < itemCount) {
              var contentUrlLength = contentList[indexChildContent]?.contentUrl;

              widgetDiscoverContentView = (contentUrlLength?.length ?? 0) > 0
                  ? Container(
                  margin: EdgeInsets.only(left: 4.0, right: 4.0),
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CachedNetworkImage(
                        imageUrl: contentUrlLength[0].url,
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) =>
                        new Icon(Icons.error),
                        fit: BoxFit.cover
                    ),
                  ),)
                  : Container(
                child: Container(),
                margin: EdgeInsets.only(left: 4.0, right: 4.0),
              );
            } else {
              widgetDiscoverContentView = Container();
            }

            return widgetDiscoverContentView;
          },
        ));

    return widgetList;
  }

  Widget getImageListWidget(int itemCount, int indexChildContent,ContentUrl contentUrl ){

    return Container(
        margin: EdgeInsets.only(left: 6.0, right: 6.0),
        width: 120,
        height: 100,
        child: CachedNetworkImage(
            imageUrl: contentUrl .url,
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fit: BoxFit.cover
        ),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(4.0),
            topRight: const Radius.circular(4.0),
            bottomLeft: const Radius.circular(4.0),
            bottomRight: const Radius.circular(4.0),
          ),
        ));
  }
 /* Widget viewMoreWidget(){
    return Container(
      padding: EdgeInsets.only(left: 4.0,right: 4.0),
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         *//* Icon(Icons.arrow_forward,color: Theme.of(context).iconTheme.color.withOpacity(0.6),),
          SizedBox(height: 4.0,),*//*
          CustomWidget.getText("View All",style: Theme.of(context).textTheme.subtitle)
        ],
      )

    );
  }*/

  Widget getGridList(int index) {

    var contentList = _discoverListResponse?.data?.discover[index]?.contentList ?? List<DiscoverContentList>();

    var itemCount = contentList?.length ?? 0;

    var errorMessage = _discoverListResponse?.data?.discover[index]?.message ?? "No Content Found";

    Widget widgetToReturn = Container();

    Widget widgetGrid = Container(
      color: Colors.transparent,
        padding: EdgeInsets.only(top : 10.0, bottom: 8.0),
        height: 140.0,
        child: new SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: getImageList(index),
          ),
        ));

    Widget widgetMessage = Container(
        child: new SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            margin: EdgeInsets.symmetric(vertical: 18.0),
            child:  _getDiscoverErrorContainer(errorMessage),
          ),
        ));

    widgetToReturn = (itemCount > 0) ? widgetGrid : widgetMessage;
    return widgetToReturn;
  }

  Widget _getDiscoverErrorContainer(String errorMessage) {
    return Container(
      alignment: Alignment.centerLeft,
      child: CustomWidget.getText(errorMessage),
    );
  }

  Widget buildDiscoverItemListUI() {

    return  Container(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _discoverListResponse?.data?.discover?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 12.0),
                  child: CustomWidget.getText(
                      _discoverListResponse.data.discover[index].name,
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.start),
                ),
                getGridList(index),
                SizedBox(height: 8.0,),
              ],
            ),
            onTap: () {
              AnalyticsUtils?.analyticsUtils?.eventDiscovercontentButtonClicked();
              moveToDiscoverScreen(_discoverListResponse.data.discover[index]);
            },
          );
        },
      ),
    ) ;
  }

  Widget buildDiscoverBodyUI() {
    return Container(
      height: height,
      //color: Colors.white,
      color: Theme.of(context).backgroundColor,
      child: buildDiscoverItemListUI(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    PrintUtils.printLog("Munish -> Discover -> build() ${++_countRedrawWidget}");

    Widget mainWidget = Container();

    if (_discoverListResponse != null) {
      if (_discoverListResponse?.data?.discover != null) {
        /*mainWidget = CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return buildDiscoverBodyUI(index);
              }, childCount: 1),
            ),
          ],
        );
*/
        mainWidget = buildDiscoverBodyUI();

      } else {
        mainWidget = EmptyScreen();
      }
    } else {
      mainWidget = Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefreshDiscoverList,
      child: mainWidget,
    );
  }

  Future<void> _onRefreshDiscoverList() async {
    //Holding pull to refresh loader widget for 2 sec.
    //You can fetch data from server.
    await new Future.delayed(const Duration(seconds: 1));
    _refreshScreen();
  }

  void _refreshScreen() {
    _getDiscoverListNormal(context, isHardRefresh : true);
    _getDiscoverListUserSpecific(context, isHardRefresh : true);
  }

  void moveToDiscoverScreen(DiscoverListData discover) {
    NavigatorUtils.moveToPagerContentDiscoverScreen(
        context, discover.id, discoverListAllDiscoverList);
  }
}
