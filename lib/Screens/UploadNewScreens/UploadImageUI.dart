import 'dart:collection';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/UploadNewScreens/SelectGenreOrLanguageUploadUI.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/DialogUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:tymoff/Utils/ValidationUtil.dart';

import 'MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'UploadAppBar.dart';
import 'UploadContentDescription.dart';

class UploadImageUI extends StatefulWidget {
  RequestDraftUploadData _draftData;
  bool _isEditModeActive = false;

  UploadImageUI(
      {RequestDraftUploadData draftData, bool isEditModeActive = false}) {
    this._draftData = draftData;
    this._isEditModeActive = isEditModeActive;
  }

  @override
  _UploadImageUIState createState() => _UploadImageUIState();
}

class _UploadImageUIState extends State<UploadImageUI> {
  TextEditingController _descriptionController = TextEditingController();
  List<Filter> filters = presetFiltersList;
  LinkedHashMap<String, FilterImageMeta> mapOfMediaMetaData = LinkedHashMap();
  List<FilterImageMeta> listOfMediaMetaData = List();

  bool isMediaPickerShown = false;

  PageController _pageController;

  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsGenre =
      HashMap<int, MetaDataResponseDataCommon>();
  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsLanguage =
      HashMap<int, MetaDataResponseDataCommon>();

  @override
  void initState() {
    _checkDraftDataAndPopulateInit();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.7,
    ); //..addListener(_onScroll);

