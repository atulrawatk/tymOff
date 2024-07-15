import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/Others/SelectGenres.dart';
import 'package:tymoff/Screens/Others/SelectLanguage.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

import 'CommonChipView.dart';


class SelectGenreOrLanguageUploadUI extends StatefulWidget {


  HashMap<int, MetaDataResponseDataCommon> hmSelectedItems = HashMap<int, MetaDataResponseDataCommon>();
  SelectionUploadChipTypes selectionType;

  SelectGenreOrLanguageUploadUI(this.selectionType, {HashMap<int, MetaDataResponseDataCommon> hmSelectedItems}) {
    if(hmSelectedItems != null) {
      this.hmSelectedItems = hmSelectedItems;
    }
  }

  @override
  _SelectGenreOrLanguageUploadUIState createState() => _SelectGenreOrLanguageUploadUIState();
}

class _SelectGenreOrLanguageUploadUIState extends State<SelectGenreOrLanguageUploadUI> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getTitle(context),
                  Icon(Icons.add,color: ColorUtils.primaryColor,size: 20.0,),
                ],
              ),
            ),
            onTap: () async{
              HashMap<int, MetaDataResponseDataCommon> result = await selectChipMap(context);

              if(result != null && result.length > 0) {
                widget.hmSelectedItems = result;
                refreshScreen();
              }
            },
          ),

          widget.hmSelectedItems != null ? CommonChipView(widget.hmSelectedItems, widget.selectionType) : Container(),
        ],
      ),
    );
  }

  Future<HashMap<int, MetaDataResponseDataCommon>> selectChipMap(BuildContext context) async {
    HashMap<int, MetaDataResponseDataCommon> result;
    if(widget.selectionType == SelectionUploadChipTypes.GENRE) {
      result = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => SelectGenres(isMultipleSelection: true, hmSelectedItems: widget.hmSelectedItems)));
    } else if(widget.selectionType == SelectionUploadChipTypes.LANGUAGE) {
      result = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => SelectLanguage(isMultipleSelection: true, hmSelectedItems: widget.hmSelectedItems)));
    }
    return result;
  }

  Widget getTitle(BuildContext context) {
    String title = "";
    if(widget.selectionType == SelectionUploadChipTypes.GENRE) {
      title = Strings.genre;
    } else if(widget.selectionType == SelectionUploadChipTypes.LANGUAGE) {
      title = Strings.langauge;
    }

    return CustomWidget.getText(title, style: Theme.of(context).textTheme.subtitle);
  }

  void refreshScreen() {
    if(mounted)
      setState(() {});
  }
}
