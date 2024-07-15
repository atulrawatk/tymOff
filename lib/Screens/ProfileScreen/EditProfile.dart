import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/RequestEditProfile.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Network/Response/PutProfileEditResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/Others/SelectCountry.dart';
import 'package:tymoff/Screens/Others/SelectLanguage.dart';
import 'package:tymoff/Screens/ProfileScreen/ProfilePic.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String genderValue;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _languageController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();

  HashMap<int, MetaDataResponseDataCommon> hmSelectedItemsLanguage =
      new HashMap();
  HashMap<int, MetaDataCountryResponseDataCommon> _hmSelectedItemsCountry =
      new HashMap();

  var _languageId;
  var _countryId;
  var _prefixCountryCode = "+91";

  var scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();
    handleLoginData();

    startTimer();
  }

  void handleLoginData() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (mounted) {
        setState(() {
          if (loginResponse != null) {
            var userGenderValue = loginResponse?.data?.gender?.toLowerCase();

            _nameController.text = loginResponse?.data?.name;
            _emailController.text = loginResponse?.data?.email;
            _phoneNumberController.text = loginResponse?.data?.phone;
            _genderController.text = ((userGenderValue?.length ?? 0) > 1)
                ? (userGenderValue[0].toUpperCase() +
                    userGenderValue.substring(
                        1, (userGenderValue?.length ?? 0)))
                : "";
            _languageId = loginResponse?.data?.languageId;
            _countryId = loginResponse?.data?.countryId;

            SharedPrefUtil.getMetaData()?.then((_metaDataResponse) {
              _metaDataResponse.data.countries.forEach((countryData) {

                var itemId = countryData.getUID();
                if (_countryId == itemId) {
                  _countryController.text = countryData.name;
                  _hmSelectedItemsCountry[itemId] = countryData;

                  AppUtils.refreshCurrentState(this);
                }
              });
            });

            SharedPrefUtil.getMetaData()?.then((_metaDataResponse) {
              _metaDataResponse.data.languages.forEach((languageData) {
                var itemId = languageData.getUID();
                if (_languageId == itemId) {
                  _languageController.text = languageData.nameUtf8;
                  hmSelectedItemsLanguage[itemId] = languageData;

                  AppUtils.refreshCurrentState(this);
                }
              });
            });
          } else {
            print("login response from shared pref is null");
          }
        });
      }
    });
  }

  void setCountryCode(int diallingCode) {
    if (mounted) {
      setState(() {
        _prefixCountryCode = "+${diallingCode.toString()}";
      });
    }
  }

  var dropdownValue;

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

  Widget buildEditProfileWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ProfilePic(isChangeProfilePhotoTextVisible: true),
          SizedBox(
            height: 20.0,
          ),
          CustomWidget.getText(Strings.name,
              style: Theme.of(context).textTheme.subtitle),
          getTextField(_nameController),
          SizedBox(
            height: 20.0,
          ),
          CustomWidget.getText(Strings.email,
              style: Theme.of(context).textTheme.subtitle),
          getTextField(_emailController),
          SizedBox(
            height: 20.0,
          ),
          dropDownField(Strings.selectLanguage, _languageController,
              ontap: () async {
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => SelectLanguage(
                        isMultipleSelection: false,
                        hmSelectedItems: hmSelectedItemsLanguage)));

            if (hmSelectedItemsLanguage != null &&
                hmSelectedItemsLanguage.length > 0) {
              var listOfLanguages = hmSelectedItemsLanguage.values.toList();
              var response = listOfLanguages[0];
              _languageId = response.id;
              _languageController.text = response.nameUtf8;
              AppUtils.refreshCurrentState(this);
            }
          }),
          SizedBox(
            height: 20.0,
          ),
          dropDownField(Strings.selectCountry, _countryController,
              ontap: () async {
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => SelectCountry(
                          hmSelectedItems: _hmSelectedItemsCountry,
                        )));

            if (_hmSelectedItemsCountry != null &&
                _hmSelectedItemsCountry.length > 0) {
              var listOfLanguages = _hmSelectedItemsCountry.values.toList();
              var response = listOfLanguages[0];
              _countryId = response.id;
              _countryController.text = response.name;
              setCountryCode(response.diallingCode);
              AppUtils.refreshCurrentState(this);
            }
          }),
          SizedBox(
            height: 20.0,
          ),
          CustomWidget.getText(Strings.phoneNumber,
              style: Theme.of(context).textTheme.subtitle),
          GestureDetector(
            child: Container(
                color: Colors.transparent,
                child: IgnorePointer(
                  child: getTextFieldForNumber(_phoneNumberController,
                      prefixText: "($_prefixCountryCode)  "),
                )),
            onTap: () {
              ToastUtils.show("Sorry! You can't edit phone number.");
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          dropDownField(Strings.gender, _genderController, ontap: () {
            _showGenderDialog(listOfGender);
            print("Gender is clickd ");
          }),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  List<String> listOfGender = [Strings.male, Strings.female, Strings.other];
  String selectedValue = '';

  void _showGenderDialog(List list) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: new SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: new List<InkWell>.generate((list?.length ?? 0),
                      (int index) {
                    return InkWell(
                      splashFactory: InkRipple.splashFactory,
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(20.0, 40.0),
                              topRight: Radius.elliptical(20.0, 40.0),
                              bottomRight: Radius.elliptical(20.0, 40.0),
                              bottomLeft: Radius.elliptical(20.0, 40.0))),
                      highlightColor: Colors.transparent,
                      splashColor: ColorUtils.splashColor,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: 48.0,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Text(
                          "${list[index]}",
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      onTap: () {
                        setState(() async {
                          _genderController.text = list[index];
                          await new Future.delayed(
                              const Duration(milliseconds: 250));
                          //gender = list[index]; //set value to gender field for api hit.

                          Navigator.pop(context);
                        });
                      },
                    );
                  })),
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  bool _isScrollBlocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar().getAppBar(
        context: context,
        title: Strings.editProfile,
        leadingIcon: Icons.arrow_back_ios,
      ),
      body: StreamBuilder<PutProfileEditResponse>(
          stream: null,
          builder: (context, snapshot) {
            return CustomScrollView(
              physics: _isScrollBlocked
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return buildEditProfileWidget();
                  },
                  childCount: 1,
                ))
              ],
            );
          }),
      bottomNavigationBar:
          CustomWidget.getBottomNavigationBar(Strings.save, onTap: () {
        AnalyticsUtils?.analyticsUtils?.eventSaveEditProfileButtonClicked();
        hitPutEditProfile(context);
      }),
    );
  }

  void hitPutEditProfile(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;
    String gender = _genderController.text;

    RequestEditProfile requestEditProfile = RequestEditProfile(
        name: name,
        countryId: _countryId,
        languageId: _languageId,
        gender: gender,
        email: email,
        phone: phoneNumber);

    var editProfileJson = requestEditProfile.toJson().toString();
    print("Munish Thakur -> editProfileJson -> \n $editProfileJson");

    try {
      var putProfileEditResponse =
          await ApiHandler.putEditProfile(context, requestEditProfile);
      if (putProfileEditResponse.isSuccess()) {
        ToastUtils.show("Details are edited successfully");

        //SnackBarUtil.showSnackBar(context, "Details are edited successfully");
        Navigator.pop(context);
        print("edit profile api hit successfully");
      } else if (putProfileEditResponse?.message != null) {
        ToastUtils.show(putProfileEditResponse?.message);
      } else {
        SnackBarUtil.showSnackBar(context, "Something went wrong! Try Again");
        print("error in edit profile api ");
      }
    } catch (e) {
      print("Munish Thakur -> hitPutEditProfile() -> ${e.toString()}");
    }
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 2), (_timer) {
      _isScrollBlocked = false;
      moveToInitalPosition();
      _timer.cancel();
      AppUtils.refreshCurrentState(this);
    });
  }

  void moveToInitalPosition() {
    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 1), curve: Curves.easeIn);
  }
}