    _setListOfMedia();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget._isEditModeActive != null && !widget._isEditModeActive) {
      if (!isMediaPickerShown) {
        isMediaPickerShown = true;
        _getAndProcessMedia(context, FileType.IMAGE);
      }
    }
  }

  void _checkDraftDataAndPopulateInit() {
    if (widget._draftData != null) {
      _hmSelectedItemsGenre.addAll(widget._draftData.hmSelectedItemsGenre);
      _hmSelectedItemsLanguage
          .addAll(widget._draftData.hmSelectedItemsLanguage);

      List<File> listOfFiles = widget._draftData.getUploadFileList();
      List<FilterImageMeta> filterMediaMetaList = processFileMeta(listOfFiles);
      handleFilteredMedia(filterMediaMetaList);
    }
  }

  void _setListOfMedia() {
    listOfMediaMetaData = mapOfMediaMetaData?.values?.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UploadAppBar().getAppBar(
          context: context,
          title: "Upload Image",
          onTapNextButton: _onClickNextButton),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: buildMainScrollView(context),
          ),
          getBottomUI(),
        ],
      ),
    );
  }

  Widget buildMainScrollView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: Column(
        children: <Widget>[
          UploadContentDescription(
            descriptionValueText: widget?._draftData?.getDescription(),
            descriptionController: _descriptionController,
            descriptionHintText: Strings.commonDescriptionHintTextForUpload,
          ),
          Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(8.0),
              child: buildMediaListView()),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          SelectGenreOrLanguageUploadUI(SelectionUploadChipTypes.GENRE,
              hmSelectedItems: _hmSelectedItemsGenre),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          SelectGenreOrLanguageUploadUI(SelectionUploadChipTypes.LANGUAGE,
              hmSelectedItems: _hmSelectedItemsLanguage),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Widget getBottomUI() {
    return listOfMediaMetaData?.length == 0
        ? Container()
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8.0, // has the effect of softening the shadow
                      spreadRadius:
                          2.0, // has the effect of extending the shadow
                      offset: Offset(
                        10.0, // horizontal, move right 10
                        10.0, // vertical, move down 10
                      ),
                    )
                  ],
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(8.0),
                      topRight: const Radius.circular(8.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 44.0,
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                color: Colors.transparent,
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 6.0),
                                child: getGestureOnBottomWidgets(
                                    "assets/upload_album.png", onTap: () {
                                  _pickMedia(context, FileType.IMAGE);
                                }),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Container(
                                color: Colors.transparent,
                                padding:
                                    EdgeInsets.only(left: 4.0, right: 10.0),
                                child: getGestureOnBottomWidgets(
                                    "assets/upload_camera.png", onTap: () {
                                  pickerCamera(context);
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          color: Colors.transparent,
                          child: getGestureOnBottomWidgets("assets/filter.png",
                              onTap: () {
                            eventFilterMedia();
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget getGestureOnBottomWidgets(String assetName, {onTap}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.transparent,
        child: Image.asset(assetName),
      ),
      onTap: onTap,
    );
  }

  void pickerCamera(BuildContext context) async {
    try {
      File cameraMedia = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 2000.0, maxHeight: 2000.0);
      if (cameraMedia != null) {
        List<File> _mediaFilesOriginal = List();
      _mediaFilesOriginal.add(cameraMedia);

      print("Munish Thakur -> pickerCamera() -> 1");

      _processUserSelectedFiles(_mediaFilesOriginal, context);
      } else {
        ToastUtils.show("File not added");
      }
    } catch(e){
      print("Munish Thakur -> pickerCamera() -> ${e.toString()}");
    }
  }

  void eventFilterMedia() {
    _filterMedia(context, mapOfMediaMetaData);
  }

  Future _getAndProcessMedia(
      BuildContext context, FileType fileSelectionType) async {

    List<File> _mediaFilesOriginal =
        await FilePicker.getMultiFile(type: fileSelectionType);

    if (_mediaFilesOriginal != null &&
        _mediaFilesOriginal.length <= Constant.DEFAULT_MAX_IMAGE_MEDIA_SELECTION_ALLOWED) {
      _processUserSelectedFiles(_mediaFilesOriginal, context);
    } else {
      ToastUtils.show(
          "Maximum ${Constant.DEFAULT_MAX_IMAGE_MEDIA_SELECTION_ALLOWED} Images selection allowed");
    }
  }

  void _processUserSelectedFiles(
      List<File> _mediaFilesOriginal, BuildContext context) {

    //DialogUtils.showProgress(context);

    List<FilterImageMeta> filterMediaMetaList =
        processFileMeta(_mediaFilesOriginal);

    Map<String, FilterImageMeta> mediaMetaData = Map();
    filterMediaMetaList?.forEach((_mediaMetaData) {
      mediaMetaData[_mediaMetaData.mediaFileName] = _mediaMetaData;
    });

    _filterMedia(context, mediaMetaData);


    //DialogUtils.hideProgress(context);
  }

  List<FilterImageMeta> processFileMeta(List<File> mediaFiles) {
    List<FilterImageMeta> mediaMetaData = List<FilterImageMeta>();

    for (int index = 0; index < mediaFiles.length; index++) {
      File mediaFile = mediaFiles[index];
      FilterImageMeta filterMediaMeta = FilterImageMeta(mediaFile);

      mediaMetaData.add(filterMediaMeta);
    }

    return mediaMetaData;
  }

  Future _filterMediaSingle(
      BuildContext context, FilterImageMeta filterMediaMeta) async {
    Map<String, FilterImageMeta> mediaMetaData = Map();
    mediaMetaData[filterMediaMeta.mediaFileName] = (filterMediaMeta);

    _filterMedia(context, mediaMetaData);
  }

  Future _filterMedia(
      BuildContext context, Map<String, FilterImageMeta> mediaMetaData) async {
    List<FilterImageMeta> mediaFiles =
        await NavigatorUtils.navigateToPhotoFilter(context, mediaMetaData);

    _handleFilteredMediasResult(mediaFiles);
  }

  Future _filterMediaFullScreen(
      BuildContext context, FilterImageMeta filterMediaMeta) async {
    List<FilterImageMeta> mediaFiles =
        await NavigatorUtils.navigateToFillScreenWithFilterOption(
            context, filterMediaMeta);

    _handleFilteredMediasResult(mediaFiles);
  }

  void _handleFilteredMediasResult(List<FilterImageMeta> mediaFiles) {
    if (mediaFiles != null) {
      handleFilteredMedia(mediaFiles);

      AppUtils.refreshCurrentState(this);
    }
  }

  void _pickMedia(BuildContext context, FileType fileSelectionType) async {
    _getAndProcessMedia(context, fileSelectionType);
  }

  void _onClickNextButton() async {
    //Navigator.of(context).pop();

    String filledDescription = (_descriptionController?.text ?? "");
    print("_onClickNextButton() -> filledDescription -> $filledDescription");

    List<int> fileSizes = mapOfMediaMetaData.values?.map((_media) => _media.fileSize)?.toList();
    bool isFileSizeValidToUpload = AppUtils.isTotalFileSizesValidToUpload(fileSizes);

    if(!isFileSizeValidToUpload) {
      ToastUtils.show(Strings.maxUploadSizeError);
    } else if (mapOfMediaMetaData != null && mapOfMediaMetaData.length <= 0) {
      ToastUtils.show("Please Select Image('s)");
    } else if (mapOfMediaMetaData != null &&
        mapOfMediaMetaData.length > Constant.DEFAULT_MAX_IMAGE_MEDIA_SELECTION_ALLOWED) {
      ToastUtils.show(
          "Max ${Constant.DEFAULT_MAX_IMAGE_MEDIA_SELECTION_ALLOWED} allowed to upload");
    } else if (!ValidationUtil.isGenreLanguageValidInUploadFlow(
        _hmSelectedItemsGenre, _hmSelectedItemsLanguage)) {
    } else {
      var hmMediaDraftData = mapOfMediaMetaData.map((key, _mediaData) {
        var mediaDraftData = FilterImageMeta.getImageData(_mediaData);
        return MapEntry(key, mediaDraftData);
      });

      String localId = widget?._draftData?.getUID();

      RequestDraftUploadData requestUploadDataToServer = RequestDraftUploadData(
          UploadUIActive.IMAGE,
          hmSelectedItemsLanguage: _hmSelectedItemsLanguage,
          hmSelectedItemsGenre: _hmSelectedItemsGenre,
          mapOfMediaMetaData: hmMediaDraftData,
          localId: localId,
          description: filledDescription);

      NavigatorUtils.saveUploadDataToDraftAndNavigateToDraftUploadContentScreen(
          context, requestUploadDataToServer);
      Navigator.pop(context);
    }
  }

  Widget buildMediaListView() {
    return listOfMediaMetaData?.length == 0
        ? buildCameraGalleryUI()
        : Container(
            height: 200.0,
            child: ListView.builder(
                controller: _pageController,
                itemCount: listOfMediaMetaData?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        semanticContainer: true,
                        elevation: 2,
                        margin: EdgeInsets.all(5),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: buildSelectedMediaCard(index),
                      ),
                    ),
                  );
                }),
          );
  }

  Widget buildCameraGalleryUI() {
    return Container(
      height: 120.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildCommonUIForCameraGallery("assets/upload_camera.png", "Camera",
              onTap: () {
            pickerCamera(context);
          }),
          buildCommonUIForCameraGallery("assets/upload_album.png", "Gallery",
              onTap: () {
            _pickMedia(context, FileType.IMAGE);
          })
        ],
      ),
    );
  }

  Widget buildCommonUIForCameraGallery(String assetName, String title,
      {onTap}) {
    return InkWell(
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: ColorUtils.greyColor,
        radius: Radius.circular(16.0),
        padding: EdgeInsets.all(4),
        dashPattern: [9, 5],
        child: Container(
          width: 120.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  assetName,
                  scale: 2.5,
                ),
                SizedBox(
                  height: 12.0,
                ),
                CustomWidget.getText(title,
                    style: Theme.of(context).textTheme.subtitle),
              ],
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget buildMediaPageView() {
    return Container(
      height: 250.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: listOfMediaMetaData?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.transparent,
              width: 100,
              child: Card(
                elevation: 2.0,
                child: buildSelectedMediaCard(index),
              ),
            );
          }),
    );
  }

  Widget buildSelectedMediaCard(int index) {
    var _mediaMetaData = listOfMediaMetaData[index];

    return _buildMediaCard(_mediaMetaData);
  }

  Widget _buildMediaCard(FilterImageMeta _mediaMetaData) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: 200,
        child: Stack(
          children: <Widget>[
            InkWell(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  _mediaMetaData.mediaFileFiltered,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                _filterMediaFullScreen(context, _mediaMetaData);
              },
            ),
            getOverlappingTextWidget(_mediaMetaData.fileSizeInWords, Alignment.bottomLeft),
            getOverlappingIconWidget(Icons.clear, Alignment.topRight,
                onTap: () {
              _deleteMedia(_mediaMetaData);
            }),
            getOverlappingIconWidget(Icons.photo_filter, Alignment.bottomRight,
                onTap: () {
              _filterMediaSingle(context, _mediaMetaData);
            }),
          ],
        ),
      ),
    );
  }

  Widget getOverlappingIconWidget(IconData iconName, Alignment alignment,
      {onTap}) {
    return Container(
      padding: EdgeInsets.all(4.0),
      alignment: alignment,
      child: GestureDetector(
        child: Container(
            alignment: Alignment.center,
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
                color: ColorUtils.whiteColor.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorUtils.greyColor.withOpacity(0.8),
                )
              /*borderRadius: BorderRadius.circular(2.0)*/),
            child: Icon(
              iconName,
              color: ColorUtils.greyColor.withOpacity(0.8),
              size: 16.0,
            )),
        onTap: onTap,
      ),
    );
  }

  Widget getOverlappingTextWidget(String text, Alignment alignment,
      {onTap}) {
    return Container(
      padding: EdgeInsets.all(4.0),
      alignment: alignment,
      child: GestureDetector(
        child: Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 30.0,
            decoration: BoxDecoration(
                color: ColorUtils.whiteColor.withOpacity(0.0),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: ColorUtils.greyColor.withOpacity(0.0),
                )
              /*borderRadius: BorderRadius.circular(2.0)*/),
            child: CustomWidget.getText(text, style: TextStyle(color: ColorUtils.dialogBlueColor.withOpacity(0.8)))),
        onTap: onTap,
      ),
    );
  }

  void _deleteMedia(FilterImageMeta _mediaMetaData) {
    mapOfMediaMetaData.remove(_mediaMetaData.mediaFileName);
    _setListOfMedia();

    AppUtils.refreshCurrentState(this);
  }

  void handleFilteredMedia(List<FilterImageMeta> mediaFilesFiltered) {
    mediaFilesFiltered?.forEach((_mediaMetaData) {
      mapOfMediaMetaData[_mediaMetaData.mediaFileName] = _mediaMetaData;
    });

    _setListOfMedia();
  }
}
