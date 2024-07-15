

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class DottedContainer extends StatefulWidget {

  String text;
  String assetImage;
  GestureTapCallback onTap;

  DottedContainer(this.text, this.assetImage, {onTap}) {
    this.onTap = onTap;
  }

  @override
  _DottedContainerState createState() => _DottedContainerState();
}

class _DottedContainerState extends State<DottedContainer> {
  @override
  Widget build(BuildContext context) {
    return createDottedContainer();
  }

  Widget createDottedContainer() {
    return Center(
      child: InkWell(
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Color(0xfFF90A1B5),
          radius: Radius.circular(16.0),
          padding: EdgeInsets.all(4),
          dashPattern: [9, 5],
          child: Container(
            height: 60.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    widget.assetImage,
                    scale: 1.8,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomWidget.getText(widget.text,style: Theme.of(context).textTheme.subtitle),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          widget.onTap();
        },
      ),
    );
  }
}
