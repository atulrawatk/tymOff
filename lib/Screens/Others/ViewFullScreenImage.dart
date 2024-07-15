import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:photo_view/photo_view.dart';

class ViewFullScreenImage extends StatefulWidget {

  String imageUrl;

  ViewFullScreenImage(this.imageUrl);

  @override
  _ViewFullScreenImageState createState() => _ViewFullScreenImageState();
}

class _ViewFullScreenImageState extends State<ViewFullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        titleSpacing: 0.0,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
                size: 20.0,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: getImageWidget(),
    );
  }


  Widget getImageWidget() {

    Widget imageWidget = Container();

    Widget widgetCustomImage =  Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Center(
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
              placeholderFadeInDuration: Duration(seconds: 1),
              fadeInCurve: Curves.easeInOutCubic,
              fadeInDuration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );

    imageWidget = PhotoView.customChild(child: widgetCustomImage, childSize: const Size(220.0, 250.0),
      initialScale: PhotoViewComputedScale.contained,
      maxScale: 10.0,
      minScale: PhotoViewComputedScale.contained * 0.8,
      enableRotation: false,);

    return imageWidget;
  }

}
