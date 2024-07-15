import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tymoff/DynamicLinks/DynamicLinksUtils.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/Dialogs/ChangeProfileDialog.dart';
import 'package:tymoff/Utils/API_Utils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tymoff/Utils/Strings.dart';

class ViewFullScreenProfileImage extends StatefulWidget {

  String imageUrl;

  ViewFullScreenProfileImage(this.imageUrl);

  @override
  _ViewFullScreenProfileImageState createState() => _ViewFullScreenProfileImageState();
}

class _ViewFullScreenProfileImageState extends State<ViewFullScreenProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 1.0,
        titleSpacing: 0.0,
        backgroundColor: Colors.black,
        actions: <Widget>[
          buildActionWidget("assets/edit_tym.png", onTap: (){
            profilePhotoDialog(context,widget.imageUrl);
          }),

          buildActionWidget("assets/share_web48.png", onTap: (){
            DynamicLinksUtils().shareMedia("", fileUrl: widget.imageUrl, context: context);
          }),
        ],
        leading: GestureDetector(
          child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
                size: 22.0,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: CustomWidget.getText(Strings.profilePhoto,
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(fontSize: 20.0,color: Colors.white70)),
      ),
      body: getImageWidget(),
    );
  }

  Widget buildActionWidget(String assetName,{onTap}){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(2.0),
        color: Colors.transparent,
        child: Image.asset(assetName,scale: 3.0,color: ColorUtils.whiteColor,),
      ),
      onTap: onTap,
    );
  }


  Widget getImageWidget() {
    Widget imageWidget = Container();

    Widget widgetCustomImage =  Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholderFadeInDuration: Duration(seconds: 1),
              placeholder: (context, url) => SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorUtils.primaryColor),
                      strokeWidth: 2.0)
              ),
              fadeInCurve: Curves.easeInOutCubic,
              fadeInDuration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );

    imageWidget = PhotoView.customChild(child: widgetCustomImage,
      childSize: MediaQuery.of(context).size,
      initialScale: PhotoViewComputedScale.contained,
      maxScale: 10.0,
      minScale: PhotoViewComputedScale.contained * 0.5,
      enableRotation: false,);

    return imageWidget;
  }


  void editUserProfilePic(BuildContext context, ImageSource source) async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse = await API_Utils.editUserProfilePic(context, source);

      setImageUrl(editLoginResponse);
    } catch (e) {
      print("Munish Thakur -> editUserProfilePic() -> ${e.toString()}");
    }
  }

  void removeProfilePicMethod() async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse = await API_Utils.removeProfilePic(context);

      setImageUrl(editLoginResponse);
    } catch (e) {
      print("Munish Thakur -> removeProfilePicMethod() -> ${e.toString()}");
    }
    Navigator.of(context).pop();
  }

  void setImageUrl(LoginResponse editLoginResponse) {
    if(mounted) {
      setState(() {
        widget.imageUrl = editLoginResponse?.data?.picUrl ?? "";
      });
    }
  }


  void profilePhotoDialog(BuildContext context, String imageUrl) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ChangeProfileDialog(
            widget.imageUrl,
            pickProfilePhotoFromGallery: () =>
                Navigator.of(context).pop(editUserProfilePic(context, ImageSource.gallery)),
            removeProfilePhoto: (){
              Navigator.of(context).pop(removeProfilePicMethod());

            },
            pickProfilePhotoFromCamera: () =>
                Navigator.of(context).pop(editUserProfilePic(context, ImageSource.camera)),
          );
        });
  }
}
