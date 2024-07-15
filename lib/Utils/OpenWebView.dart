import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/CustomWidgets/LikeWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ShareWidget.dart';
import 'package:tymoff/Screens/CustomWidgets/ReShareWidget.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AppUtils.dart';

class OpenWebPage extends StatefulWidget {
  final String contentTitle;
  final String url;
  OpenWebPage({this.contentTitle, this.url});
  @override
  _OpenWebPageState createState() => _OpenWebPageState();
}

class _OpenWebPageState extends State<OpenWebPage> {


  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool _isLoadingPage;

  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().getAppBar(
        context: context,
        title: widget.contentTitle,
        leadingIcon: Icons.arrow_back_ios,
        actionWidget: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: InkWell(
                  child: Text("Open In Browser"),
                  onTap: ( ) {
                    AppUtils.launchURL(widget.url);
                  },
                )),
              ];
            },
          ),
        ]
      ),

        body:  Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,

                  onWebViewCreated: (WebViewController webViewController) {

                    _controller.complete(webViewController);
                  },
                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                  // ignore: prefer_collection_literals
                  navigationDelegate: (NavigationRequest request) {
                    /*if (request.url.startsWith(widget.url)) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }*/
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
                : Container(),
          ],
        ),
    );
  }
}