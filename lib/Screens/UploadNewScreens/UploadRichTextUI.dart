import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/UploadNewScreens/SelectGenreOrLanguageUploadUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadAppBar.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadContentDescription.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:tymoff/Utils/ValidationUtil.dart';
import 'package:zefyr/zefyr.dart';

class UploadRichTextUI extends StatefulWidget {
  RequestDraftUploadData _draftData;
  bool _isEditModeActive = false;

  UploadRichTextUI(
      {RequestDraftUploadData draftData, bool isEditModeActive = false}) {
    this._draftData = draftData;
    this._isEditModeActive = isEditModeActive;
  }

  @override
  _UploadRichTextUIState createState() => _UploadRichTextUIState();
}

class _UploadRichTextUIState extends State<UploadRichTextUI> {
  TextEditingController _descriptionController = TextEditingController();

  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsGenre = HashMap();
  HashMap<int, MetaDataResponseDataCommon> _hmSelectedItemsLanguage = HashMap();

  final formKey = new GlobalKey<FormState>();
  String titleText = "";
  String errorText = "";

  final ZefyrController _zefyrStoryController = ZefyrController(NotusDocument());
  final FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _checkDraftDataAndPopulateInit();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _zefyrStoryController.dispose();
    super.dispose();
  }

  void _checkDraftDataAndPopulateInit() async {
    if (widget._draftData != null) {
      _hmSelectedItemsGenre.addAll(widget._draftData.hmSelectedItemsGenre);
      _hmSelectedItemsLanguage
          .addAll(widget._draftData.hmSelectedItemsLanguage);

      String richTextStory = (widget?._draftData?.richTextStory ?? "");
      _zefyrStoryController.replaceText(0, 0, richTextStory);
      AppUtils.refreshCurrentState(this);
    }
  }

  String getDescriptionText() => (widget?._draftData?.description ?? "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UploadAppBar().getAppBar(
          context: context,
          title: "Upload Stories",
          onTapNextButton: _onClickNextButton),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UploadContentDescription(
              descriptionValueText: widget?._draftData?.getDescription(),
              descriptionController: _descriptionController,
              descriptionHintText: Strings.descriptionHintTextForStoryUpload,
            ),
            SizedBox(
              height: 10.0,
            ),
            _uiPart(),
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
        ),
      ),
    );
  }

  void _onClickNextButton() async {

    String filledDescription = (_descriptionController?.text ?? "");
    var richTextStory = _zefyrStoryController.plainTextEditingValue.text;
    print("Munish Thakur -> richTextStory -> $richTextStory");

    if (richTextStory != null && richTextStory.length <= 0) {
      ToastUtils.show("Please add Rich text");
    } else if (!ValidationUtil.isGenreLanguageValidInUploadFlow(
        _hmSelectedItemsGenre, _hmSelectedItemsLanguage)) {
    } else {
      String localId = widget?._draftData?.getUID();

      RequestDraftUploadData requestUploadDataToServer = RequestDraftUploadData(
          UploadUIActive.RICH_TEXT,
          hmSelectedItemsLanguage: _hmSelectedItemsLanguage,
          hmSelectedItemsGenre: _hmSelectedItemsGenre,
          richTextStory: richTextStory,
          localId: localId,
          description: filledDescription);

      NavigatorUtils.saveUploadDataToDraftAndNavigateToDraftUploadContentScreen(
          context, requestUploadDataToServer);
      Navigator.pop(context);
    }
  }

  Widget _uiPart() {
    final form = ListView(
      children: <Widget>[
        Material(
          // color: Theme.of(context).secondaryHeaderColor,
          // elevation: 2.0,
          child: Container(color: Color(0xfF3F3F3), child: buildEditor()),
        ),
      ],
    );

    return Container(
      color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: ZefyrScaffold(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: form,
        ),
      ),
    );
  }

  Widget buildEditor() {
    final theme = new ZefyrThemeData(
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.white,
        toggleColor: ColorUtils.primaryColor.withOpacity(0.2),
        iconColor: Colors.grey.shade600,
        disabledIconColor: Colors.grey.shade300,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 10.0, right: 8.0,bottom: 10.0),
      child: Column(
        children: <Widget>[
          ZefyrTheme(
            data: theme,
            child: ZefyrField(
              height: 270.0,
              decoration: InputDecoration(
                hintText: 'Write your story here',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.subtitle,
                helperStyle: TextStyle(color: Colors.green),
                contentPadding: EdgeInsets.only(left: 2.0, right: 2.0),
                errorText: errorText == "" ? "" : errorText,
              ),
              controller: _zefyrStoryController,
              focusNode: _focusNode,
              autofocus: false,
              // imageDelegate: new CustomImageDelegate(),
              physics: ClampingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
