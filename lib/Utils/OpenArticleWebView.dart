import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/CustomWidgets/LikeWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ShareWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ReShareWidget.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

import 'AppUtils.dart';

class OpenArticleWebView extends StatefulWidget {
  final ActionContentData contentData;
  final int index;
  final List<ActionContentData> content;
  OpenArticleWebView(this.contentData,{this.index,this.content});
  @override
  _OpenWebPageState createState() => _OpenWebPageState();
}
class _OpenWebPageState extends State<OpenArticleWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool _isLoadingPage;

  var contentUrl = "";
  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;

    if ((widget?.contentData?.contentUrl?.length ?? 0) > 0) {
      contentUrl = widget.contentData.contentUrl[0].url;
    }
  }

  @override
  Widget build(BuildContext context) {

    final Set<Factory> gestureRecognizers = [
      Factory(() => EagerGestureRecognizer()),
    ].toSet();

    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              leading: GestureDetector(
                child: Container(
                    height: 50.0,
                    width: 60.0,
                    color: Colors.transparent,
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.clear,color: Theme.of(context).accentColor,size: 24.0,)),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              //automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).appBarTheme.color,
              elevation: 1.0,
              titleSpacing: 0.0,
              title: Padding(padding: EdgeInsets.only(left: 15.0),
              child:  CustomWidget.getText(widget.contentData.contentTitle, style: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0)),
              ),
              actions: <Widget>[
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(child: InkWell(
                        child: Text("Open In Browser"),
                        onTap: ( ) {
                          AppUtils.launchURL(contentUrl);
                        },
                      )),
                    ];
                  },
                ),
              ],
            ),
            preferredSize: Size.fromHeight(48.0)),
        body: WebView(
          gestureRecognizers: gestureRecognizers,
          initialUrl: contentUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          navigationDelegate: (NavigationRequest request) {
            /*if (request.url.startsWith(contentUrl)) {
              PrintUtils.printLog('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }*/
            PrintUtils.printLog('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoadingPage = false;
            });
            PrintUtils.printLog('Page finished loading: $url');
          },
        ),
        /* Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: WebView(
                  gestureRecognizers: gestureRecognizers,
                  initialUrl: contentUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                  // ignore: prefer_collection_literals
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith(contentUrl)) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _isLoadingPage = false;
                    });
                    print('Page finished loading: $url');
                  },
                )
            ),
            _isLoadingPage
                ? Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            )
                : Container(
              color: Colors.transparent,
            ),
          ],
        ),*/
/*bottomNavigationBar: BottomAppBar(
  elevation: 6.0,
  child: Padding(
    padding: const EdgeInsets.all(0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        LikeWidget(
          widget?.contentData,
          isComingFromListing: false,
          iconSize: 4.0,
        ),
       // _bottomAppbarLike(),
        ReShareWidget(
          widget?.contentData,
          isComingFromListing: false,
          iconSize: 4.0,
        ),
        ShareWidget(
          isComingFromListing: false,
          iconSize: 18.0,
          shareContentData: widget?.contentData,
        ),
      ],
    ),
  ),
),*/

bottomNavigationBar: Container(
  height: 54.0,
  child:   BottomAppBar(
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.transparent,
              height: 46.0,
              child: LikeWidget(
                widget?.contentData,
                isComingFromListing: false,
                iconSize: 3.0,
                color: ColorUtils.articleWebViewIconColor,
              ),
            ),
          ),
        /*  Expanded(
            child: Container(
              color: Colors.transparent,
              height: 46.0,
              child: ReShareWidget(
                widget?.contentData,
                isComingFromListing: false,
                iconSize: 3.0,
              ),
            ),
          ),*/
          Expanded(
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.bottomRight,
              height: 46.0,
              child:  ShareWidget(
                isComingFromListing: false,
                iconSize: 3.0,
                cardDetailData: widget?.contentData,
                color: ColorUtils.articleWebViewIconColor,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
    );
  }
}