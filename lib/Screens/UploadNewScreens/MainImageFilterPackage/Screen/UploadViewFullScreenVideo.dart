import 'package:flutter/material.dart';
import 'package:tymoff/Screens/CardDetail/CommonDetailCardUI_Video_Upload.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterVideoMeta.dart';

class UploadViewFullScreenVideo extends StatefulWidget {

  FilterVideoMeta _mediaMetaData;

  UploadViewFullScreenVideo(this._mediaMetaData);

  @override
  _UploadViewFullScreenVideoState createState() => _UploadViewFullScreenVideoState();
}

class _UploadViewFullScreenVideoState extends State<UploadViewFullScreenVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Full screen Video", style: TextStyle(color: Colors.white70),),
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
      body: CommonDetailCardUI_Video_Upload(widget._mediaMetaData),
    );
  }


  void refreshState() {
    setState(() {});
  }

}
