import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/VerifiedEmailRequest.dart';
import 'package:tymoff/Screens/Account/EnterNewPassword.dart';
import 'package:tymoff/Screens/Account/EnterOtp.dart';
import 'package:tymoff/Screens/Account/TempOtp.dart';
import 'package:tymoff/Screens/Home/Dashboard.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/Utils/ValidationUtil.dart';

class ResetByMail extends StatefulWidget {
  @override
  _ResetByMailState createState() => _ResetByMailState();
}

class _ResetByMailState extends State<ResetByMail> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  validateFormAndSave() {
    print("Validating Form...");
    if (formKey.currentState.validate()) {
      print("Validation Successful");
      formKey.currentState.save();
      hitEmailValidateApi();
    } else {
      print("Validation Error");
    }
  }
  hitEmailValidateApi()async{
   // var email = "ankitrajput288@gmail.com";
    //var flowType = OtpVerificationFlow.forgot_password.toString();
    var flowType = "forgot_password";
    var socialType =  "app";

    var response = await ApiHandler.doVerifiedEmail(context,_enteredEmail,flowType,socialType);
    if(response != null){
      if (response.statusCode == 200) {
        // Navigator.of(context).pop();

        NavigatorUtils.moveToOTPValidationScreen(context, loginResponse: response,
            otpVerificationFlow: OtpVerificationFlow.forgot_password);
      }
      else{
        SnackBarUtil.show(_scaffoldKey, response.message);
        print(response.message);
      }
    }else{
      SnackBarUtil.show(_scaffoldKey, "Something went wrong.Try Again!");
    }
  }

  TextEditingController _emailController = new TextEditingController();
  String _enteredEmail;
  Widget _topPart(){
  return  Container(
    padding: EdgeInsets.only(left: 16.0,right: 16.0,top: 50.0,bottom: 50.0),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: SvgPicture.asset("assets/applogo.svg",height: 25.0,),
          ),
          SizedBox(height: 30.0,),
          CustomWidget.getText("Let's find your tymoff's account",
            style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500)
          ),
          SizedBox(height: 20.0,),

          Container(
              height: 42.0,
              color: Theme.of(context).secondaryHeaderColor,
              padding: EdgeInsets.only(left:10.0 ),
              child: Center(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration.collapsed(
                    hintText: Strings.email,hintStyle:Theme.of(context).textTheme.subtitle
                  ),
                  onSaved: (String value) => _enteredEmail = value.trim(),
                    validator: (value) =>
                        ValidationUtil.isEmpty(value, Strings.email)
                ),
              //  TextField(decoration: InputDecoration.collapsed(hintText: Strings.email,),),
              )
          ),
          SizedBox(height: 16.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CustomWidget.getRaisedBtn(context,"Send OTP",textColor: Colors.white,onPressed: (){
                AnalyticsUtils?.analyticsUtils?.eventSendOTPButtonClicked();
                validateFormAndSave();
              }
              ),
            ],
          ),
          SizedBox(height: 16.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child:CustomWidget.getText("Back ",
                    style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500)),
                onTap: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:  CustomScrollView(
        slivers: <Widget>[
          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context,int index){
            return _topPart();
          },childCount: 1),
          ),
        ],
      ),
    );
  }
}
