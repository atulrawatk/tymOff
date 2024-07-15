import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';


class HomeCardUI_YouTube extends StatefulWidget {

  int index = -1;
  final ActionContentData cardDetailData;

 HomeCardUI_YouTube(this.cardDetailData,
      {Key key, int index})
      : super(key: key);

  @override
  _HomeCardUI_YouTubeState createState() => _HomeCardUI_YouTubeState();
}

class _HomeCardUI_YouTubeState extends State<HomeCardUI_YouTube> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getUIForArticle(),
    );
  }

  Widget getUIForArticle() {
    Widget articleWidget = Container();
    var contentUrl = widget.cardDetailData.contentUrl[0].url;
    var thumbnailImage = widget.cardDetailData.contentUrl[0].thumbnailImage;

    if ((contentUrl?.length ?? 0) > 0) {
      articleWidget = new Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            child: ((thumbnailImage?.trim()?.length ?? 0) > 0)
                ? CachedNetworkImage(
              imageUrl: thumbnailImage,
              fit: BoxFit.fill,
            )
                : Container(
              color: (widget.index != null && widget.index > -1 )? ColorUtils().randomGenreColorByIndex(widget.index) : ColorUtils.greyColor,
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              //child: CustomWidget.getText("No article image"),
            ),
            width: double.infinity,
          ),
          Image.asset("assets/youtube_icon.png",fit: BoxFit.fill,scale: 3.5,),
          //getYouTubeSignature(),
        ],
      );
    }
    return articleWidget;
  }

  Widget getYouTubeSignature() {
    return InkWell(
      child: Container(
        height: 25.0,
        width: 25.0,
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(bottom: 4.0, left: 3.0),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xFF3A3A3A).withOpacity(0.5)),
        child: Image.asset("assets/youtube_icon.png",fit: BoxFit.cover,),
      ),
      onTap: () {
      },
    );
  }

}
