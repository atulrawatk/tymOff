import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
/*import 'package:gif_ani/gif_ani.dart';*/
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Image.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Text.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Video.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Youtube.dart';
import 'package:tymoff/Screens/CardDetail/HomeCardUI_YouTube.dart';
import 'package:tymoff/Screens/CustomWidgets/ContentTileOptionsWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/LikeWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ShareWidget.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/OpenArticleWebView.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

var TAG = "Munish Log ->";

class ContentListingTile extends StatefulWidget {
  static double cardWidth = 150.0;
  final double DEFAULT_HEIGHT = 100.0;
  static bool isDynamicHeight = false;
  final int index;
  final List<ActionContentData> _contentList;
  final ContentBloc _blocContent;
  ActionContentData _contentItem;
  bool _isDeleteEnabled = false;

  ContentListingTile(this._blocContent, this.index, this._contentList, {bool isDeleteEnabled}) {
    this._contentItem = _contentList[index];
    _isDeleteEnabled = AppUtils.isValid(isDeleteEnabled, defaultReturn: _isDeleteEnabled);
  }

  @override
  _ContentListingTileState createState() =>
      _ContentListingTileState();
}

class _ContentListingTileState
    extends State<ContentListingTile>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //GifController _animationCtrl;

  var index;
  var contentUrl;
  var thumbnailImage;
  var contentTitle;
  var contentValue;
  var typeId;
  var contentType;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();

    index = widget.index;
    if (widget._contentItem.contentUrl.length > 0) {
      contentUrl = widget._contentItem.contentUrl[0].url;
      thumbnailImage = widget._contentItem.contentUrl[0].thumbnailImage;
    }
    contentTitle = widget._contentItem.contentTitle;
    contentValue = widget._contentItem.contentValue;
    typeId = widget._contentItem.typeId;

    contentType = ContentTypeUtils.getType(typeId, contentUrl: contentUrl);

   /* _animationCtrl = new GifController(
        vsync: this,
        duration: new Duration(milliseconds: 2000),
        frameCount: 20);*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //_animationCtrl.dispose();
    super.dispose();
  }

  /// Gif UI method
  var isGifPlaying = false;

  Widget _buildGif(int index) {
    Widget gifWidget = Container();
    var contentUrl = widget._contentItem.contentUrl;
    if (contentUrl != null && contentUrl.length > 0) {
      var gifUrl = contentUrl[0].url;

      gifWidget = new Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[/*
          GifAnimation(
            image: NetworkImage(gifUrl),
            controller: _animationCtrl,
          ),
          _animationCtrl.isAnimating == false
              ? InkWell(
            child: Container(
              margin: EdgeInsets.only(
                bottom: 4.0,
              ),
              padding: EdgeInsets.all(6.0),
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                "assets/gif_icon.png",
                scale: 3.0,
              ),
            ),
            onTap: () {
              _animationCtrl.runAni();
            },
          )
              : Container(),*/
        ],
      );
    }
    return gifWidget;
  }

  /// Content Widget related to content type.
  Widget getContentWidgetContainer(
      AppContentType type, List<ContentUrlData> contentUrls, int index) {

    var minHeight = widget.DEFAULT_HEIGHT;

    if (type == AppContentType.image || type == AppContentType.gif) {
      try {
        minHeight = contentUrls[0].height;
      } catch(e){}

      if(minHeight == null) {
        minHeight = widget.DEFAULT_HEIGHT;
      }
    }

    Widget childWidget = Container();

    if (type == AppContentType.image) {
      childWidget = CommonDetailCardUI_Image(index, minHeight, contentUrls);
    } else if (type == AppContentType.video) {
      childWidget = CommonDetailCardUI_Video(
          widget._contentItem, PlayerType.HOME_CARD_CONTROLL);
    } else if (type == AppContentType.text) {
      childWidget = CommonDetailCardUI_Text(
        widget._contentItem,
        isComingFromContentListing: true,
      );
    } else if (type == AppContentType.article) {
      childWidget = getUIForArticle(index);
    } else if (type == AppContentType.gif) {
      childWidget = _buildGif(index);
    } else if (type == AppContentType.youtube) {
      /*childWidget = Container(
        width: 200.0,
        height: 200.0,
        color: Colors.red,
      );*/
      childWidget = HomeCardUI_YouTube(widget._contentItem, index: index,);
    }

    Widget containerWidget;

    containerWidget = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: childWidget,
    );

    return containerWidget;
  }

  /// Method for splitting web url...
  static String urlSubstring(String urlString) {
    if (urlString == null) return "";
    if (urlString.trim().length <= 0) return "";

    try {
      String subStringInitial =
      urlString.substring(urlString.indexOf(".") + 1, urlString.length);
      if (subStringInitial.contains("/")) {
        String subStringFinal =
        subStringInitial.substring(0, subStringInitial.indexOf("/"));

        return subStringFinal;
      }
      return subStringInitial;
    } catch (e) {
      print("urlSubstring -> ${e.toString()}");
    }

    return "";
  }

  /// Article UI
  Widget getUIForArticle(int index) {
    Widget articleWidget = Container();
    var contentUrl = widget._contentItem.contentUrl[0].url;
    var thumbnailImage = widget._contentItem.contentUrl[0].thumbnailImage;
    if (contentUrl != null && contentUrl.length > 0) {
      articleWidget = new Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            child: ((thumbnailImage?.length ?? 0) > 0)
                ? CachedNetworkImage(
              imageUrl: thumbnailImage,
              fit: BoxFit.fill,
            )
                : Container(
              color: Color(0xfFFDADADA),
              width: MediaQuery.of(context).size.width,
              height: widget.DEFAULT_HEIGHT,
              //child: CustomWidget.getText("No article image"),
            ),
            width: double.infinity,
          ),
          getArticleSignature(),
        ],
      );
    }
    return articleWidget;
  }

  /// Article Signature to show the coming content is article.
  Widget getArticleSignature() {
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
        child: Image.asset("assets/article_link_icon.png", scale: 2.5),
      ),
      onTap: () {
        NavigatorUtils.moveToOpenWebView(context, widget._contentItem);
      },
    );
  }

  /// build() method
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _isContentDeleted() ? Container() : mainContentCardUI(context);
  }

  bool _isContentDeleted() {
    return (widget?._contentItem?.isDeleted ?? false);
  }

  Widget mainContentCardUI(BuildContext context) {
    return InkWell(
      child: new Card(
        color: Theme.of(context).cardColor,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                //new Center(child: new CircularProgressIndicator()),
                getContentWidgetContainer(
                    contentType, widget._contentItem.contentUrl, index)
              ],
            ),
            contentType != AppContentType.text
                ? Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  (contentTitle != "")
                      ? CustomWidget.getHtmlText(context, contentTitle,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontWeight: FontWeight.w500))
                      : Container(),
                  SizedBox(
                    height: 0.0,
                  ),
                  (contentValue != null && contentValue.length > 0)
                      ? getContentValue(contentValue)
                      : Container(),
                ],
              ),
            )
                : Container(
              height: 0.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 54.0,
                        color: Colors.transparent,
                        child: LikeWidget(
                          widget?._contentItem,
                          isComingFromListing: true,
                          iconSize: 4.0,
                        ),
                      ),

                      /// code commented temporary
                      Container(
                          padding: const EdgeInsets.only(
                              left: 4.0, top: 4.0, bottom: 4.0),
                          color: Colors.transparent,
                          width: 20.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Image.asset("assets/comment.png",
                                      scale: 4.0,
                                      color: Theme.of(context).iconTheme.color)),
                            ],
                          )),
                    ],
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: ShareWidget(
                    isComingFromListing: true,
                    iconSize: 18.0,
                    cardDetailData: widget?._contentItem,
                  ),
                  flex: 0,
                ),
                widget._isDeleteEnabled ?
                Expanded(
                  child: ContentTileOptionsWidget(
                      widget?._contentItem,
                      index,
                      widget._blocContent,
                      iconSize: 18.0,
                    isComingFormList: true,
                  ),
                  flex: 0,
                ) : Container(),
              ],
            ),
          ],
        ),
      ),
      onTap: () {

        //widget._blocContent.scrollToIndex(widget.index);

        NavigatorUtils.moveToContentDetailScreen(
            context, widget._blocContent, widget._contentList, widget.index);

        if (contentType == AppContentType.article) {

          NavigatorUtils.moveToOpenWebView(context, widget._contentItem);

        } else if(contentType == AppContentType.text) {

          if(widget._contentItem.contentValue.length > 200) {
            Future.delayed(Duration.zero, () {
              NavigatorUtils.moveToFullScreenDialogForText(context, widget._contentItem);
            });
          }

        }
        AnalyticsUtils?.analyticsUtils?.eventContentdetailscreenButtonClicked();
      },
    );
  }

  Widget getContentValue(String contentValue) {
    var contentValueToShow = "";
    if (contentValue.length > 200) {
      contentValueToShow = contentValueToShow + contentValue.substring(0, 200);
    } else {
      contentValueToShow = contentValue;
    }
    return CustomWidget.getHtmlText(context, contentValueToShow,
        style: Theme.of(context).textTheme.subtitle);
  }
}