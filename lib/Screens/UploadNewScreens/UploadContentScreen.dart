import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/UploadContentRequest.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Network/Response/UploadContentResponse.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadImageUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadRichTextUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadVideoUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadWebLinkUI.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/SharedPref/SPModels/SyncUploadContentRequestToServer.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilDraftUpload.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilServerSyncUpload.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:tymoff/main.dart';

import 'CommonChipView.dart';
import 'UploadBottomSheetUI.dart';

class UploadContentScreen extends StatefulWidget {
  @override
  _UploadContentScreenState createState() =>
      _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  DraftUploadContentRequestToServer _draftUploadContentRequestToServer;
  SyncUploadContentRequestToServer _syncUploadContentRequestToServer;
  List<RequestDraftUploadData> _draftContentItems;
  List<RequestUploadDataToServer> _syncContentItems;
  Map<String, RequestUploadDataToServer> _syncContentItemsMap = Map();

  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _observeContentUploading();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getDataFromSPAndPopulateUI();
  }

  void _observeContentUploading() {
    _progressSubscription = appUploader.progress.listen((progress) {
      int progressResult = progress.progress;
      //if((progressResult > 20 && progressResult <25) || (progressResult > 40 && progressResult <55) || (progressResult > 70 || progressResult <80) || (progressResult > 90 && progressResult <= 100))
      print(
          "Munish Thakur -> _observeContentUploading() -> progress: ${progress.progress} , tag: ${progress.tag}");

      _updateProgressOfSyncContent(progress);
    });

    _resultSubscription = appUploader.result.listen((result) {
      String taskId = result.taskId;

      print(
          "Munish Thakur -> _observeContentUploading() -> id: $taskId, status: ${result.status}, "
          "response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      // TEMP CODE - MUNISH THAKUR

      String responseOfApi = result.response.toString();

      Map<String, dynamic> user = json.decode(responseOfApi);

      UploadContentResponse objectResponse =
          UploadContentResponse.fromJson(user);

      if (objectResponse.statusCode == 200 && objectResponse.success) {
        SharedPrefUtilServerSyncUpload
                .removeServerSyncUploadContentInQueueByTaskId(taskId)
            .then((_syncLeftSevedContent) {
          _getDataFromSPAndPopulateUI();
        });
        //EventBusUtils.eventUploadComplete(null);
      } else {
        ToastUtils.show(objectResponse?.message ?? "Failed to upload content");
      }
    });
  }

  void _updateProgressOfSyncContent(UploadTaskProgress progress) {
    try {
      String tag = progress.taskId;
      int uploadProgress = progress.progress;

      var syncDataInfo = _syncContentItemsMap[tag];
      if (syncDataInfo != null) {
        syncDataInfo.totalProgressOfUploadFiles = uploadProgress;
      }

      _syncContentItemsMap[tag] = syncDataInfo;

      AppUtils.refreshCurrentState(this);
    } catch (e) {
      print("Munish Thakur -> _updateProgressOfSyncContent() -> $e");
    }
  }

  void _getDataFromSPAndPopulateUI() {
    SharedPrefUtilDraftUpload.getDraftUploadContent()
        .then((_draftUploadContentRequestToServer) {
      this._draftUploadContentRequestToServer =
          _draftUploadContentRequestToServer;
      _setDraftContentItemsList();
      AppUtils.refreshCurrentState(this);
    });

    SharedPrefUtilServerSyncUpload.getServerSyncUploadContent()
        .then((_syncUploadContentRequestToServer) {
      this._syncUploadContentRequestToServer =
          _syncUploadContentRequestToServer;
      _setSyncContentItemsList();
      _setSyncProgressItemsMap();
      AppUtils.refreshCurrentState(this);
    });
  }

  void _setDraftContentItemsList() {
    _draftContentItems =
        _draftUploadContentRequestToServer?.data?.values?.toList() ?? List();
  }

  void _setSyncContentItemsList() {
    _syncContentItems =
        _syncUploadContentRequestToServer?.data?.values?.toList() ?? List();
  }

  void _setSyncProgressItemsMap() {
    _syncContentItemsMap.clear();
    _syncContentItems.forEach((_syncItem) {
      _syncContentItemsMap[_syncItem.taskId] = _syncItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 1.0,
          titleSpacing: 10.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  ToastUtils.show("Upload All content clicked");
                  _uploadAllContents();
                }),
          ],
          title: CustomWidget.getText("Upload Content",
              style:
                  Theme.of(context).textTheme.title.copyWith(fontSize: 18.0)),
        ),
        preferredSize: Size.fromHeight(48.0),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: ColorUtils.primaryColor,
          onPressed: () {
            moreOptionModalBottomSheet(context);
          }),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                child: _buildUploadItemsHeading("Draft", isDraftAvailable()),
              );
            }, childCount: 1),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                child: buildDraftContentCardUI(_draftContentItems[index]),
              );
            }, childCount: _draftContentItems?.length ?? 0),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                child: _buildUploadItemsHeading(
                    "Uploading to Server", isSyncAvailable()),
              );
            }, childCount: 1),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                child: buildSyncContentCardUI(_syncContentItems[index]),
              );
            }, childCount: _syncContentItems?.length ?? 0),
          )
        ],
      ),
    );
  }

  Widget _buildUploadItemsHeading(String title, bool isToShow) {
    return isToShow
        ? Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: CustomWidget.getText(title,
                style:
                    Theme.of(context).textTheme.title.copyWith(fontSize: 14.0)),
          )
        : Container();
  }

  Widget buildDraftContentCardUI(RequestDraftUploadData draftData) {
    return GestureDetector(
        onTap: () {
          _eventEditContent(draftData);
        },
        child: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 16.0, right: 4.0, left: 4.0),
              child: buildDraftCard(draftData)),
          Positioned(
            right: -10.0,
            top: 0.0,
            child: IconButton(
              icon: Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                      color: ColorUtils.whiteColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorUtils.greyColor.withOpacity(0.8),
                      )),
                  child: Icon(
                    Icons.clear,
                    color: ColorUtils.greyColor.withOpacity(0.8),
                    size: 16.0,
                  )),
              onPressed: () {
                _deleteDraftContent(draftData);
              },
            ),
          ),
        ]));
  }

  Widget buildDraftCard(RequestDraftUploadData draftData) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isMediaAvailable(draftData)
                ? _getMediaImageWidget(draftData)
                : Container(),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (draftData.description != null &&
                            draftData.description.length > 0)
                        ? Flexible(
                            flex: 0,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: CustomWidget.getText(
                                  draftData?.description ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 14.0),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        : Container(),
                    Flexible(
                      flex: 0,
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidget.getText("Genre: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 12.0))),
                          CommonChipView(
                            draftData.hmSelectedItemsGenre,
                            SelectionUploadChipTypes.GENRE,
                            isDeleteActive: true,
                            isShortUI: true,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidget.getText("Language: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 12.0))),
                          CommonChipView(
                            draftData.hmSelectedItemsLanguage,
                            SelectionUploadChipTypes.LANGUAGE,
                            isDeleteActive: true,
                            isShortUI: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMediaImageWidget(RequestDraftUploadData draftData) {
    var listOfMediaData = draftData.mapOfMediaMetaData.values.toList();
    RequestUploadDataFileInfo requestUploadDataFileInfo = listOfMediaData[0];
    var mediaFile = File(requestUploadDataFileInfo.mediaFilePath);

    var lengthOfMedia = draftData.mapOfMediaMetaData.length;
    var isVideo = _isVideoContent(draftData);

    Uint8List thumbnailUint8List;
    if (isVideo) {
      thumbnailUint8List = requestUploadDataFileInfo.getThumbnail();
    }

    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Container(
            height: 110.0,
            width: 110.0,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: isVideo && (thumbnailUint8List != null)
                        ? Image.memory(
                            thumbnailUint8List,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            mediaFile,
                            fit: BoxFit.cover,
                          ),
                    /*child: Image.file(
                      mediaFile,
                      fit: BoxFit.cover,
                    ),*/
                  ),
                ),
                (lengthOfMedia > 1)
                    ? /*Align(
                        alignment: Alignment.topRight,
                        child: CustomChipView(
                            -1, _getTitleDraftContentType(draftData)))*/
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 18.0,
                          width: 18.0,
                          margin: EdgeInsets.only(bottom: 3.0, left: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          child: Image.asset(
                            "assets/album.png",
                            scale: 2.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(),
                lengthOfMedia > 1
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.rectangle,
                        ),
                        child: Center(
                          child: CustomWidget.getText("+${lengthOfMedia - 1}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: ColorUtils.whiteColor)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isMediaAvailable(RequestDraftUploadData draftData) =>
      (draftData?.mapOfMediaMetaData?.length ?? 0) > 0;

  Widget _syncProgressIndicator(RequestUploadDataToServer syncData) {
    Widget widgetSyncProgress = Container();
    try {
      var tag = syncData?.taskId ?? "";
      var syncDataInfo = _syncContentItemsMap[tag];
      if (syncDataInfo != null) {
        widgetSyncProgress = LinearProgressIndicator(
          value: (syncDataInfo?.totalProgressOfUploadFiles?.toDouble() ?? 0.0) /
              100,
          backgroundColor: ColorUtils.greyColor.withOpacity(0.5),
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorUtils.primaryColor.withOpacity(0.7),
          ),
        );
      }
    } catch (e) {
      print("Munish Thakur -> _syncProgressIndicator() -> $e");
    }
    return widgetSyncProgress;
  }

  Widget buildSyncContentCardUI(RequestUploadDataToServer syncData) {
    var draftData = syncData.requestDraftUploadData;
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _syncProgressIndicator(syncData),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isMediaAvailable(draftData)
                    ? _getMediaImageWidget(draftData)
                    : Container(),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex: 0,
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomWidget.getText("Genre: ")),
                              CommonChipView(
                                draftData.hmSelectedItemsGenre,
                                SelectionUploadChipTypes.GENRE,
                                isDeleteActive: true,
                                isShortUI: true,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 0,
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomWidget.getText("Language: ")),
                              CommonChipView(
                                draftData.hmSelectedItemsLanguage,
                                SelectionUploadChipTypes.LANGUAGE,
                                isDeleteActive: true,
                                isShortUI: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                _addActionButtons(syncData),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isDraftAvailable() => (_draftContentItems?.length ?? 0) > 0;

  bool isSyncAvailable() => (_syncContentItems?.length ?? 0) > 0;

  void _deleteDraftContent(RequestDraftUploadData draftData) async {
    await SharedPrefUtilDraftUpload.removeDraftUploadContentInQueue(draftData);
    _getDataFromSPAndPopulateUI();
  }

  String getDraftFileCount(RequestDraftUploadData draftData) {
    return draftData?.mapOfMediaMetaData?.length?.toString() ?? "";
  }

  String getGenreCount(RequestDraftUploadData draftData) {
    return draftData?.hmSelectedItemsGenre?.length?.toString() ?? "";
  }

  String getLanguageCount(RequestDraftUploadData draftData) {
    return draftData?.hmSelectedItemsLanguage?.length?.toString() ?? "";
  }

  Widget getChipViewForGenreAndLanguage(String titleText) {
    return Row(
      children: <Widget>[
        CustomWidget.getText(titleText),
        SizedBox(
          width: 8.0,
        ),
        //CommonChipView()
      ],
    );
  }

  void moreOptionModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return UploadBottomSheetUI();
        });
  }

  void _eventEditContent(RequestDraftUploadData draftData) {
    if (draftData != null) {
      if (draftData.contentType == UploadUIActive.IMAGE) {
        NavigatorUtils.navigateToWidget(
            context,
            UploadImageUI(
              draftData: draftData,
              isEditModeActive: true,
            ));
      } else if (draftData.contentType == UploadUIActive.VIDEO) {
        NavigatorUtils.navigateToWidget(
            context,
            UploadVideoUI(
              draftData: draftData,
              isEditModeActive: true,
            ));
      } else if (draftData.contentType == UploadUIActive.WEB_LINK) {
        NavigatorUtils.navigateToWidget(
            context,
            UploadWebLinkUI(
              draftData: draftData,
              isEditModeActive: true,
            ));
      } else if (draftData.contentType == UploadUIActive.RICH_TEXT) {
        NavigatorUtils.navigateToWidget(
            context,
            UploadRichTextUI(
              draftData: draftData,
              isEditModeActive: true,
            ));
      }
    }
  }

  void _startContentUploading(RequestUploadDataToServer syncData) async {
    await ApiHandler.uploadContentNew(syncData);
    _getDataFromSPAndPopulateUI();
  }

  void _stopUploadConfirmation(RequestUploadDataToServer syncData) {}

  void _uploadAllContents() async {
    UploadContentRequest uploadContentRequest =
        await getToUploadContentObject();

    print("Json To Upload -> \n${uploadContentRequest.toJson()}");

    var uploadResponse =
        await ApiHandler.createContent(context, uploadContentRequest);
    if (uploadResponse != null && uploadResponse.success == true) {
      print("Upload Content Api hit successfully");

      await SharedPrefUtilServerSyncUpload.updateServerSyncData(uploadResponse);
      _getDataFromSPAndPopulateUI();
      startUploadAllContent();
    } else {
      print("Error in Upload Content hit api.");
      ToastUtils.show("Error in content upload, Please try later");
    }
  }

  Future<UploadContentRequest> getToUploadContentObject() async {
    UploadContentRequest requestTemp = new UploadContentRequest();
    requestTemp.dataList = new List<RequestUploadDataTemp>();

    DraftUploadContentRequestToServer draftUploadContentRequestToServer =
        await SharedPrefUtilDraftUpload.getDraftUploadContent();

    if (draftUploadContentRequestToServer != null) {
      List<RequestUploadDataTemp> listOfContentToUpload =
          draftUploadContentRequestToServer.data.values.map((_draftData) {
        RequestUploadDataTemp requestUploadDataTemp =
            new RequestUploadDataTemp();
        requestUploadDataTemp.localId = _draftData.localId;

        requestUploadDataTemp.typeId = getContentTypeId(_draftData);

        requestUploadDataTemp.languageId =
            getListOfIds(_draftData.hmSelectedItemsLanguage);
        requestUploadDataTemp.catId =
            getListOfIds(_draftData.hmSelectedItemsGenre);
        //requestUploadDataTemp.title = _draftData.title;
        //requestUploadDataTemp.description = _draftData.description;
        requestUploadDataTemp.title = "";
        requestUploadDataTemp.description = _draftData.description;
        requestUploadDataTemp.url = _draftData.url;

        return requestUploadDataTemp;
      }).toList();

      requestTemp.dataList.addAll(listOfContentToUpload);
    }

    return requestTemp;
  }

  List<int> getListOfIds(Map<int, MetaDataResponseDataCommon> hmItems) {
    if (hmItems != null) {
      return hmItems.values.map((data) => data.id).toList();
    }

    return List();
  }

  bool _isVideoContent(RequestDraftUploadData _draftData) {
    if (_draftData.contentType == UploadUIActive.VIDEO) return true;

    return false;
  }

  int getContentTypeId(RequestDraftUploadData _draftData) {
    int typeId = -1;
    if (_draftData.contentType == UploadUIActive.IMAGE)
      typeId = ContentTypeUtils.APP_CONTENT_TYPE_IMAGE;
    else if (_draftData.contentType == UploadUIActive.VIDEO)
      typeId = ContentTypeUtils.APP_CONTENT_TYPE_VIDEO;
    else if (_draftData.contentType == UploadUIActive.RICH_TEXT)
      typeId = ContentTypeUtils.APP_CONTENT_TYPE_TEXT;
    else if (_draftData.contentType == UploadUIActive.WEB_LINK)
      typeId = ContentTypeUtils.APP_CONTENT_TYPE_ARTICLE;

    return typeId;
  }

  Widget _addActionButtons(RequestUploadDataToServer syncData) {
    return Column(
      children: <Widget>[
        Expanded(
          child: IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              _startContentUploading(syncData);
            },
          ),
          flex: 0,
        ),
        Expanded(
          child: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _stopUploadConfirmation(syncData);
            },
          ),
          flex: 0,
        ),
      ],
    );
  }

  void startUploadAllContent() {
    SharedPrefUtilServerSyncUpload.getServerSyncUploadContent()
        .then((_syncUploadContentRequestToServer) {
      this._syncUploadContentRequestToServer =
          _syncUploadContentRequestToServer;
      _syncUploadContentRequestToServer?.data?.values
          ?.toList()
          ?.forEach((_toUploadData) {
        _startContentUploading(_toUploadData);
      });
    });
  }
}
