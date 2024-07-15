import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';



class ReportDialogContent extends StatefulWidget {
  ReportDialogContent({
    Key key,
    this.reportContentListItems,
    this.reportContentChange,
  }): super(key: key);

  final List<MetaDataResponseDataCommon> reportContentListItems;
  Function reportContentChange;

  @override
  _ReportDialogContentState createState() => new _ReportDialogContentState();
}

class _ReportDialogContentState extends State<ReportDialogContent> {
  int _selectedIndex;

  @override
  void initState(){
    super.initState();
  }

  _getContent(){
    if ((widget?.reportContentListItems?.length ?? 0) == 0){
      return new Container();
    }

    return new Column(
        children: new List<Container>.generate((widget?.reportContentListItems?.length ?? 0),
                (int index){
              return Container(
                color: Colors.transparent,
                alignment: Alignment.topLeft,
                child: _radioButtonTemp(context,index),
              );
            }
        )
    );
  }

  Widget _radioButtonTemp(BuildContext context, int index) {
    return RadioListTile(
            value: index,
            groupValue: _selectedIndex,
            activeColor: ColorUtils.primaryColor,
            isThreeLine: false,
            onChanged: (value) {
              setState(() {
                _selectedIndex = value;
                widget.reportContentChange(widget.reportContentListItems[index]);
                print("value selected -> $_selectedIndex");
              });
          },
            title: CustomWidget.getText(widget.reportContentListItems[index].name,style: Theme.of(context).textTheme.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}