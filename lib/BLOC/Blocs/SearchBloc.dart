import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/SearchHintResponse.dart';

class SearchBloc extends BlocBase {
  SearchHintResponse _stateSearchHintResponse;

  final _searchHintFetcher = BehaviorSubject<SearchHintResponse>();

  Stream<SearchHintResponse> get searchObservable =>
      _searchHintFetcher.stream.distinct();

  var _isMoreResultAvailableToLoad = true;
  var _page = 0;

  SearchBloc() {
    _searchHintFetcher.add(_stateSearchHintResponse);
  }

  CancelToken _searchCancelToken = CancelToken();

  void getSearchData(BuildContext context, String query) async {
    try {
      if (!_searchCancelToken.isCancelled) {
        _searchCancelToken.cancel();
        _searchCancelToken = CancelToken();
      }

      var _searchResponse = await ApiHandler.getSearchHint(context, query, cancelToken: _searchCancelToken);

      _page++;

      if (_searchResponse?.data != null && _searchResponse.data.length > 0) {
        _addMoreSearch(_searchResponse);
      } else {
        _isMoreResultAvailableToLoad = false;
      }
    } catch (e) {
      print("Munish Thakur -> getSearchData() -> ${e.toString()}");
    }
  }

  void _addMoreSearch(SearchHintResponse _contentResponse) {
    if (_stateSearchHintResponse != null) {
      _stateSearchHintResponse?.data?.clear();
      _stateSearchHintResponse?.data?.addAll(_contentResponse.data);
    } else {
      _stateSearchHintResponse = _contentResponse;
    }
    _searchHintFetcher.add(_stateSearchHintResponse);
  }

  @override
  void dispose() {
    _searchHintFetcher.close();
  }
}
