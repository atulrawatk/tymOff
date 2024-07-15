import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Utils/AppUtils.dart';

class ContentFilterByGenreScreen extends StatefulWidget {
  ContentBloc blocContent;
  String name;
  MetaDataResponseDataCommon selectedGenreItem;
  bool isContentTypeFilterVisible = false;
  bool isGenreFilterVisible = false;

  ContentFilterByGenreScreen(
      this.blocContent,
      {this.isContentTypeFilterVisible, this.isGenreFilterVisible, this.name, this.selectedGenreItem}) {
    isContentTypeFilterVisible = AppUtils.isValid(isContentTypeFilterVisible);
    isGenreFilterVisible = AppUtils.isValid(isGenreFilterVisible);
  }

  @override
  _ContentFilterByGenreScreenState createState() => _ContentFilterByGenreScreenState();
}

class _ContentFilterByGenreScreenState extends State<ContentFilterByGenreScreen>
    with AutomaticKeepAliveClientMixin {

  var isGenresSelected = false;
  ContentBloc _blocContent;
  ContentListing _contentListing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _blocContent = ContentBloc();
    //widget.blocContent.clearGenreSelection();
    _setSelectionGenre(widget.selectedGenreItem, isAddOnly: true);

    _contentListing = ContentListing(
      blocContent: widget.blocContent,
//         isContentTypeFilterVisible: true,
      isGenreFilterVisible: true,
      isGenreFilterSelectedVisible: !isGenresSelected,
      isGenresSelected: isGenresSelected,
    );
  }

  void _setSelectionGenre(
      MetaDataResponseDataCommon genreItem, {
        bool isAddOnly = false,
        bool isDeleteOnly: false,
      }) {
      widget.blocContent.updateGenreSelection(this, genreItem,
          isAddOnly: isAddOnly, isDeleteOnly: isDeleteOnly);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: _contentListing);
  }

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.blocContent.clearGenreSelection();
  }
}
