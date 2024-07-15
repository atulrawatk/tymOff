
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class VideoDialogContent extends StatefulWidget {
  VideoDialogContent({
    Key key,
    this.videoContentListItems,
  }): super(key: key);

  final List<String> videoContentListItems;

  @override
  _VideoDialogContentState createState() => new _VideoDialogContentState();
}

class _VideoDialogContentState extends State<VideoDialogContent> {
  int _selectedIndex;

  @override
  void initState(){
    super.initState();
  }

  _getContent(){
    if ((widget?.videoContentListItems?.length ?? 0) == 0){
      return new Container();
    }

    return new Column(
        children: new List<Column>.generate( (widget?.videoContentListItems?.length ?? 0),
                (int index){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _radioButtonTemp(context,widget.videoContentListItems,index),
                ],
              );
            }
        )
    );
  }

  Widget _radioButtonTemp(BuildContext context,List<String> videoContentListItems, int index) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomWidget.getText(videoContentListItems[index],style: Theme.of(context).textTheme.title),
          Radio(
            value: index,
            groupValue: _selectedIndex,
            activeColor: ColorUtils.primaryColor,
            onChanged: (value) {
              setState(() {
                _selectedIndex = value;
                print("value selected -> $_selectedIndex");
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}