import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Account/EnterNewPassword.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';



class EnterOtp extends StatefulWidget {

  final LoginResponse loginResponse;
  final OtpVerificationFlow otpVerificationFlow;

  EnterOtp({this.loginResponse, this.otpVerificationFlow});

  @override
  _EnterOtpState createState() => _EnterOtpState(loginResponse, otpVerificationFlow);
}

class _EnterOtpState extends State<EnterOtp> {

  LoginResponse loginResponse;
  OtpVerificationFlow otpVerificationFlow;
  _EnterOtpState(this.loginResponse, this.otpVerificationFlow);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int val = 3;
  CountDown cd;
  String enteredOtp = "";

  @override
  void initState() {
    super.initState();
    countdown();
  }

  void countdown() async {
    cd = new CountDown(new Duration(seconds:60));
    await for (var v in cd.stream) {
      setState(() => val = v.inSeconds);
    }
  }
  Widget _text2(String text, String text1){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomWidget.getText(text,fontSize: 15.0,textColor: Colors.grey),
        GestureDetector(
          child: CustomWidget.getText(text1,textColor:Color(0xfFFeb1d25),fontSize: 15.0,fontWeight:FontWeight.w500),
          onTap: (){
            AnalyticsUtils?.analyticsUtils?.eventResendOTPButtonClicked();
          },
        )

      ],
    );
  }

  Widget toppart(){
    return Container(
      padding: EdgeInsets.only(top: 100.0,left: 8.0),
      child: Column(
        children: <Widget>[
          Center(
            child: SvgPicture.asset("assets/applogo.svg",height: 25.0,),
          ),
          SizedBox(height: 60.0,),
          Row(
            children: <Widget>[
              CustomWidget.getText('Enter OTP',fontSize: 30.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start),
            ],
          ),

    Container(
    alignment: Alignment.topLeft,
      child: SizedBox(
        width: 260.0,
        child: Container()


        /*PinView (
            count: 6, // describes the field number
            autoFocusFirstField: false, // defaults to true
            margin: EdgeInsets.all(10.0), // margin between the fields
            obscureText: true, // describes whether the text fields should be obscure or not, defaults to false
            style: TextStyle (
              // style for the fields
                fontSize: 30.0,
                fontWeight: FontWeight.w500
            ),
            dashStyle: TextStyle (
              // dash style
                fontSize: 0.0,
                color: Colors.grey
            ),
            submit: (String pin) {
              if(pin != null){
                setState(() {
                  enteredOtp = pin;
                });
              }else{
                SnackBarUtil.show(_scaffoldKey, "Please enter the valid OTP");
              }

              // when all the fields are filled
              // submit function runs with the pin
              print(pin);
            }
        ),*/
      ),
    ),
          Padding(padding: EdgeInsets.only(right: 10.0,left: 8.0),
            child:_text2("Receive the OTP within"+ " "+ val.toString()+"s", "Resend OTP"),
          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0,right: 8.0,left: 8.0,),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                CustomWidget.getRaisedBtn(context, "Proceed",onPressed: (){
                  AnalyticsUtils?.analyticsUtils?.eventEnterOTPProceedButtonClicked();
                  onOtpPress();
                }),
              ],
            ),
          ),
          SizedBox(height: 26.0,),
          new Center(
            child:FlatButton(onPressed: (){
              Navigator.pop(context);
            },
                child:CustomWidget.getText("Back ",fontWeight: FontWeight.bold,textAlign: TextAlign.center,fontSize: 18.0),

            )

          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:  _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context,int index){
            return toppart();
          },childCount: 1),
          ),
        ],
      ),
    );
  }
  onOtpPress() async {
    String otp = "";
    String email = "";
    if(loginResponse != null){
      email = loginResponse.data.email;
    }
    if((enteredOtp?.length ?? 0) < 6){
      SnackBarUtil.show(_scaffoldKey, "Please enter the valid otp");
      return;
    }else {
      otp = enteredOtp;
    }

    if(otpVerificationFlow == OtpVerificationFlow.forgot_password){
     // Navigator.of(context).pop();
      
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EnterNewPassword(email, otp)));
    }else {
      var otpResponse = await ApiHandler.validateOTPEmail(context, email, otp);
      if(otpResponse != null){
        if(otpResponse.statusCode == 200 ){
          if (otpResponse?.data?.isOtpVerified != null &&
              otpResponse?.data.isOtpVerified){
            if(otpVerificationFlow == OtpVerificationFlow.login){
              Navigator.pop(context,otpResponse);
            }else{
              NavigatorUtils.pushNamedDashBoard(context);
            }
          }
        } else{
          SnackBarUtil.show(_scaffoldKey, otpResponse.message);
        }
      }else{
        SnackBarUtil.show(_scaffoldKey, "Something went wrong.Try Again!");
      }
    }
  }
}
