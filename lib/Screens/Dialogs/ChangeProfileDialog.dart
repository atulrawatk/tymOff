import 'package:flutter/material.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class ChangeProfileDialog extends StatefulWidget {

  String imageFileUrl;
  Function removeProfilePhoto;
  Function pickProfilePhotoFromGallery;
  Function pickProfilePhotoFromCamera;

  ChangeProfileDialog(this.imageFileUrl, {this.removeProfilePhoto, this.pickProfilePhotoFromGallery, this.pickProfilePhotoFromCamera});


  @override
  _ChangeProfileDialogState createState() => _ChangeProfileDialogState();
}

class _ChangeProfileDialogState extends State<ChangeProfileDialog> {


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomWidget.getText("Profile photo",style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.start),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                showRemoveWidget() ? buildInnerDialogUI("assets/delete.png", "Remove\nPhoto",onTap: widget.removeProfilePhoto) : Container(),
                showRemoveWidget()? SizedBox(width: 40.0,) : Container() ,
                buildInnerDialogUI("assets/upload_camera.png", "Camera",onTap: widget.pickProfilePhotoFromCamera),
                SizedBox(width: 40.0,),
                buildInnerDialogUI("assets/upload_album.png", "Gallery",onTap: widget.pickProfilePhotoFromGallery),
              ],
            )
          ],
        ),
    );
  }

  Widget buildInnerDialogUI(String assetName, String text, {onTap}){
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.asset(assetName,scale: 5.0,color: Theme.of(context).iconTheme.color,),
          SizedBox(height: 10.0,),
          CustomWidget.getText(text,textAlign: TextAlign.center,style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0)),
        ],
      ),
      onTap: onTap,
    );
  }

  bool showRemoveWidget() => (widget?.imageFileUrl?.length ?? 0) > 0;
}
