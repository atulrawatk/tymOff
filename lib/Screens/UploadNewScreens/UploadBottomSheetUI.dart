import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadImageUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadRichTextUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadVideoUI.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadWebLinkUI.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

import 'UploadUtils/DottedContainer.dart';

class UploadBottomSheetUI extends StatefulWidget {
  @override
  _UploadBottomSheetUIState createState() => _UploadBottomSheetUIState();
}

class _UploadBottomSheetUIState extends State<UploadBottomSheetUI> {
  String fileName;
  String path;
  Map<String, String> paths;
  String extension;
  bool loadingPath = false;
  FileType _pickingType;

  void checkType(FileType filePickingType) {
    switch (filePickingType) {
      case FileType.IMAGE:
        _openImageFileExplorer(filePickingType);
        break;
      case FileType.VIDEO:
        _openImageFileExplorer(filePickingType);
        break;

      case FileType.ANY:
        //_openImageFileExplorer();
        break;
      case FileType.AUDIO:
        //_openImageFileExplorer();
        break;
      case FileType.CUSTOM:
        // _openImageFileExplorer();
        break;
    }
  }

  void _openImageFileExplorer(FileType filePickingType) async {
    if (filePickingType != null) {
      setState(() => loadingPath = true);
      try {
        path = null;
        paths = await FilePicker.getMultiFilePath(
            type: filePickingType, fileExtension: extension);
        print("ankit file picker ->File open occured.");
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      setState(() {
        loadingPath = false;
        fileName = path != null
            ? path.split('/').last
            : paths != null ? paths.keys.toString() : '...';
      });
      if (!mounted) return;
    } else {
      print("ankit file picker -> error has occured.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(32.0),
              topRight: const Radius.circular(32.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: CustomWidget.getText("Add media",
                style: Theme.of(context).textTheme.title),
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            thickness: 1.5,
            color: ColorUtils.dividerColor,
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 100.0,
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 12.0),
            child: Row(
              children: <Widget>[
                buildBottomActionOption(
                    context, Strings.images, "upload_camera_icon", UploadImageUI()),
                SizedBox(width: 10.0),
                buildBottomActionOption(
                    context, Strings.video, "upload_video_icon", UploadVideoUI()),
                SizedBox(width: 10.0),
                buildBottomActionOption(
                    context, Strings.stories, "upload_richtext_icon", UploadRichTextUI()),
                SizedBox(width: 10.0),
                buildBottomActionOption(
                    context, Strings.webLink, "upload_weblink_icon", UploadWebLinkUI()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomActionOption(BuildContext context, String title,
      String pngAsset, Widget widgetToNavigate) {
    return Expanded(
      child: DottedContainer(title, "assets/$pngAsset.png", onTap: () {
        Navigator.pop(context);
        NavigatorUtils.navigateToWidget(context, widgetToNavigate);
      }),
    );
  }
}
