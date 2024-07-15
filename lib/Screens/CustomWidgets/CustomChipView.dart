import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class CustomChipView extends StatefulWidget {
  final int chipKey;
  final String title;
  final Color color;
  final Function onChipRemove;

  CustomChipView(this.chipKey, this.title, {this.onChipRemove, this.color});

  @override
  _CustomChipViewState createState() => _CustomChipViewState();
}

class _CustomChipViewState extends State<CustomChipView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(1.0),

      child: Container(
        height: 26.0,
        padding: EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color != null ? widget.color : ColorUtils.primaryColor.withOpacity(0.4),
              // color: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.only(left : 8.0,),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: widget.onChipRemove != null ? const EdgeInsets.all(0.0) : const EdgeInsets.only(right: 8.0),
                    child: CustomWidget.getText(widget.title,
                        style: Theme.of(context).textTheme.title.copyWith(fontSize: 12.0,color: ColorUtils.whiteColor)),
                  ),
                  widget.onChipRemove != null ? InkWell(
                    //padding: EdgeInsets.all(0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                      child: Icon(
                        Icons.clear,
                        size: 14.0,
                        color: ColorUtils.whiteColor,
                      ),
                    ),
                    onTap: () {
                      widget.onChipRemove(widget.chipKey);
                    },
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
      //child: chipBehaviourContainer(chipItem, key),
      /*child:  Chip(
              padding: EdgeInsets.all(2.0),
              labelStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 12.0,),
              label: CustomWidget.getText(getTitle(chipItem)),
              deleteIcon: Icon(
                Icons.clear,
                size: 16.0,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              backgroundColor: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
              deleteIconColor: Colors.grey,
              onDeleted: () {
                widget.hmSelectedItems.remove(key);
                refreshScreen();
                //_setSelectionGenre(genreItem, isDeleteOnly: true);
              },
        ),*/
    );
  }
}
