import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/CustomWidgets/CustomChipView.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class CommonChipView extends StatefulWidget {
  Map<int, MetaDataResponseDataCommon> hmSelectedItems = Map();
  SelectionUploadChipTypes selectionType;
  bool isDeleteActive = false;
  bool isShortUI = false;

  CommonChipView(this.hmSelectedItems, this.selectionType,
      {this.isDeleteActive = false, this.isShortUI = false});

  @override
  _CommonChipViewState createState() => _CommonChipViewState();
}

class _CommonChipViewState extends State<CommonChipView> {
  @override
  Widget build(BuildContext context) {
    return generateChips();
  }

  final int maxChipsToShow = 2;
  Widget generateChips() {
    List<Widget> chips = List();

    if(widget.isShortUI) {

      int index = 0;
      widget.hmSelectedItems?.forEach((key, chipData) {
        if(index == maxChipsToShow) {
          var widgetCountChip = CustomChipView(-1, getTitleLeftChipCount());
          chips.add(widgetCountChip);
        } else if (index < maxChipsToShow){
          var chipData = widget.hmSelectedItems[key];
          var chipWidget = genreButtonSelected(chipData);
          chips.add(chipWidget);
        }
        index++;
      });
    } else {
      widget.hmSelectedItems?.forEach((key, chipData) {
        var chipWidget = genreButtonSelected(chipData);
        chips.add(chipWidget);
      });
    }

    Widget widgetChips = Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: chips,
      ),
    );

    return widgetChips;
  }

  String getTitleLeftChipCount() {
    return "+ ${(widget.hmSelectedItems.length - maxChipsToShow)}";
  }

  Widget genreButtonSelected(MetaDataResponseDataCommon chipItem,
      {int index, Color color, onTap}) {
    if (widget.isDeleteActive) {
      return CustomChipView(chipItem.getUID(), getTitle(chipItem));
    } else {
      return CustomChipView(
        chipItem.getUID(),
        getTitle(chipItem),
        onChipRemove: onChipDeleteIcon,
      );
    }
  }

  void onChipDeleteIcon(int key) {
    widget.hmSelectedItems.remove(key);
    refreshScreen();
  }

  Container chipBehaviourContainer(
      MetaDataResponseDataCommon chipItem, int key) {
    return Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: <Widget>[
          CustomWidget.getText(getTitle(chipItem),
              style:
                  Theme.of(context).textTheme.title.copyWith(fontSize: 12.0)),
          SizedBox(
            width: 4.0,
          ),
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 16.0,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () {
              widget.hmSelectedItems.remove(key);
              refreshScreen();
            },
          )
        ],
      ),
    );
  }

  String getTitle(MetaDataResponseDataCommon chipItem) {
    String title = "";
    if (widget.selectionType == SelectionUploadChipTypes.GENRE) {
      title = chipItem.name;
    } else if (widget.selectionType == SelectionUploadChipTypes.LANGUAGE) {
      title = chipItem.nameUtf8;
    }

    return title;
  }

  void refreshScreen() {
    if (mounted) setState(() {});
  }
}
