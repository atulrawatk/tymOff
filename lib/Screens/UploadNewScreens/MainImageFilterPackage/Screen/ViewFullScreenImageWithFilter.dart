import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/PhotoFilterUtils/MultiplePhotoFilters.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class ViewFullScreenImageWithFilter extends StatefulWidget {

  FilterImageMeta _imageMetaData;

  ViewFullScreenImageWithFilter(this._imageMetaData);

  @override
  _ViewFullScreenImageWithFilterState createState() => _ViewFullScreenImageWithFilterState();
}

class _ViewFullScreenImageWithFilterState extends State<ViewFullScreenImageWithFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomWidget.getText("Full screen Image", style: TextStyle(color: ColorUtils.greyColor),),
        elevation: 1.0,
        titleSpacing: 0.0,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: isFilteredImageAvailable() ? Icon(Icons.check,size: 24.0,)
                : Image.asset("assets/edit_tym.png",scale: 2.5,) ,
            color: ColorUtils.greyColor,
            onPressed: () {
              if(isFilteredImageAvailable()) {
                _eventSaveFilteredImage();
              } else {
                _eventEditImage();
              }
            },
          )
        ],
        leading: IconButton(icon: Icon(Icons.clear,color: ColorUtils.greyColor,size: 24.0,), onPressed: (){
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
            Image.file(
              widget._imageMetaData.mediaFileFiltered,
              fit: BoxFit.cover,
            ),
            /*CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
              placeholderFadeInDuration: Duration(seconds: 1),
              fadeInCurve: Curves.easeInOutCubic,
              fadeInDuration: Duration(milliseconds: 200),
            ),*/
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

  List<FilterImageMeta> _filteredImageFiles;

  bool isFilteredImageAvailable() => (_filteredImageFiles != null && _filteredImageFiles.length > 0);

  void _eventEditImage() async {

    _filteredImageFiles = await NavigatorUtils.navigateToPhotoFilterSingle(context, widget._imageMetaData);

    if (isFilteredImageAvailable()) {
      widget._imageMetaData = _filteredImageFiles[0];
      refreshState();
    }
  }

  void _eventSaveFilteredImage() async {

    Navigator.pop(context, {
          MultiplePhotoFilters.KEY_RESPONSE_FILTERED_IMAGES: _filteredImageFiles
        });

    _filteredImageFiles = null;
  }

  void refreshState() {
    setState(() {});
  }

}
