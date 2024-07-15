import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Text.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/ListOfItems.dart';
import 'package:tymoff/Utils/SizeConfig.dart';

class FullScreenDialogForText extends StatefulWidget {
  ActionContentData cardDetailData;
  FullScreenDialogForText(this.cardDetailData);

  @override
  FullScreenDialogForTextState createState() => FullScreenDialogForTextState();
}

class FullScreenDialogForTextState extends State<
    FullScreenDialogForText> /*with SingleTickerProviderStateMixin*/ {

/*
  String htmlTempText = '<p> <p style="color:red;">I am red</p> <p style="color:blue;">I am blue</p> '
      '<p style="font-size:50px;">I am big</p> <span style=\"color: rgba(0, 0, 0, 0.9);\">Gabbar Singh was a real MANAGEMENT GURU. </span>'
      '</p><p><span style=\"color: rgba(0, 0, 0, 0.9);\"> </span></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">Points he taught:</span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">1. Jo Darr Gaya - Samjho Mar Gaya!</span></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">Courage and enterprise are important factors for laying the successful foundation of a growth oriented business.</span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">IT NEEDS COURAGE.</span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">2.Kitne Admi The? </span></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">Its important to know the competition and its size. He understood that even a small team can make a difference. </span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">3. Arey O Sambha,'
      'ures to minimise them</span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">7. Holi Kab Hai, Kab Hai Holi ?</span></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">Conduct advance mapping of key events within the industry and devise penetration strategy to have a competitive edge over your rivals.</span></p><p><br></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">8.Basanti, Naach!</span></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">Motivate your team through rewards beyond just salary and bonus.....</span></p><p><br></p><p><br></p>';
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 1.0,
            leading: IconButton(
                icon: Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.transparent,
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.clear,
                      color: ColorUtils.greyColor,
                      size: 30.0,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            titleSpacing: 0.0,
          ),
      body: Container(
        color: Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                child: getContentContainerWidgetTextOnly(),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }

  Widget getContentContainerWidgetTextOnly() {
    Widget textWidget;
    textWidget = Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
      (widget.cardDetailData.contentTitle == null || widget.cardDetailData.contentTitle == "") ? Container() : CustomWidget.getHtmlText(
            context,
            widget?.cardDetailData?.contentTitle?? "",
            style: Theme.of(context).textTheme.title.copyWith(
                color: ColorUtils.whiteColor, /*fontFamily: "Helvetica"*/
                fontSize: 24.0,
                fontFamily: FileUtils.getFontForText(widget.cardDetailData.id,ListOfItems.listOfTextFonts)),
          ),

          CustomWidget.getHtmlText(
            context,
            widget.cardDetailData.contentValue,
            style: Theme.of(context).textTheme.title.copyWith(
                color: ColorUtils.whiteColor, /*fontFamily: "Helvetica"*/
                fontSize: 24.0,
                fontFamily: FileUtils.getFontForText(widget.cardDetailData.id,ListOfItems.listOfTextFonts)),
          ),
        ],
      ),
    );

    return textWidget;
  }
}
