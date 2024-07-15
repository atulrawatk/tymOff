import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class MultiFilePicker extends StatefulWidget {
  @override
  _MultiFilePickerState createState() => new _MultiFilePickerState();
}

class _MultiFilePickerState extends State<MultiFilePicker> {
  List<File> imageFiles;

  Future getImage(context) async {
    imageFiles = await FilePicker.getMultiFile(type: FileType.IMAGE);
    refreshState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select Image Files'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: new Container(
              child: isImageFilesSelected()
                  ? Center(
                      child: new Text('Image Selected: ${imageFiles.length}'),
                    )
                  : Center(
                      child: new Text('No image selected.'),
                    ),
            ),
          ),
          RaisedButton(
              child: Text("Filter It.."),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                //NavigatorUtils.moveToImageFilterScreen(context, imageFiles);
              }),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  bool isImageFilesSelected() {
    return (imageFiles != null) && (imageFiles.length > 0);
  }

  void refreshState() {
    setState(() {});
  }
}
