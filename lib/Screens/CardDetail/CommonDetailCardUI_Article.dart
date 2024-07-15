import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class CommonDetailCardUI_Article extends StatefulWidget {

  final ActionContentData cardDetailData;

  CommonDetailCardUI_Article(this.cardDetailData);
  @override
  _CommonDetailCardUI_ArticleState createState() => _CommonDetailCardUI_ArticleState();
}

class _CommonDetailCardUI_ArticleState extends State<CommonDetailCardUI_Article>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  String getContentValueText(){
    String contentTextValue = "";

    if((widget?.cardDetailData?.contentValue?.length ?? 0) > 0){
      contentTextValue = contentTextValue + widget.cardDetailData.contentValue;
    }
    return contentTextValue;
  }

  Widget getArticleSignature(){
    return  InkWell(
      child : Container(
          alignment: Alignment.bottomRight,
          height: 30.0,
          width: 120.0,
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              //color: Color(0xFF3A3A3A).withOpacity(0.5)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              SizedBox(width: 4.0,),
              CustomWidget.getText("Visit Website",style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.whiteColor,fontSize: 14.0)),
            ],
          )
      ),
      onTap: () {
        NavigatorUtils.moveToOpenWebView(context, widget.cardDetailData);
      },
    );
  }

  Widget articleDetailContainer() {
    return  Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 16.0, right: 16.0,bottom: 8.0),
      constraints: BoxConstraints.expand(),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: ColorUtils.whiteColor,
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.3, 0.7, 0.8, 1.0],
            colors: [
              Colors.grey[200],
              Colors.grey[200],
              Colors.grey[100],
              Colors.grey[100],
            ],
          ),
        ),
        child: Wrap(
          children: <Widget>[
            CustomWidget.getHtmlText(context,widget.cardDetailData.contentTitle,
                style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.blackColor,fontWeight: FontWeight.bold, fontSize: 20.0)),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(bottom: 8.0),
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: CustomWidget.getHtmlText(context,getContentValueText(),
                style:  Theme.of(context).textTheme.title.copyWith(color: ColorUtils.articleTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget articleSymbol(){
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        height: 40.0,
        decoration: BoxDecoration(
            boxShadow: [

            BoxShadow(
              offset: Offset(2, 2),
              color: ColorUtils.appbarIconColor.withOpacity(0.4),
              blurRadius: 2,
              spreadRadius: 2.0,),
            BoxShadow(
                offset: Offset(-2, -2),
                color: Colors.white.withOpacity(0.5),
                blurRadius: 2,
                spreadRadius: 2.0,)
            ],
          color: ColorUtils.whiteColor,
          //color: Color(0xFFFEEBF1),
           // color: Color(0xFF3A3A3A).withOpacity(0.8),
            borderRadius: BorderRadius.circular(24.0),
            shape: BoxShape.rectangle,
          //border: Border.all(color: Color(0xFFFEEBF1),width: 1.0 )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getArticleIconContainer(),
            SizedBox(width: 12.0,),
            CustomWidget.getText("Visit",style: Theme.of(context).textTheme.title.copyWith(color: Color(0xFF505050),fontSize: 16.0))
          ],
        ),

      ),
    );
  }

  Widget getArticleIconContainer() {
    return  Container(
      child: Image.asset("assets/article_link_icon.png", scale: 3.2,color: Color(0xFF505050),),
    );
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    var contentUrl = widget.cardDetailData.contentUrl;
    var thumbnailImage = contentUrl[0].thumbnailImage;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: (((contentUrl?.length ?? 0) > 0) && ((thumbnailImage?.length ?? 0) > 0)) ? Container(
                margin: EdgeInsets.symmetric(
                  vertical: 40.0,
                ),
                height: 150.0,
                child:  CachedNetworkImage(imageUrl: thumbnailImage,fit: BoxFit.fitWidth,),
                width: double.infinity,
              ) : Container(
                margin: EdgeInsets.symmetric(
                  vertical: 40.0,
                ),
                height: 150.0,
                color: Color(0xfFFDADADA),
                width: double.infinity,
              ),
            ),
            Positioned.fill(
              top: 150.0,
              child: articleDetailContainer(),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              top: 150.0,
              child:  Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 16.0, right: 16.0,bottom: 8.0),
                child: Container(
                  //height: 120.0,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.1, 0.3, 0.5, 0.9],
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.

                        //Color(0xFFFEEBF1).withOpacity(0.7),

                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.0),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 60.0,
              //top: 0.0,
              left: 60.0,
              child:  Container(

                alignment: Alignment.center,
                width: 200.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0,bottom: 20.0),
                child: Container(
                //child: getArticleVisitButton(),
                    child: articleSymbol(),
              ),
            ),
            ),
          ],
        ),
        onTap: (){
          NavigatorUtils.moveToOpenWebView(context, widget.cardDetailData);
        },
      )
    ) ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Munish Thakur -> CommonDetailCardUI_Article -> dispose()");
  }
}