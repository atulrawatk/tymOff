import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/ListOfItems.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

class ContentBottomTextUI extends StatefulWidget {
  final ActionContentData cardDetailData;
  ContentBottomTextUI(this.cardDetailData);

  @override
  _ContentBottomTextUIState createState() => _ContentBottomTextUIState();
}

class _ContentBottomTextUIState extends State<ContentBottomTextUI> {

  bool isShowMore = false;

  @override
  void initState() {
    isShowMore = (widget?.cardDetailData?.contentValue?.length ?? 0)> 50;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  String getContentValueText() {
    String contentTextValue = "";
    try {
      if (widget.cardDetailData.contentValue.length > 50) {
        String prefixString =
        widget.cardDetailData.contentValue.substring(0, 51);
        String suffixString = widget.cardDetailData.contentValue.substring(
            51, widget.cardDetailData.contentValue.length);
        var firstSpaceIndex = suffixString.indexOf(" ");
        String appendedString = suffixString.substring(0, firstSpaceIndex + 1);
        prefixString = prefixString + appendedString;
        contentTextValue = contentTextValue + prefixString;
      } else {
        contentTextValue =
            contentTextValue + widget.cardDetailData.contentValue;
      }
    } catch(e) {
      print("Munish Thakur -> getContentValueText() -> ${e.toString()}");
    }
    return contentTextValue.trim();
  }

  bool checkISThereAnyBottomTextAvailable(){
    if(widget.cardDetailData.contentValue == null ||
        widget.cardDetailData.contentValue == ""){
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.topLeft,
      height: 40,
      width: MediaQuery.of(context).size.width,
      color: (!checkISThereAnyBottomTextAvailable()) ? Colors.transparent : Color(0xFF3A3A3A).withOpacity(0.3),
      padding: EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          CustomWidget.getText(getContentValueText(),
              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0,color: ColorUtils.whiteColor.withOpacity(0.8))),
          SizedBox(height: 8.0,),
          buildSeeMoreGestureDetector(context),

        ],

      ),
    );

  }

  Widget buildSeeMoreGestureDetector(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: isShowMore
            ? Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.transparent,
         //width: 120.0,
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomWidget.getText(Strings.seeMore,
                style: Theme.of(context).textTheme.title.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).unselectedWidgetColor,
                  fontFamily: FileUtils.getFontForText(
                      widget.cardDetailData.id,
                      ListOfItems.listOfTextFonts),
                )),
          ),
        )
            : Container(),
        onTap: () {

          NavigatorUtils.moveToFullScreenDialogForText(context, widget.cardDetailData);
        },
      ),
    );
  }


}
