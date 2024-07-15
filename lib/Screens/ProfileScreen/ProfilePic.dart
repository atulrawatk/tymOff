import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Dialogs/ChangeProfileDialog.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/API_Utils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class ProfilePic extends StatefulWidget {
  bool _isUserCanEditPic = true;
  final bool isChangeProfilePhotoTextVisible;

  ProfilePic({bool isUserCanEditPic, this.isChangeProfilePhotoTextVisible}) {
    this._isUserCanEditPic =
        AppUtils.isValid(isUserCanEditPic, defaultReturn: _isUserCanEditPic);
  }

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String _imageFileUrl;
  var dropdownValue;

  @override
  void initState() {
    super.initState();
    handleLoginData();
  }

  void handleLoginData() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (loginResponse != null) {
        _imageFileUrl = loginResponse?.data?.picUrl;
      } else {
        print("login response from shared pref is null");
      }
      AppUtils.refreshCurrentState(this);
    });
  }

  Widget profilePicUI() {
    return InkWell(
      onTap: () {
        profilePhotoDialog(context);
        //picker(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: new Stack(
              children: <Widget>[
                _imageFileUrl != null && _imageFileUrl.length > 0
                    ? Center(
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          child: CachedNetworkImage(
                            imageUrl: _imageFileUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.3)),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            placeholderFadeInDuration: Duration(seconds: 1),
                            placeholder: (context, url) => SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(ColorUtils.primaryColor),
                                    strokeWidth: 2.0)
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),

                         /* decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  new CachedNetworkImageProvider(_imageFileUrl, pla),
                            ),
                          ),*/
                        ),
                      )
                    : new Center(
                        child: new Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorUtils.lightGreyColor.withOpacity(0.1),
                                width: 0.5),
                            color: ColorUtils.userPicBgColor,
                            borderRadius: BorderRadius.circular(60.0),

                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/dummy_user_profile.png",
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          widget.isChangeProfilePhotoTextVisible
              ? Visibility(
                  visible: isPicEditable(),
                  child: Container(
                    height: 30.0,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: CustomWidget.getText("Change Profile Photo",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: ColorUtils.articleTextColor)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget getTextFieldForNumber(TextEditingController controller,
      {String prefixText, bool isPass = false, onChange, Widget suffixWidget}) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorUtils.iconGreyColor,
        indicatorColor: ColorUtils.iconGreyColor,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        obscureText: isPass,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(4.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.grey,
          )),
          prefixText: prefixText,
          suffix: suffixWidget,
        ),
        onChanged: onChange,
      ),
    );
  }

  Widget getTextField(TextEditingController controller,
      {String prefixText, bool isPass = false, onChange, Widget suffixWidget}) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorUtils.iconGreyColor,
        indicatorColor: ColorUtils.iconGreyColor,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(4.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.grey,
          )),
          prefixText: prefixText,
          suffix: suffixWidget,
        ),
        onChanged: onChange,
      ),
    );
  }

  Widget dropDownField(String text, controller, {ontap}) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomWidget.getText(text,
                style: Theme.of(context).textTheme.subtitle),
            IgnorePointer(
              child: getTextField(controller),
            )
          ],
        ),
      ),
      onTap: ontap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: profilePicUI(),
    );
  }

  bool isPicEditable() {
    return widget?._isUserCanEditPic ?? false;
  }

  void editUserProfilePic(BuildContext context, ImageSource source) async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse = await API_Utils.editUserProfilePic(context, source);

      handleLoginData();
    } catch (e) {
      print("Munish Thakur -> editUserProfilePic() -> ${e.toString()}");
    }
  }

  void removeProfilePicMethod() async {
    LoginResponse editLoginResponse;
    try {
      editLoginResponse = await API_Utils.removeProfilePic(context);

      handleLoginData();
    } catch (e) {
      print("Munish Thakur -> removeProfilePicMethod() -> ${e.toString()}");
    }
  }

  void profilePhotoDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ChangeProfileDialog(
            _imageFileUrl,
            pickProfilePhotoFromGallery: () => Navigator.of(context)
                .pop(editUserProfilePic(context, ImageSource.gallery)),
            removeProfilePhoto: () =>
                Navigator.of(context).pop(removeProfilePicMethod()),
            pickProfilePhotoFromCamera: () => Navigator.of(context)
                .pop(editUserProfilePic(context, ImageSource.camera)),
          );
        });
  }
}
