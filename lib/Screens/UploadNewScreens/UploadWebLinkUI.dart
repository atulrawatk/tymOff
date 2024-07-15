import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/DescriptionAlgoApi.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/UploadNewScreens/SelectGenreOrLanguageUploadUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadAppBar.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadContentDescription.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:tymoff/Utils/ValidationUtil.dart';

class UploadWebLinkUI extends StatefulWidget {
  RequestDraftUploadData _draftData;
  bool _isEditModeActive = false;

  UploadWebLinkUI(
      {RequestDraftUploadData draftData, bool isEditModeActive = false}) {
    this._draftData = draftData;
    this._isEditModeActive = isEditModeActive;
  }

  @override
  _UploadWebLinkUIState createState() => _UploadWebLinkUIState();
}

class _UploadWebLinkUIState extends State<UploadWebLinkUI> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _urlTextController = TextEditingController();

  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsGenre = HashMap();
  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsLanguage = HashMap();

  String urlText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _urlTextController.text = ("");
    _checkDraftDataAndPopulateInit();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _urlTextController.dispose();
    super.dispose();
  }

  void _checkDraftDataAndPopulateInit() async {
    if (widget._draftData != null) {
      _urlTextController.text = (widget?._draftData?.url ?? "");

      _hmSelectedItemsGenre.addAll(widget._draftData.hmSelectedItemsGenre);
      _hmSelectedItemsLanguage
          .addAll(widget._draftData.hmSelectedItemsLanguage);

      hitAndGetUrlDescription(context, _urlTextController.text);

      AppUtils.refreshCurrentState(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UploadAppBar().getAppBar(
          context: context,
          title: "Upload WebLink",
          onTapNextButton: _onClickNextButton),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UploadContentDescription(
              descriptionValueText: widget?._draftData?.getDescription(),
              descriptionController: _descriptionController,
              descriptionHintText: Strings.descriptionHintTextForWebLinkUpload,
            ),
            SizedBox(
              height: 10.0,
            ),
            enterALink(),
            //pasteUrlCardUI(),
            SizedBox(
              height: 10.0,
            ),
            descriptionAlgoApi != null ? buildWebCard() : Container(),
            buildBottomWidgetUI()
          ],
        ),
      ),
    );
  }

  void _onClickNextButton() async {
    String filledDescription = (_descriptionController?.text ?? "");
    String url = (_urlTextController?.text ?? "");

    if (url != null && url.length <= 0) {
      ToastUtils.show("Please insert URL to upload");
    } else if (!ValidationUtil.isGenreLanguageValidInUploadFlow(
        _hmSelectedItemsGenre, _hmSelectedItemsLanguage)) {
    } else {
      String localId = widget?._draftData?.getUID();

      RequestDraftUploadData requestUploadDataToServer = RequestDraftUploadData(
          UploadUIActive.WEB_LINK,
          hmSelectedItemsLanguage: _hmSelectedItemsLanguage,
          hmSelectedItemsGenre: _hmSelectedItemsGenre,
          url: url,
          localId: localId,
          description: filledDescription);

      NavigatorUtils.saveUploadDataToDraftAndNavigateToDraftUploadContentScreen(
          context, requestUploadDataToServer);
      Navigator.pop(context);
    }
  }

  Widget buildBottomWidgetUI() {
    return Column(
      children: <Widget>[
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        SelectGenreOrLanguageUploadUI(
          SelectionUploadChipTypes.GENRE,
          hmSelectedItems: _hmSelectedItemsGenre,
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        SelectGenreOrLanguageUploadUI(SelectionUploadChipTypes.LANGUAGE,
            hmSelectedItems: _hmSelectedItemsLanguage),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  Widget buildWebCard() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              //color: Colors.grey[300],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: ColorUtils.greyColor.withOpacity(0.1))),
          margin: EdgeInsets.all(10.0),
          //padding: EdgeInsets.only(left:8.0,top: 10.0,right: 8.0,bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 120.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorUtils.greyColor.withOpacity(0.4),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: setWebLinkImage(),
                ),
                flex: 1,
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: (descriptionAlgoApi
                                            ?.result?.metadata?.title ==
                                        "")
                                    ? Container()
                                    : CustomWidget.getText(
                                        descriptionAlgoApi
                                                ?.result?.metadata?.title ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.title),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: (descriptionAlgoApi?.result?.metadata?.url == "")
                            ? Container()
                            : CustomWidget.getText(
                                descriptionAlgoApi?.result?.metadata?.url ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: ColorUtils.greyColor,
                                        fontSize: 11.0)),
                      )
                    ],
                  ),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              resetWebLink();
            },
            child: Container(
              padding: EdgeInsets.only(right: 2.0),
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 10.0,
                backgroundColor: ColorUtils.greyColor.withOpacity(0.4),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void resetWebLink() {

    _urlTextController.text = "";
    urlText = "";
    descriptionAlgoApi = null;
    AppUtils.refreshCurrentState(this);
  }

  Image setWebLinkImage() {
    return (descriptionAlgoApi?.result?.images?.length ?? 0) > 0
        ? Image.network(
            descriptionAlgoApi?.result?.images[0],
            scale: 4.0,
            fit: BoxFit.contain,
          )
        : ((descriptionAlgoApi?.result?.metadata?.thumbnail?.length ?? 0) > 0)
            ? Image.network(
                descriptionAlgoApi?.result?.metadata?.thumbnail,
                scale: 4.0,
                fit: BoxFit.fill,
              )
            : Image.asset(
                "assets/article_link_icon.png",
                scale: 1.5,
              );
  }

  Widget enterALink() {
    return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/article_link_icon.png",
                    color: ColorUtils.greyColor,
                    scale: 3.5,
                  )),
              flex: 0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                controller: _urlTextController,
                decoration: new InputDecoration.collapsed(
                    hintText: "Enter a link",
                    hintStyle: Theme.of(context).textTheme.subtitle),
                onChanged: (String value) => setState(() {
                  urlText = value;
                  hitAndGetUrlDescription(context, value);
                }),
              ),
              flex: 1,
            )
          ],
        ));
  }

  /* Widget pasteUrlCardUI(){
    return  Material(
      child: Container(
        // color: Theme.of(context).secondaryHeaderColor,
        margin: EdgeInsets.all(10.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorUtils.greyColor.withOpacity(0.1),
            shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextField(
              controller: _urlTextController,
              decoration: new InputDecoration.collapsed(hintText: "Type or paste URL here.",hintStyle:Theme.of(context).textTheme.subtitle),
              onChanged: (String value) => setState(() {
                urlText = value;
                hitAndGetUrlDescription(context, value);
              }),
            ),
          ),
        ),
      ),
    );
  }*/

  var _cancelToken = CancelToken();
  DescriptionAlgoApi descriptionAlgoApi;

  hitAndGetUrlDescription(BuildContext context, String _urlData) async {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
      _cancelToken = CancelToken();
    }

    bool _isValidUrl = ValidationUtil.isValidUrl(_urlData);

    if (!_isValidUrl) {
      setState(() {
        descriptionAlgoApi = null;
      });
      return;
    }

    var response = await ApiHandler.postDescriptionAlgoApi(context, _urlData,
        cancelToken: _cancelToken);
    if (response.result != null) {
      setState(() {
        this.descriptionAlgoApi = response;

        print("Munish Thakur -> WEB URL response -> \n$descriptionAlgoApi");
      });
      print(
          "Description slgo api hit successfully -> ${descriptionAlgoApi.result}");
    }
  }
}
