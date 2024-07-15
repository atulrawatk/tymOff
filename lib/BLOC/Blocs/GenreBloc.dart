import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:rxdart/rxdart.dart';

class GenreBloc extends BlocBase {

  MetaDataResponse response;

  final _genreList = BehaviorSubject<List<MetaDataResponseDataCommon>>();

  Stream<List<MetaDataResponseDataCommon>> get metaDataObservable =>
      _genreList.stream;

  BuildContext _context;
  GenreBloc(this._context) {
    _getMetaData();
  }

  void _getMetaData() async {
    MetaDataResponse metaDataResponse = await SharedPrefUtil.getMetaData();
    try {
      handleMetaDataProcessing(metaDataResponse);
      
      if((response?.data?.genres?.length ?? 0) <= 0) {
        callApiAndTryToGetData();
      }
    } catch (e) {
      print("Munish Thakur -> _getMetaData() -> ${e.toString()}");
      callApiAndTryToGetData();
    }
  }

  void callApiAndTryToGetData() {
    ApiHandler.getMetaData(_context, isForceRefresh: true).then((metaData) {
      handleMetaDataProcessing(metaData);
    });
  }

  void handleMetaDataProcessing(MetaDataResponse metaDataResponse) {
    try {
      if (response != null) {
        response?.data?.genres?.clear();
        response?.data?.genres?.addAll(metaDataResponse.data.genres);
      } else {
        response = metaDataResponse;
      }
      addContentInStream(response.data.genres);
    } catch(e) {
      print("Munish Thakur -> handleMetaDataProcessing() -> ${e.toString()}");
    }
  }

  void addContentInStream(List<MetaDataResponseDataCommon> _responseMetaData) {
    _genreList.add(_responseMetaData);
  }


  @override
  void dispose() {
    _genreList.close();
  }

  void search(String text) {
    List genresList = List<MetaDataResponseDataCommon>();

    for(int i = 0; i < response?.data?.genres?.length; i++){
      MetaDataResponseDataCommon responseCommonMetaData = response?.data?.genres[i];
      if(responseCommonMetaData.name.trim().toLowerCase().contains(text.toLowerCase())){
        genresList.add(responseCommonMetaData);
      }

      addContentInStream(genresList);
    }
  }
}

