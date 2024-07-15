import 'package:flutter/material.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Screens/Search/ContentSearchDelegate.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

import 'ContentListing.dart';

class ContentCommonUI extends StatefulWidget {
  final String title;
  final String searchText;
  bool isContentTypeFilterVisible = false;
  bool isGenreFilterSelectedVisible = false;
  bool isGenreFilterVisible = false;
  bool isGenresSelected = false;

  ContentCommonUI(
      {this.title,
      this.searchText,
      this.isContentTypeFilterVisible,
      this.isGenreFilterVisible,
      this.isGenreFilterSelectedVisible,
      this.isGenresSelected}) {
    isContentTypeFilterVisible = AppUtils.isValid(isContentTypeFilterVisible);
    isGenreFilterSelectedVisible =
        AppUtils.isValid(isGenreFilterSelectedVisible);
    isGenreFilterVisible = AppUtils.isValid(isGenreFilterVisible);
    isGenresSelected = AppUtils.isValid(isGenresSelected);
  }

  @override
  _ContentCommonUIState createState() => _ContentCommonUIState(this.title);
}

class _ContentCommonUIState extends State<ContentCommonUI>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  String title;

  _ContentCommonUIState(this.title);

  ContentListing _contentListing;
  var contentSearchDelegate = ContentSearchDelegate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentListing = ContentListing(
      isContentTypeFilterVisible: widget.isContentTypeFilterVisible,
      isGenreFilterVisible: widget.isGenreFilterVisible,
      isGenreFilterSelectedVisible: widget.isGenreFilterSelectedVisible,
      isGenresSelected: widget.isGenresSelected,
      searchText: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorUtils.blackColor,
              size: 20.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: ColorUtils.appBarColor,
          title: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: ColorUtils.blackColor)),
        ),
        body: _contentListing);
  }
}
