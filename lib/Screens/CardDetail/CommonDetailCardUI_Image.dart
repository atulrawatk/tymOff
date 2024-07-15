import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

class CommonDetailCardUI_Image extends StatefulWidget {
  final int index;
  final double minHeight;
  final List<ContentUrlData> contentUrls;

  const CommonDetailCardUI_Image(this.index,  this.minHeight, this.contentUrls);

  @override
  _CommonDetailCardUI_ImageState createState() =>
      _CommonDetailCardUI_ImageState();
}

class _CommonDetailCardUI_ImageState extends State<CommonDetailCardUI_Image>
    with AutomaticKeepAliveClientMixin {
/*
  GifController _animationCtrl;


  @override
  void dispose() {
    _animationCtrl.dispose();
    super.dispose();
  }

  /// Gif UI method
  var isGifPlaying = false;*/

  bool isGif() {
    var contentIsGif = false;
    if ((widget?.contentUrls?.length ?? 0) > 0) {
      if (getContentUrl().contains(".gif")) {
        contentIsGif = true;
      } else {
        contentIsGif = false;
      }
    }
    return contentIsGif;
  }

  @override
  bool get wantKeepAlive => true;

  Widget _getErrorWidget() {
    Color color = ColorUtils().randomShimmerLoadingColorGeneratorByIndex(widget.index);

    Widget containerWidget;

    containerWidget = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
      ),
      child: Container(
        color: color,
      ),
    );

    return containerWidget;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (widget.contentUrls != null && (widget?.contentUrls?.length ?? 0) > 0)
        ? Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: getContentUrl(),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => _getErrorWidget(),
              ),
              (isGif() || (widget?.contentUrls?.length ?? 0) > 1)
                  ? Container(
                      height: 18.0,
                      width: 18.0,
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(bottom: 3.0, left: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      child: Image.asset(
                        isGif() ? "assets/gif_icon.png" : "assets/album.png",
                        scale: 2.5,
                        fit: BoxFit.cover,
                        //color: Colors.white,
                      ),
                    )
                  : Container(),
            ],
          )
        : Container();
  }

  String getContentUrl() {
    String contentUrl = "";
    try {
      contentUrl = widget.contentUrls[0].thumbnailImage;
      if(contentUrl == null) {
        contentUrl = widget.contentUrls[0].url;
      } else if((contentUrl?.trim()?.length ?? 0) <= 0) {
        contentUrl = widget.contentUrls[0].url;
      }
    } catch(e){

    }

    return contentUrl;
  }
}
