import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/BLOC/Blocs/SearchBloc.dart';
import 'package:tymoff/BLOC/Blocs/ThemeBloc.dart';
import 'package:tymoff/Network/Response/SearchHintResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentCommonUI.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListingSearchConstant.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

class ContentSearchDelegate extends SearchDelegate {

  ContentBloc _blocContentSuggestions;
  ContentBloc _blocContentResults;

  ContentSearchDelegate() : super(
    searchFieldLabel: "Search",
    keyboardType: TextInputType.text,
    //textInputAction: TextInputAction.done,
  ) {
    bloc = SearchBloc();

    print("Munish Thakur -> ContentListing -> Creating ContentSearchDelegate() ");
    _blocContentSuggestions = ContentBloc();
    _blocContentResults = ContentBloc();

    _contentListingSuggestions = ContentListing(
      blocContent: _blocContentSuggestions,
      isContentTypeFilterVisible: true,
      isGenreFilterVisible: true,
      isGenresSelected: true,
      isContentScrollPositionUpdateWithDetailScrollApplicable: false,
      getOffsetMethod: () => listViewOffsetSuggestions,
      setOffsetMethod: (offset) => this.listViewOffsetSuggestions = offset,
    );
    _contentListingResults = ContentListing(
      blocContent: _blocContentResults,
      isContentTypeFilterVisible: true,
      isGenreFilterVisible: true,
      isGenresSelected: true,
      isContentScrollPositionUpdateWithDetailScrollApplicable: false,
      getOffsetMethod: () => listViewOffsetResults,
      setOffsetMethod: (offset) => this.listViewOffsetResults = offset,
      searchText: query,
    );
  }

  SearchBloc bloc;
  double listViewOffsetSuggestions = 0.0;
  double listViewOffsetResults = 0.0;
  ContentListing _contentListingSuggestions;
  ContentListing _contentListingResults;

  SearchHintResponse response;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: (query == null || query == '') ? Container() : Icon(Icons.clear),
        color: Theme.of(context).iconTheme.color,
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }


  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        accentColor: Theme.of(context).accentColor,
        primaryColor: Theme.of(context).primaryColor,
      appBarTheme: AppBarTheme(
        color: Theme.of(context).appBarTheme.color,
      ),
      textTheme: Theme.of(context).textTheme
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return GestureDetector(
      child: Container(
          height: 50.0,
          width: 50.0,
          color: Colors.transparent,
          padding: EdgeInsets.all(4.0),
          child: Icon(
            Icons.arrow_back_ios,
            color:Theme.of(context).iconTheme.color,
            size: 20.0,
          )),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /* return Container(
      color: Colors.green,
      height: 200,
    );*/
    if(query != null && query.trim().length > 0) {
      return searchContentListing(context, query);
    } else {
      return _contentListingSuggestions;
    }
  }

  var _countSearchCountListingCalls = 0;
  var _countBuildSuggestionCalls = 0;

  ContentListing searchContentListing(BuildContext context, String query) {
    print(
        "Munish -> ContentSearchDelegate -> searchContentListing() -> ${++_countSearchCountListingCalls}");
    //navigateToSearchContent(context, query);
    _contentListingResults.updateSearchText(query);
    return _contentListingResults;
  }

  final _constContentListingTemp = ContentListingSearchConstant();

  @override
  Widget buildSuggestions(BuildContext context) {
    print(
        "Munish -> ContentSearchDelegate -> buildSuggestions() -> ${++_countBuildSuggestionCalls}");
    try {
      bloc.searchObservable.listen((searchSuggestions) {
        if ((searchSuggestions?.data?.length ?? 0) <= 0) {
          print("Munish -> Hitting Search Data For hints");
          bloc.getSearchData(context, query);
        }
      });
    } catch(e) {
      print("Munish -> Search Hint exception -> ${e}");
    }

    if (query.trim().length > 0) {
      print(
          "Munish -> ContentSearchDelegate -> buildSuggestions() -> IF -> ${_countBuildSuggestionCalls}");
      return StreamBuilder<SearchHintResponse>(
        stream: bloc.searchObservable,
        builder:
            (BuildContext context, AsyncSnapshot<SearchHintResponse> snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }

          final results =
              snapshot.data.data.where((a) => a.toLowerCase().contains(query));
          return ListView(
            children: results
                .map<ListTile>((searchText) => ListTile(
                      title: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(width: 4.0,),
                            Align(
                              alignment: Alignment.centerLeft,
                                child: Text("${searchText.toString()}")),
                            SizedBox(width: 4.0,),
                            Divider(),
                          ],
                        ),
                      ),
                      onTap: () {
                        navigateToSearchContent(context, searchText);
                      },
                    ))
                .toList(),
          );
        },
      );
    } else {
      print(
          "Munish -> ContentSearchDelegate -> buildSuggestions() -> Else -> ${_countBuildSuggestionCalls}");

      // TEMP CODE - Munish Thakur
      //return _constContentListingTemp;
      return _contentListingSuggestions;
    }
  }

  void navigateToSearchContent(BuildContext context, String searchText) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ContentCommonUI(
                  isContentTypeFilterVisible: true,
                  isGenreFilterVisible: true,
                  isGenresSelected: true,
                  searchText: searchText,
                  title: searchText,
                )));
  }


}
