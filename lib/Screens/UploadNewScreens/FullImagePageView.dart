import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';

class FullImagePageView extends StatefulWidget {
  @override
  _FullImagePageViewState createState() => _FullImagePageViewState();
}

class _FullImagePageViewState extends State<FullImagePageView> {

  final _controllerImageAlbum = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().getAppBar(context: context,title: "Images", leadingIcon: Icons.clear),
      body: Container(
        child: showImageGallery(),
      ),
    );
  }


  Widget showImageGallery() {
    return  PageView.builder(
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _controllerImageAlbum,
          scrollDirection: Axis.vertical,
          itemCount: 10,
          onPageChanged: (index) {
           // pageChanged(index);
          },
          itemBuilder: (BuildContext context, int index) {
            return showImageWidget();
          },
    );
  }


  Widget showImageWidget() {

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
              imageUrl: "https://cdn.tymoff.com/themes/content_files/images/2019-10-09/qXtZMWPEYrJrYMBgdYf1VWsyLAAphn697461536330804.jpg",
              fit: BoxFit.contain,
              //placeholder: (context, url) => getThumbnailImageWidget(contentData),
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

    return widgetCustomImage;
  }

}
