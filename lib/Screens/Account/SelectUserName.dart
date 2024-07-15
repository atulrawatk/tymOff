import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/RequestEditProfile.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/ProfileScreen/ProfilePic.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class SelectedUserName extends StatefulWidget {
  @override
  _SelectedUserNameState createState() => _SelectedUserNameState();
}

class _SelectedUserNameState extends State<SelectedUserName> {
  TextEditingController _nameController = TextEditingController();
  String userName;

  @override
  void initState() {
    super.initState();
    handleLoginData();
  }

  void handleLoginData() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (mounted) {
        setState(() {
          if (loginResponse != null) {
            userName = loginResponse?.data?.name;
            _nameController.text = userName;
          } else {
            print("login response from shared pref is null");
          }
        });
      }
    });
  }

  void setUserName(String value) {
    userName = value;
    setState(() {});
  }

  bool isValidUserName() {
    return (userName != null && userName.trim().length >1);
  }

  Widget mainPart() {
    return Container(
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(top: 60.0, left: 42.0, right: 42.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          CustomWidget.getText(
            Strings.helpOtherFindYou,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: ColorUtils.blackColor.withOpacity(0.9),fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40.0,
          ),
          CustomWidget.getText(
            Strings.addYourNameAndProfilePicturesoYourFriends,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 14.0,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 32.0,
          ),
          ProfilePic(isChangeProfilePhotoTextVisible: false,),
          Padding(
            padding: const EdgeInsets.only(left:4.0,right: 4.0),
            child: CustomWidget.getTextField(
                context, _nameController, " ", Strings.enterYourName,
                onChange: (String value) {
                  setUserName(value);
                }),
          ),
          SizedBox(
            height: 40.0,
          ),
      Container(
        padding: EdgeInsets.only(left: 4.0,right: 4.0),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.getRaisedBtn(context, Strings.next,
            onPressed: isValidUserName()
                ? () {
              hitPutEditProfile(context);
            }
                : null,
            disableColor: Color(0xffFFB4CE),
            disableTextColor: Colors.white),
      ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: WillPopScope(
        onWillPop: () async => false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate((context, int index) {
              return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[mainPart()]);
            }, childCount: 1))
          ],
        ),
      ),
    );
  }


  Widget getAppBar() {
    Widget appBar = CustomAppBar().getAppBar(
        context: context,
        leadingIcon: Icons.clear,
        iconSize: 28.0,
        elevation: 0.0

    );
    return appBar;
  }

  void hitPutEditProfile(BuildContext context) async {
    String name = _nameController.text;

    RequestEditProfile requestEditProfile = await RequestEditProfile.fromSharedPreferenceUserData();
    requestEditProfile.name = name;

    try {
      var putProfileEditResponse =
          await ApiHandler.putEditProfile(context, requestEditProfile);
      if (putProfileEditResponse.isSuccess()) {
        ToastUtils.show("Details are edited successfully");

        //SnackBarUtil.showSnackBar(context, "Details are edited successfully");
        Navigator.pop(context);
        print("edit profile api hit successfully");
      } else {
        SnackBarUtil.showSnackBar(context, "Something went wrong! Try Again");
        print("error in edit profile api ");
      }
    } catch (e) {
      print("Munish Thakur -> hitPutEditProfile() -> ${e.toString()}");
    }
  }
}
