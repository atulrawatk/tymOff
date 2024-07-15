import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/photofilters.dart';
import 'package:photofilters/utils/image_filter_utils.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Screen/SetBrightnessFilter.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Screen/SetContrastFilter.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

///The PhotoFilterCustomSelector Widget for apply filter from a selected set of filters
class MultiplePhotoFilters extends StatefulWidget {
  static final String KEY_RESPONSE_FILTERED_IMAGES = "image_filtered";
  static final String KEY_FILTER = "filter";
  static final String KEY_IMAGE_LIST = "imagesList";
  static final String KEY_FILE_NAME = "filename";

  final String title;

  final List<Filter> filters;

  final Map<String, FilterImageMeta> mapOfImagesMetaData;

  final Widget loader;
  final BoxFit fit;
  final String filename;
  final bool circleShape;

  static Widget getPhotoFilter(Map<String, FilterImageMeta> imagesMetaData) {
    return MultiplePhotoFilters(
      title: "Select a filter",
      mapOfImagesMetaData: imagesMetaData,
      filters: presetFiltersList,
      loader: Center(child: CircularProgressIndicator()),
      fit: BoxFit.contain,
    );
  }

  const MultiplePhotoFilters({
    Key key,
    @required this.title,
    @required this.filters,
    @required this.mapOfImagesMetaData,
    this.loader = const Center(child: CircularProgressIndicator()),
    this.fit = BoxFit.fill,
    @required this.filename,
    this.circleShape = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      new _MultiplePhotoFilterCustomSelectorState();
}

class _MultiplePhotoFilterCustomSelectorState
    extends State<MultiplePhotoFilters> {
  bool isSinglePicFilter = false;
  Map<String, List<int>> cachedFilters = {};
  Filter _filter;
  bool loading = false;

  PageController _controller;

  List<FilterImageMeta> listOfImagesMetaData = List();
  FilterImageMeta filterImageMeta;

  @override
  void initState() {
    super.initState();

    loading = false;
    _filter = widget.filters[0];
    setListOfImages();

    isSinglePicFilter = (listOfImagesMetaData.length == 1);
    if(isSinglePicFilter) {
      filterImageMeta = listOfImagesMetaData[0];
    }

    _controller =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

    //_buildFilterThumbnailCache();
    //_cacheAllFilterImages();

    _cacheFilterImages(_filter);
  }

  void setListOfImages() {
    listOfImagesMetaData = widget.mapOfImagesMetaData?.values?.toList();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.greyColor,
                size: 24.0,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(color: ColorUtils.greyColor),
        ),
        actions: <Widget>[
          loading
              ? Container()
              : IconButton(
            icon: Icon(
              Icons.check,
              size: 24.0,
              color: ColorUtils.greyColor,
            ),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              var imageFile = await saveFilteredImage();

              Navigator.pop(context,
                  {
                    MultiplePhotoFilters.KEY_RESPONSE_FILTERED_IMAGES: imageFile
                  });
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: loading
            ? widget.loader
            : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(12.0),
                child: buildImagesPageView(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.filters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _buildFilterThumbnail(
                                widget.filters[index], listOfImagesMetaData[0]),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              widget.filters[index].name,
                              style: TextStyle(color: ColorUtils.greyColor),
                            )
                          ],
                        ),
                      ),
                      onTap: () =>
                          setState(() {
                            _filter = widget.filters[index];
                            _cacheFilterImages(_filter);
                          }),
                    );
                  },
                ),
              ),
            ),

            isSinglePicFilter ? bottomFilterOptions() : Container(),
          ],
        ),
      ),
    );
  }

  PageView buildImagesPageView() {
    return PageView.builder(
        itemCount: listOfImagesMetaData?.length ?? 0,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          return _buildFilteredImage(
            _filter,
            listOfImagesMetaData[index],
          );
        });
  }

  Widget bottomFilterOptions() {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          _singleImageFilterOptions(),
        ],
      ),
    );
  }

  Widget _singleImageFilterOptions() {
    return Container(
      child: Row(
        children: <Widget>[
          _setFilterIcon("assets/brightness.png", _eventToggleBrightness),
          _setFilterIcon("assets/contrast.png", _eventToggleContrast),
          _setFilterIcon("assets/crop.png", _eventCrop),
          _setFilterIcon("assets/original_image_icon.png", _eventResetToOriginal),
        ],
      ),
    );
  }

  Widget _setFilterIcon(String assetName, Function onTap) {
    return Expanded(
        child: Container(
          child: Center(
            child: IconButton(
              icon: Image.asset(assetName,scale: 4.0,),
              onPressed: onTap,
            ),
          ),
        ));
  }
  void _eventResetToOriginal() async {
    var _imageMetaData = await getCurrentActiveImageData().handleImageToOriginal(_filter);
    await _handleNewImageSelection(_imageMetaData);

  }

  void _eventToggleBrightness() async {
    var _imageMetaData = getCurrentActiveImageData();
    var listOfBytes = cachedFilters[getCacheKey(_filter, _imageMetaData)];

    Map returnedData = await Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) =>
        SetBrightnessFilter(_imageMetaData, listOfBytes)
    ));

    if (returnedData != null && returnedData.containsKey(SetBrightnessFilter.KEY_RESPONSE_FILTERED_IMAGES_BRIGHTNESS)) {
      List<int> listOfBytes = returnedData[SetBrightnessFilter.KEY_RESPONSE_FILTERED_IMAGES_BRIGHTNESS];
      await _imageMetaData.setImageFilteredUsingBytes(listOfBytes, ImageLightFilter.BRIGHTNESS);

      await _handleNewImageSelection(_imageMetaData);
    }
  }

  void _eventToggleContrast() async {
    var _imageMetaData = getCurrentActiveImageData();
    var listOfBytes = cachedFilters[getCacheKey(_filter, _imageMetaData)];

    Map returnedData = await Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) =>
        SetContrastFilter(_imageMetaData, listOfBytes)
    ));

    if (returnedData != null && returnedData.containsKey(SetContrastFilter.KEY_RESPONSE_FILTERED_IMAGES_CONTRAST)) {
      List<int> listOfBytes = returnedData[SetContrastFilter.KEY_RESPONSE_FILTERED_IMAGES_CONTRAST];
      await _imageMetaData.setImageFilteredUsingBytes(listOfBytes, ImageLightFilter.CONTRAST);

      await _handleNewImageSelection(_imageMetaData);
    }
  }

  FilterImageMeta getCurrentActiveImageData() => listOfImagesMetaData[_controller.page.toInt()];

  void _eventCrop() async {
    var _imageMetaData = listOfImagesMetaData[_controller.page.toInt()];
    File croppedImage = await AppUtils.cropImage(
        _imageMetaData.mediaFileFiltered);

    await _handleNewImageSelectionWithFile(croppedImage, _imageMetaData);
  }

  Future _handleNewImageSelectionWithFile(File filteredImage,
      FilterImageMeta _imageMetaData) async {
    if (filteredImage != null) {
      bool isExist = await filteredImage.exists();
      if (isExist) {
        _imageMetaData.setImageFilteredOnlyFile(filteredImage);
        widget.mapOfImagesMetaData[_imageMetaData.mediaFileName] =
            _imageMetaData;

        cachedFilters.remove(getCacheKey(_filter, _imageMetaData));
        _setListOfImagesAndRefreshUI();

        cachedFilters.clear();
      }
    }
  }

  Future _handleNewImageSelection(
      FilterImageMeta _imageMetaData) async {
    if (_imageMetaData != null) {
      widget.mapOfImagesMetaData[_imageMetaData.mediaFileName] =
          _imageMetaData;

      cachedFilters.remove(getCacheKey(_filter, _imageMetaData));
      _setListOfImagesAndRefreshUI();

      cachedFilters.clear();
    }
  }

  void _cacheAllFilterImages() async {
    for (int index = 0; index < widget.filters.length; index++) {
      var filter = widget.filters[index];
      _cacheFilterImages(filter);
    }
  }

  void _cacheFilterImages(Filter filter) async {
    for (int index = 0; index < listOfImagesMetaData.length; index++) {
      var _imageMeta = listOfImagesMetaData[index];

      await putImageInCache(filter, _imageMeta);
    }
  }

  Future putImageInCache(Filter filter, FilterImageMeta _imageMeta) async {
    List<int> filteredImageBytes = await compute(applyFilter, <String, dynamic>{
      MultiplePhotoFilters.KEY_FILTER: filter,
      MultiplePhotoFilters.KEY_IMAGE_LIST: _imageMeta.mediaFilterLib,
      MultiplePhotoFilters.KEY_FILE_NAME: _imageMeta.mediaFileName,
    });


    cachedFilters[getCacheKey(filter, _imageMeta)] = filteredImageBytes;
  }

  _buildFilterThumbnail(Filter filter, FilterImageMeta imageMeta) {
    if (cachedFilters[getCacheKey(filter, imageMeta)] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          MultiplePhotoFilters.KEY_FILTER: filter,
          MultiplePhotoFilters.KEY_IMAGE_LIST: imageMeta.mediaFilterLib,
          MultiplePhotoFilters.KEY_FILE_NAME: imageMeta.mediaFileName,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 30.0,
                child: Center(
                  child: widget.loader,
                ),
                backgroundColor: Colors.white,
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[getCacheKey(filter, imageMeta)] = snapshot.data;
              return CircleAvatar(
                radius: 30.0,
                backgroundImage: MemoryImage(
                  snapshot.data,
                ),
                backgroundColor: Colors.white,
              );
          }
          return null; // unreachable
        },
      );
    } else {
      return CircleAvatar(
        radius: 30.0,
        backgroundImage: MemoryImage(
          cachedFilters[getCacheKey(filter, imageMeta)],
        ),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(int index) async {
    final path = await _localPath;
    return File(
        '$path/filtered_${_filter?.name ?? "_"}_${listOfImagesMetaData[index]
            .mediaFileName}');
  }

  Future<List<FilterImageMeta>> saveFilteredImage() async {
    List<FilterImageMeta> filteredFiles = List();
    for (int index = 0; index < listOfImagesMetaData.length; index++) {
      var _imageMeta = listOfImagesMetaData[index];
      var imageFile = await localFile(index);

      String imageCacheKey = getCacheKey(_filter, _imageMeta);
      if (!cachedFilters.containsKey(imageCacheKey)) {
        await putImageInCache(_filter, _imageMeta);
      }

      var dataInBytes = cachedFilters[imageCacheKey ?? "_"];

      await imageFile.writeAsBytes(dataInBytes);

      _imageMeta.setImageFiltered(dataInBytes, imageFile);

      filteredFiles.add(_imageMeta);
    }
    return filteredFiles;
  }

  Widget _buildFilteredImage(Filter filter, FilterImageMeta _imageMetaData) {
    if (cachedFilters[getCacheKey(filter, _imageMetaData)] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          MultiplePhotoFilters.KEY_FILTER: filter,
          MultiplePhotoFilters.KEY_IMAGE_LIST: _imageMetaData.mediaFilterLib,
          MultiplePhotoFilters.KEY_FILE_NAME: _imageMetaData.mediaFileName,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return widget.loader;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return widget.loader;
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[getCacheKey(filter, _imageMetaData)] =
                  snapshot.data;
              return widget.circleShape
                  ? SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 3,
                child: Center(
                  child: CircleAvatar(
                    radius: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    backgroundImage: MemoryImage(
                      snapshot.data,
                    ),
                  ),
                ),
              )
                  : buildImageMainPagerUI(snapshot.data, _imageMetaData);
          }
          return null; // unreachable
        },
      );
    } else {
      return widget.circleShape
          ? SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .width / 3,
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: Center(
          child: CircleAvatar(
            radius: MediaQuery
                .of(context)
                .size
                .width / 3,
            backgroundImage: MemoryImage(
              cachedFilters[getCacheKey(filter, _imageMetaData)],
            ),
          ),
        ),
      )
          : Image.memory(
        cachedFilters[getCacheKey(filter, _imageMetaData)],
        fit: widget.fit,
      );
    }
  }

  String getCacheKey(Filter filter, FilterImageMeta imageMeta) {
    return ((filter?.name ?? "") + (imageMeta?.mediaFileName ?? "")) ?? "_";
  }

  Widget buildImageMainPagerUI(List<int> imageData,
      FilterImageMeta _imageMetaData) {
    return Stack(
      children: <Widget>[
        Container(
          child: Image.memory(
            imageData,
            fit: BoxFit.contain,
          ),
        ),

        isSinglePicFilter ? Container() : Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child:  Container(
                //alignment: Alignment.center,
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: ColorUtils.greyColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                  /*borderRadius: BorderRadius.circular(2.0)*/),
                child: IconButton(
                  icon: Image.asset("assets/filter.png",color: Colors.white,scale: 2.0,),
                  onPressed: () {
                    _filterImageSingle(context, _imageMetaData);
                  },),
            ),
          ),
        )
      ],
    );
  }

  Future _filterImageSingle(BuildContext context,
      FilterImageMeta filterImageMeta) async {
    Map<String, FilterImageMeta> imagesMetaData = Map();
    imagesMetaData[filterImageMeta.mediaFileName] = (filterImageMeta);

    _filterImage(context, imagesMetaData);
  }

  Future _filterImage(BuildContext context,
      Map<String, FilterImageMeta> imagesMetaData) async {
    Map imageFilesReturned = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) =>
        new MultiplePhotoFilters(
          title: "Select a filter",
          mapOfImagesMetaData: imagesMetaData,
          filters: widget.filters,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );

    print("Map filtered -> $imageFilesReturned");

    if (imageFilesReturned != null && imageFilesReturned.containsKey(
        MultiplePhotoFilters.KEY_RESPONSE_FILTERED_IMAGES)) {
      List<FilterImageMeta> imageFiles = imageFilesReturned[MultiplePhotoFilters
          .KEY_RESPONSE_FILTERED_IMAGES];

      handleFilteredImage(imageFiles);

      _refreshState();
    }
  }

  void handleFilteredImage(List<FilterImageMeta> imageFilesFiltered) {
    imageFilesFiltered?.forEach((_imageMetaData) {
      widget.mapOfImagesMetaData[_imageMetaData.mediaFileName] = _imageMetaData;
    });

    _setListOfImagesAndRefreshUI();
  }

  void _setListOfImagesAndRefreshUI() {
    setListOfImages();
    _refreshState();
  }

  void _refreshState() {
    setState(() {});
  }
}

///The global applyfilter function
List<int> applyFilter(Map<String, dynamic> params) {
  Filter filter = params[MultiplePhotoFilters.KEY_FILTER];
  imageLib.Image imagesList = params[MultiplePhotoFilters.KEY_IMAGE_LIST];
  String filename = params[MultiplePhotoFilters.KEY_FILE_NAME];
  List<int> _bytes = imagesList.getBytes();
  if (filter != null) {
    filter.apply(_bytes);
  }
  imageLib.Image _image =
  imageLib.Image.fromBytes(imagesList.width, imagesList.height, _bytes);
  _bytes = imageLib.encodeNamedImage(_image, filename);

  return _bytes;
}

///The global buildThumbnail function
List<int> buildThumbnail(Map<String, dynamic> params) {
  int width = params["width"];
  params["imagesList"] =
      imageLib.copyResize(params["imagesList"], width: width);
  return applyFilter(params);
}
