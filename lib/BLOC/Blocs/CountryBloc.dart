import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:rxdart/rxdart.dart';

class CountryBloc extends BlocBase {

  MetaDataResponse response;

  final _countryList = PublishSubject<List<MetaDataCountryResponseDataCommon>>();

  Stream<List<MetaDataCountryResponseDataCommon>> get metaDataObservable =>
      _countryList.stream;

  CountryBloc() {
    _getMetaData();
  }

  void _getMetaData() async {
    MetaDataResponse metaDataResponse = await SharedPrefUtil.getMetaData();
    try {

      if (response != null) {
        response?.data?.countries?.addAll(metaDataResponse.data.countries);
      } else {
        response = metaDataResponse;
      }
      addContentInStream(response.data.countries);
    } catch (e) {
      print("Munish Thakur -> _getMetaData() -> ${e.toString()}");
    }
  }

  void addContentInStream(List<MetaDataCountryResponseDataCommon> _responseMetaData) {
    _countryList.add(_responseMetaData);
  }


  @override
  void dispose() {
    _countryList.close();
  }

  void search(String text) {
    List genresList = List<MetaDataCountryResponseDataCommon>();

    for(int i = 0; i < response?.data?.countries?.length; i++){
      MetaDataCountryResponseDataCommon responseCommonMetaData = response?.data?.countries[i];
      if(responseCommonMetaData.name.trim().toLowerCase().contains(text.toLowerCase())){
        genresList.add(responseCommonMetaData);
      }

      addContentInStream(genresList);
    }
  }
}

