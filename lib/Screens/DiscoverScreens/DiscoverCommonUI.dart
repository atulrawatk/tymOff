import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class DiscoverCommonUI extends StatefulWidget {

  int discoverId;
  String discoverTitle;

  DiscoverCommonUI(this.discoverTitle, this.discoverId);

  @override
  _DiscoverCommonUIState createState() => _DiscoverCommonUIState();
}

class _DiscoverCommonUIState extends State<DiscoverCommonUI>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  ContentListing _contentListing;
  double listViewOffsetResults = 0.0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _initContentListing();
  }

  ContentBloc blocContent;

  void _initContentListing() {
    String contentType;

    if (widget.discoverId == 3 || widget.discoverId == 4) {

      if (widget.discoverId == 3) {
        contentType = Constant.KEY_CONTENT_TYPE_LIKE;
      } else if (widget.discoverId == 4) {
        contentType = Constant.KEY_CONTENT_TYPE_DOWNLOAD;
      }

      blocContent = ContentBloc(contentListingType: ContentListingType.PROFILE, profileActionType: contentType);
    }


    if (contentType != null && blocContent != null) {
      _contentListing = ContentListing(
          blocContent: blocContent,
          isContentTypeFilterVisible: false,
          isGenreFilterVisible: false,
          isGenresSelected: false,
          getOffsetMethod: () => listViewOffsetResults,
          setOffsetMethod: (offset) => this.listViewOffsetResults = offset,
          discoverId: widget?.discoverId?.toString() ?? "",
      );
    } else {
      _contentListing = ContentListing(
          isContentTypeFilterVisible: false,
          isGenreFilterVisible: false,
          isGenresSelected: false,
          getOffsetMethod: () => listViewOffsetResults,
          setOffsetMethod: (offset) => this.listViewOffsetResults = offset,
          discoverId: widget?.discoverId?.toString() ?? "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: AppBar(

            //      child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 20.0,)),
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

            //title: Text("Settings",style: TextStyle(fontWeight: FontWeight.normal),),
            title: widget.discoverTitle != null ? CustomWidget.getText(
                widget.discoverTitle ?? "", style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(fontSize: 18.0))
                : CustomWidget.getText("", style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(fontSize: 18.0)),
          ),
        ),
        body: _contentListing
    );
  }
}

