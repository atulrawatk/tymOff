import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

class UploadContentDescription extends StatefulWidget {

  TextEditingController descriptionController;
  String descriptionHintText;
  String descriptionValueText;

  UploadContentDescription({this.descriptionValueText, this.descriptionHintText, this.descriptionController}) {
    this.descriptionController = descriptionController;

    if(descriptionHintText == null) {
      descriptionHintText = "Say something";
    }
    if(descriptionValueText != null) {
      descriptionController?.text = descriptionValueText;
    }
  }

  @override
  _UploadContentDescriptionState createState() => _UploadContentDescriptionState();
}

class _UploadContentDescriptionState extends State<UploadContentDescription> {

  String _imageFileUrl;

  @override
  void didChangeDependencies() async {
    handleLoginData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    widget.descriptionController.dispose();
    super.dispose();
  }

  void handleLoginData() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (mounted) {
        setState(() {
          if (loginResponse != null) {
            _imageFileUrl = loginResponse?.data?.picUrl;
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Container(
                color: Colors.transparent,
                alignment: Alignment.topCenter,
                child: buildProfileWidget()),
            flex: 0,
          ),
          SizedBox(width: 4.0,),
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    controller: widget.descriptionController,
                    maxLengthEnforced: false,
                    decoration: new InputDecoration.collapsed(
                        hintText: widget.descriptionHintText,
                        hintStyle:Theme.of(context).textTheme.subtitle,
                    ),
                    onChanged: (String value) => setState(() {
                      /*widget.filledDescription = value;
                      print("Description -> ${widget.filledDescription}");*/
                    }),
                  ),
                ),
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget buildProfileWidget() {
    return _imageFileUrl != null && _imageFileUrl.length > 0
            ? Container(
              alignment: Alignment.topCenter,
                width: 32.0,
                height: 32.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.3)),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(_imageFileUrl)
                    ),
                  ),
                ),
    ) :  Container(
            alignment: Alignment.topCenter,
              height: 32.0,
              width: 32.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.3)),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                    image : AssetImage(
                      "assets/dummy_user_profile.png",)
                    // scale: 1.5,
                  ),
                ),
              )


        );
  }
}
