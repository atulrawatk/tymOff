import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/GenreBloc.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';


class SelectGenres extends StatefulWidget {

  bool _isMultipleSelectionAllowed = true;
  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItems;
  SelectGenres({bool isMultipleSelection = false, HashMap<int, MetaDataResponseDataCommon> hmSelectedItems}) {
    _isMultipleSelectionAllowed = AppUtils.isValid(isMultipleSelection, defaultReturn: _isMultipleSelectionAllowed);

    if(hmSelectedItems == null) {
      hmSelectedItems = HashMap();
    }
    this._hmSelectedItems = hmSelectedItems;
  }

  @override
  _SelectGenresState createState() => _SelectGenresState();
}

class _SelectGenresState extends State<SelectGenres> {

  final myController = TextEditingController();
  GenreBloc genreBloc;
  MetaDataResponse metaDataResponse;

  MetaDataResponseDataCommon selectedGenresItems = MetaDataResponseDataCommon();


//  TextEditingController _textFieldController = TextEditingController();
  _onClear() {
    setState(() {
      myController.clear();
      genreBloc.search(myController.text);
    });
  }

  textListener(){
    print("Current text is -> ${myController.text}");
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myController.addListener(textListener());
    //_initGenrePreSelection();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    genreBloc = GenreBloc(context);
  }

  Widget _genreSelected(
      MetaDataResponseDataCommon genreItem,
      {onTap}) =>
      GestureDetector(
    child:  Material(
      elevation: 2.0,
      child: Container(
          decoration: _isSelected(genreItem) ? BoxDecoration(
            color:ColorUtils.primaryColor,
            borderRadius: BorderRadius.circular(4.0),
          ) : BoxDecoration(),
          child: Container(
            alignment: Alignment.center,
            transform: Matrix4.translationValues(2.8, 0.0, 0.0),
            padding: EdgeInsets.only(top: 6.0,bottom: 6.0,left: 4.0,right: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: CustomWidget.getText(genreItem?.name??"", textColor: Colors.black,fontSize: 14.0,textAlign: TextAlign.center),

          )
      ),
    ),
    onTap: onTap,
  );

  Widget topPart(List<MetaDataResponseDataCommon> metaDataResponse,BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index){
            return Padding(
              padding:const EdgeInsets.all(16.0),
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
               /* decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),*/
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      hintText: Strings.search,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left : 8.0,right: 8.0,top: 8.0),
                      hintStyle: const TextStyle(color: Colors.grey),
                      alignLabelWithHint: true,
                      suffixIcon: (myController?.text?.length ?? 0) <= 0 ? Container(width: 0.0,) :
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.red[50],
                          child: Container(
                              child: Icon(Icons.clear,size: 18.0,color: Colors.grey,)
                          ),
                          onTap: _onClear,
                        ),
                      )

                  ),
                  onChanged: (text){
                    print("Text $text");
                    genreBloc.search(text);
                  },
                ),
              ),
            );
          },childCount: 1),
        ),
     SliverGrid(
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              return Container(
                padding: EdgeInsets.only(left: 16.0, top: 10.0,right: 16.0),
                child: _genreSelected(metaDataResponse[index],onTap: (){
                  updateSelection(metaDataResponse[index]);
                }),
              );
            },childCount: (metaDataResponse?.length ?? 0)),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4.0,
              crossAxisCount: 3,
              childAspectRatio: 2.0,
            ),
        )
      ],
    );
  }

  void updateSelection(MetaDataResponseDataCommon item) {
    setState(() {
      if (item != null) {
        if (!widget._isMultipleSelectionAllowed) {
          widget._hmSelectedItems.clear();
        }

        if (_isSelected(item)) {
          widget._hmSelectedItems.remove(item.getUID());
        } else {
          widget._hmSelectedItems[item.getUID()] = item;
          setState(() {
            selectedGenresItems = item;
          });
        }
      }
    });
  }

  bool _isSelected(MetaDataResponseDataCommon item) {
    if (item != null) {
      return widget._hmSelectedItems.containsKey(item.getUID());
    }

    return false;
  }

  bool _isAnyGenreSelected() => (widget?._hmSelectedItems?.length ?? 0) > 0;

  Widget build(BuildContext context) {

    return StreamBuilder<List<MetaDataResponseDataCommon>>(
      stream: genreBloc.metaDataObservable,
      builder: (context,snapshot){
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: CustomAppBar().getAppBar(
              context: context,
              title: Strings.selectGenres,
              leadingIcon: Icons.arrow_back_ios,
          ),
          body: snapshot.data != null ? topPart(snapshot.data,context) : Container(),

          bottomNavigationBar: CustomWidget.getBottomNavigationBar("Save",onTap: (){
            if(_isAnyGenreSelected()) {
              AnalyticsUtils?.analyticsUtils?.eventGenreButtonClicked();
              Navigator.pop(context, widget._hmSelectedItems);
            } else {
              ToastUtils.show("Please select Genre");
            }
          }

          ),
        );
      },
    );
  }
}
