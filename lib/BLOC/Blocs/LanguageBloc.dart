import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:rxdart/rxdart.dart';

class LanguageBloc extends BlocBase {

  MetaDataResponse response;

  final _languageList = PublishSubject<List<MetaDataResponseDataCommon>>();

  Stream<List<MetaDataResponseDataCommon>> get metaDataObservable =>
      _languageList.stream;

  LanguageBloc(BuildContext context) {
    _getMetaData(context);
  }

  void _getMetaData(BuildContext context) async {
    MetaDataResponse metaDataResponse = await SharedPrefUtil.getMetaData();
    try {
      handleMetaDataProcessing(metaDataResponse);

      if(response.data.languages.length <= 0) {
        ApiHandler.getMetaData(context, isForceRefresh: true).then((metaData) {
          handleMetaDataProcessing(metaData);
        });
      }
    } catch (e) {
      print("Munish Thakur -> _getMetaData() -> ${e.toString()}");
    }
  }

  void handleMetaDataProcessing(MetaDataResponse metaDataResponse) {
    try {
      if (response != null) {
        response?.data?.languages?.clear();
        response?.data?.languages?.addAll(metaDataResponse.data.languages);
      } else {
        response = metaDataResponse;
      }
      addContentInStream(response.data.languages);
    } catch(e) {
      print("Munish Thakur -> handleMetaDataProcessing() -> ${e.toString()}");
    }
  }

  void addContentInStream(List<MetaDataResponseDataCommon> _responseMetaData) {
    _languageList.add(_responseMetaData);
  }


  @override
  void dispose() {
    _languageList.close();
  }

  void search(String text) {
    List genresList = List<MetaDataResponseDataCommon>();

    for(int i = 0; i < response?.data?.languages?.length; i++){
      MetaDataResponseDataCommon responseCommonMetaData = response?.data?.languages[i];
      if(responseCommonMetaData.name.trim().toLowerCase().contains(text.toLowerCase())){
        genresList.add(responseCommonMetaData);
      }

      addContentInStream(genresList);
    }
  }
}

