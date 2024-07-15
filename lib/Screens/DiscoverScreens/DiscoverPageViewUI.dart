import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

import 'DiscoverCommonUI.dart';

class DiscoverPageViewUI extends StatefulWidget {

  final int discoverId;
  final List<DiscoverListData> discoverListAllDiscoverList;

  DiscoverPageViewUI(this.discoverId, this.discoverListAllDiscoverList);

  @override
  _DiscoverPageViewUIState createState() => _DiscoverPageViewUIState();
}

class _DiscoverPageViewUIState extends State<DiscoverPageViewUI>
    with AutomaticKeepAliveClientMixin {

  var currentDiscoverId = 0;
  var currentDiscoverTitle = "";
  var _initialPage = 0;
  var currentPageValue = 0.0;

  @override
  bool get wantKeepAlive => true;

  PageController _controller;

  void initState() {
    super.initState();

    setInitialPage();
    _controller = PageController(
        initialPage: _initialPage, keepPage: true, viewportFraction: 1);
    _addPageViewListener();

    currentPageValue = _initialPage.toDouble();
  }


  void setInitialPage() {
    for(int index = 0; index < (widget.discoverListAllDiscoverList?.length ?? 0); index++) {
      var discoverData = widget.discoverListAllDiscoverList[index];
      if((discoverData?.id ?? -1) == widget.discoverId) {
        _initialPage = index;
        break;
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return buildPageView();
  }

  Widget buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: AppBar(

          leading: GestureDetector(
            child: Container(
                height: 50.0,
                width: 50.0,
                color: Colors.transparent,
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back_ios, color: Theme
                    .of(context)
                    .accentColor, size: 20.0,)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme
              .of(context)
              .appBarTheme
              .color,
          titleSpacing: 0.0,

          title: CustomWidget.getText(currentDiscoverTitle ?? "", style: Theme
              .of(context)
              .textTheme
              .title
              .copyWith(fontSize: 18.0)),
        ),
      );
  }

  PageView buildPageView() {
    return PageView.builder(
        itemCount: widget.discoverListAllDiscoverList?.length ?? 0,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          var discoverData = widget.discoverListAllDiscoverList[index];
          var discoverId = discoverData.id;
          var discoverTitle = discoverData.name;

          return DiscoverCommonUI(discoverTitle, discoverId);
        });
  }

  void _addPageViewListener() {
    _controller.addListener(() async {

      currentPageValue = _controller.page;

      populateCurrentDiscoverSelectionData();
    });
  }

  void populateCurrentDiscoverSelectionData() {

    var discoverData = widget.discoverListAllDiscoverList[currentPageValue.toInt()];

    if(mounted) {
      setState(() {
        currentDiscoverId = discoverData.id;
        currentDiscoverTitle = discoverData.name;
      });
    }
  }

}

