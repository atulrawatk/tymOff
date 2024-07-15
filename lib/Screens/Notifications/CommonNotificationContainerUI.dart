import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Utils/Strings.dart';

class CommonNotificationContainerUI extends StatefulWidget {
  final double widthOfContainer;
  final double heightOfContainer;
  final String imageUrl;

  CommonNotificationContainerUI(this.imageUrl,{this.widthOfContainer = 95, this.heightOfContainer = 100});

  @override
  _CommonNotificationContainerUIState createState() => _CommonNotificationContainerUIState();
}

class _CommonNotificationContainerUIState extends State<CommonNotificationContainerUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.widthOfContainer,                                         // width of all container will change from here.
        height: widget.heightOfContainer,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) =>
              new Icon(Icons.error),
              fit: BoxFit.cover
          ),
        ),
    );
  }
}
