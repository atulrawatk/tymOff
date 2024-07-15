import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Api/ApiHandlerUtils.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';

class HomePage extends StatefulWidget {

  ContentBloc _blocContent;

  void scrollToTop() => _blocContent?.scrollToTop();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //final contentListing = ContentListing(isContentTypeFilterVisible: true, isGenreFilterVisible: true,);
  ContentListing _contentListing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._blocContent = ContentBloc();
    _contentListing = ContentListing(blocContent: widget._blocContent, isAutoRefreshFeedAvailable: true, isShowPreviewEnabled: true,);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: ColorUtils.whiteColor,
        padding: EdgeInsets.only(top: 0.0),
        child: _contentListing,
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void updateKeepAlive() {
    // TODO: implement updateKeepAlive
  }
}
