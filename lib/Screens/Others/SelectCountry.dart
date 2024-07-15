import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/CountryBloc.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/Home/Dashboard.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

class SelectCountry extends StatefulWidget {
  bool _isMultipleSelectionAllowed = true;
  HashMap<int, MetaDataCountryResponseDataCommon> _hmSelectedItems;
  SelectCountry({bool isMultipleSelection = false, HashMap<int, MetaDataCountryResponseDataCommon> hmSelectedItems}) {
    _isMultipleSelectionAllowed = AppUtils.isValid(isMultipleSelection, defaultReturn: _isMultipleSelectionAllowed);

    if(hmSelectedItems == null) {
      hmSelectedItems = HashMap();
    }
    this._hmSelectedItems = hmSelectedItems;
  }

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final myController = TextEditingController();

  CountryBloc countryBloc;

  _onClear() {
    setState(() {
      myController.clear();
      countryBloc.search(myController.text);
    });
  }

  textListener() {
    print("Current text is -> ${myController.text}");
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(textListener());
    _setUserCurrentCountry();
  }

  void _setUserCurrentCountry() {}

  @override
  void didChangeDependencies() async {
    countryBloc = CountryBloc();
    super.didChangeDependencies();
  }

  Widget _languageNormal(MetaDataCountryResponseDataCommon countryItem,
          {onTap}) =>
      GestureDetector(
        child: Material(
          elevation: 2.0,
          child: Container(
              decoration: _isSelected(countryItem)
                  ? BoxDecoration(
                      color: ColorUtils.primaryColor,
                      borderRadius: BorderRadius.circular(4.0),
                    )
                  : BoxDecoration(),
              child: Container(
                transform: Matrix4.translationValues(2.0, 0.0, 0.0),
                padding: EdgeInsets.only(
                    top: 12.0, bottom: 12.0, left: 14.0, right: 14.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: CustomWidget.getText(countryItem?.name ?? "",
                    textColor: Colors.black, fontSize: 14.0),
              )),
        ),
        onTap: onTap,
      );

  Widget topPart(List<MetaDataCountryResponseDataCommon> metaDataResponse,
      BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 14.0,
            runSpacing: 10.0,
            children: getAllLanguageWidgets(metaDataResponse),
          ),
        ],
      ),
    );
  }

  void updateSelection(MetaDataCountryResponseDataCommon item) {
    if (item != null) {
      if (!widget._isMultipleSelectionAllowed) {
        widget._hmSelectedItems.clear();
      }

      if (_isSelected(item)) {
        widget._hmSelectedItems.remove(item.getUID());
      } else {
        widget._hmSelectedItems[item.getUID()] = item;
      }
    }

    AppUtils.refreshCurrentState(this);
  }

  bool _isSelected(MetaDataCountryResponseDataCommon item) {
    if (item != null) {
      return widget._hmSelectedItems.containsKey(item.getUID());
    }

    return false;
  }

  List<Widget> getAllLanguageWidgets(
      List<MetaDataCountryResponseDataCommon> metaDataResponse) {
    List<Widget> listOfWidgets = new List();
    for (int index = 0; index < (metaDataResponse?.length ?? 0); index++) {
      var language = metaDataResponse[index];
      var widgetLanguage = _languageNormal(language, onTap: () {
        updateSelection(metaDataResponse[index]);
      });
      listOfWidgets.add(widgetLanguage);
    }

    return listOfWidgets;
  }

  Widget build(BuildContext context) {
    return StreamBuilder<List<MetaDataCountryResponseDataCommon>>(
      stream: countryBloc.metaDataObservable,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar().getAppBar(
            context: context,
            title: Strings.selectCountry,
            leadingIcon: Icons.arrow_back_ios,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.0,
                        ),
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            hintText: Strings.search,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: (myController?.text?.length ?? 0) <= 0 ? Container(width: 0.0,) : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.red[50],
                                child: Container(
                                    child: Icon(
                                      Icons.clear,
                                      size: 18.0,
                                      color: Colors.grey,
                                    )),
                                onTap: _onClear,
                              ),
                            )),
                        onChanged: (text) {
                          print("Text $text");
                          countryBloc.search(text);
                        },
                      ),
                    ),
                  );
                }, childCount: 1),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var resuffleCountries = _resuffleCountryData(snapshot.data);
                  return topPart(resuffleCountries, context);
                }, childCount: 1),
              ),
            ],
          ),
          bottomNavigationBar:
              CustomWidget.getBottomNavigationBar(Strings.done, onTap: () {
            Navigator.pop(context, widget._hmSelectedItems);
          }),
        );
      },
    );
  }

  List<MetaDataCountryResponseDataCommon> _resuffleCountryData(
      List<MetaDataCountryResponseDataCommon> countries) {
    var countriesList = List<MetaDataCountryResponseDataCommon>();
    bool isUserCountryFound = false;
    countries?.forEach((country) {
      if(metaDataCountryResponseDataCommon != null && country.id != metaDataCountryResponseDataCommon.id) {
        isUserCountryFound = true;
        countriesList.insert(0, country);
      } else {
        countriesList.add(country);
      }
    });

    if(isUserCountryFound) {
      countriesList = countriesList.reversed.toList();
    }

    return countriesList;
  }
}
