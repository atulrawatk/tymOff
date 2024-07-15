import 'package:flutter/material.dart';
import 'package:tymoff/Screens/Dialogs/VideoDialogContent.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

class VideoQuality extends StatefulWidget {
  @override
  _VideoQualityState createState() => _VideoQualityState();
}

class _VideoQualityState extends State<VideoQuality> {

  List<String> videoContentListItem = <String>[Constant.VALUE_360P,Constant.VALUE_480P,Constant.VALUE_720P,
  Constant.VALUE_1080P,Constant.VALUE_ORIGINAL,];

  Widget getUI(){
    return Column(
      children: <Widget>[
        VideoDialogContent(videoContentListItems: videoContentListItem),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          elevation: 1.0,
          titleSpacing: 0.0,
          leading: GestureDetector(
            child: Container(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 20.0,)),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          title: CustomWidget.getText(Strings.videoQuality,style: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0)),
        ),
        preferredSize: Size.fromHeight(48.0),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return Column(
                children: <Widget>[
                  SizedBox(height: 8.0,),
                  getUI(),
                ],
              );
            },childCount: 1),
          ),
        ],
      ),
    );
  }
}
