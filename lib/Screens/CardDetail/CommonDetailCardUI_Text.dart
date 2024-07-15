import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/CardDetail/FullScreenDialogForText.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/ListOfItems.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

class CommonDetailCardUI_Text extends StatefulWidget {
  final ActionContentData cardDetailData;
  double fontSize = 14.0;
  Color textColor = ColorUtils.blackColor;
  bool isComingFromContentListing = false;

  CommonDetailCardUI_Text(this.cardDetailData,
      {this.fontSize, this.textColor, this.isComingFromContentListing = false});

  @override
  _CommonDetailCardUI_TextState createState() =>
      _CommonDetailCardUI_TextState();
}

class _CommonDetailCardUI_TextState extends State<CommonDetailCardUI_Text>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isShowMore = false;
  bool isAlreadyShown = false;

  @override
  void initState() {
    isShowMore = (widget?.cardDetailData?.contentValue?.length ?? 0)> 200 &&
        widget.isComingFromContentListing == false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String removeAllHtmlTags(String htmlText, String tagToReplace) {

    String regEx = "";

    //regEx = "(<(/)?$tagToReplace[\s]*(/)?>)+";

    regEx = "(<(/)?p[\s]*(/)?>)+[\s]*((<(/)?br[\s]*(/)?>)+)?";
    htmlText = _regExAndMatch(regEx, htmlText, tagToReplace);

    regEx = "(<(/)?br[\s]*(/)?>)+[\s]*((<(/)?p[\s]*(/)?>)+)?";
    htmlText = _regExAndMatch(regEx, htmlText, tagToReplace);

    return htmlText;
  }

  String _regExAndMatch(String regEx, String htmlText, String tagToReplace) {
    RegExp expression = RegExp(regEx,
        multiLine: true,
        caseSensitive: false,
    );

    var itrMatches = expression.allMatches(htmlText);
    for (int index = 0; index < itrMatches?.length ?? 0; index++) {
      //String match = itrMatches.elementAt(index);
      for (int indexGroup = 0; indexGroup < itrMatches.elementAt(index).groupCount; indexGroup++) {
        String groupString = itrMatches
            .elementAt(index)
            .group(indexGroup);
        if(groupString != null) {
          int groupTagsCount = groupString?.split(tagToReplace)?.length ?? 0;

          if(groupTagsCount >= 2 && groupTagsCount <= 7) {
            htmlText = htmlText.replaceFirst(groupString, "<$tagToReplace>");
          }
        }
      }
    }
    return htmlText;
  }

  String _parseHtmlString(String htmlString) {

    htmlString = removeAllHtmlTags(htmlString, "br");
    //htmlString = removeAllHtmlTags(htmlString, "p");

    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    var htmlStringMorphed = htmlString;
    try {
      var lastChars = parsedString.substring(parsedString.length - 12, parsedString.length);
      if (htmlString.contains(lastChars)) {
        htmlStringMorphed =
            htmlString.substring(0, htmlString.indexOf(lastChars));
        htmlStringMorphed = htmlStringMorphed + "...";
      }
    } catch (e) {
      print("Munish Thakur -> _parseHtmlString() -> ${e.toString()}");
    }

    return htmlStringMorphed;
  }

  String getContentValueText() {
    String contentTextValue = "";
    try {
      if (widget.cardDetailData.contentValue.length > 200) {
        String prefixString =
        widget.cardDetailData.contentValue.substring(0, 201);
        String suffixString = widget.cardDetailData.contentValue.substring(
            201, widget.cardDetailData.contentValue.length);
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
    return _parseHtmlString(contentTextValue).trim();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.isComingFromContentListing
        ? buildComingFromContentListingUI(context)
        : buildContainerNotComingFromContentListingUITemp(context);
  }

  Widget buildComingFromContentListingUI(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[

          (widget.cardDetailData.contentTitle == null && widget.cardDetailData.contentTitle == "") ? Container() : CustomWidget.getHtmlText(
            context,
            widget?.cardDetailData?.contentTitle ?? "",
            style: Theme.of(context).textTheme.title.copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
                fontFamily: FileUtils.getFontForText(
                    widget.cardDetailData.id, ListOfItems.listOfTextFonts)),
      ),

          CustomWidget.getHtmlText(
            context,
            getContentValueText(),
            style: Theme.of(context).textTheme.title.copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
                fontFamily: FileUtils.getFontForText(
                    widget.cardDetailData.id, ListOfItems.listOfTextFonts)),
          )
        ],
      ),
    );
  }

  Widget buildContainerNotComingFromContentListingUITemp(BuildContext context) {
    Widget _widgetText = Container();

    _widgetText = Container(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Center(
              child: Wrap(
                children: <Widget>[

            (widget.cardDetailData.contentTitle == null || widget.cardDetailData.contentTitle == "") ? Container() : Container(
                    child: CustomWidget.getHtmlText(
                      context,
                      widget?.cardDetailData?.contentTitle ?? "",
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: widget.fontSize,
                          color: widget.textColor,
                          fontFamily: FileUtils.getFontForText(
                              widget.cardDetailData.id,
                              ListOfItems.listOfTextFonts)),
                    ),
                  ),

                  Container(
                    child: CustomWidget.getHtmlText(
                      context,
                      getContentValueText(),
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: widget.fontSize,
                          color: widget.textColor,
                          fontFamily: FileUtils.getFontForText(
                              widget.cardDetailData.id,
                              ListOfItems.listOfTextFonts)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
                right: 0.0,
                child: buildSeeMoreGestureDetector(context)
            ),
          ],
        ));

    return _widgetText;
  }

  Widget buildSeeMoreGestureDetector(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.transparent,
      width: 160.0,
      child: InkWell(
        child: isShowMore
            ? Container(
          alignment: Alignment.centerRight,
          child: CustomWidget.getText(Strings.seeMore,
              style: Theme.of(context).textTheme.title.copyWith(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: FileUtils.getFontForText(
                    widget.cardDetailData.id,
                    ListOfItems.listOfTextFonts),
              )),
        )
            : Container(),
        onTap: () {

          NavigatorUtils.moveToFullScreenDialogForText(context, widget.cardDetailData);
        },
      ),
    );
  }
}
