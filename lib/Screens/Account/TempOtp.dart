import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Account/EnterNewPassword.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';

class EnterOtpTemp extends StatefulWidget {
  final LoginResponse loginResponse;
  final OtpVerificationFlow otpVerificationFlow;

  EnterOtpTemp({this.loginResponse, this.otpVerificationFlow});

  @override
  _EnterOtpTempState createState() =>
      _EnterOtpTempState(loginResponse, otpVerificationFlow);
}

class _EnterOtpTempState extends State<EnterOtpTemp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginResponse loginResponse;
  OtpVerificationFlow otpVerificationFlow;

  _EnterOtpTempState(this.loginResponse, this.otpVerificationFlow);

  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  TextEditingController currController = new TextEditingController();

  String getOtpCodeString() {
    var finalValue = controller1.text + controller2.text + controller3.text + controller4.text + controller5.text + controller6.text;
    return finalValue;
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currController = controller1;
    countdown();
  }

  int val = 3;
  CountDown cd;

  void countdown() async {
    cd = new CountDown(new Duration(seconds: 60));
    await for (var v in cd.stream) {
      setState(() => val = v.inSeconds);
    }
  }

  onOtpPress() async {
    var enteredOtp = getOtpCodeString();
    String otp = "";
    String email = "";
    if (loginResponse != null) {
      email = loginResponse.data.email;
    }
    if ((enteredOtp?.length ?? 0) != 6) {
      SnackBarUtil.show(_scaffoldKey, "Please enter the valid otp");
      return;
    } else {
      otp = enteredOtp;
    }

    if (otpVerificationFlow == OtpVerificationFlow.forgot_password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EnterNewPassword(email, otp)));
    } else {
      var otpResponse = await ApiHandler.validateOTPEmail(context, email, otp);
      if (otpResponse != null) {
        if (otpResponse.statusCode == 200) {
          NavigatorUtils.pushNamedDashBoard(context);
        } else {
          SnackBarUtil.show(_scaffoldKey, otpResponse.message);
        }
      } else {
        SnackBarUtil.show(_scaffoldKey, "Something went wrong.Try Again!");
      }
    }
  }

  Widget _text2(String text, String text1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomWidget.getText(text, fontSize: 15.0, textColor: Colors.grey),
        GestureDetector(
          child: CustomWidget.getText(text1,
              textColor: Color(0xfFFeb1d25),
              fontSize: 15.0,
              fontWeight: FontWeight.w500),
          onTap: () {
            AnalyticsUtils?.analyticsUtils?.eventResendOTPButtonClicked();
          },
        )
      ],
    );
  }

  Widget toppart(int index) {
    return Container(
      padding: EdgeInsets.only(top: 100.0, left: 8.0),
      child: Column(
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              "assets/applogo.svg",
              height: 25.0,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: Row(
              children: <Widget>[
                CustomWidget.getText('Enter OTP',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start),
              ],
            ),
          ),

          ///Pinview
          pinViewCommon(index),

          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 8.0,
              left: 8.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomWidget.getRaisedBtn(context, "Proceed", onPressed: () {
                  AnalyticsUtils?.analyticsUtils
                      ?.eventEnterOTPProceedButtonClicked();
                  onOtpPress();
                }),
              ],
            ),
          ),
          SizedBox(
            height: 26.0,
          ),
        ],
      ),
    );
  }

  Widget pinViewCommon(int index) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                border: new Border.all(
                    width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                borderRadius: new BorderRadius.circular(4.0)),
            child: new TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                enabled: false,
                controller: controller1,
                autofocus: false,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.black),
                )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              controller: controller2,
              autofocus: false,
              enabled: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              keyboardType: TextInputType.number,
              controller: controller3,
              textAlign: TextAlign.center,
              autofocus: false,
              enabled: false,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
              ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              textAlign: TextAlign.center,
              controller: controller4,
              autofocus: false,
              enabled: false,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
              ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              textAlign: TextAlign.center,
              controller: controller5,
              autofocus: false,
              enabled: false,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
              ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              textAlign: TextAlign.center,
              controller: controller6,
              autofocus: false,
              enabled: false,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
              ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    ///All OTP Feild in grid....
    return Column(
      children: <Widget>[
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GridView.count(
                  crossAxisCount: 8,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  children: List<Container>.generate(
                      8, (int index) => Container(child: widgetList[index]))),
            ]),
        Padding(
          padding:
              EdgeInsets.only(right: 45.0, left: 45.0, top: 10.0, bottom: 20),
          child: _text2("Receive the OTP within" + " " + val.toString() + "s",
              "Resend OTP"),
        ),

        ///OTP Keyboard UI & Functionality......
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 16.0, right: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("1");
                      },
                      child: Text("1",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("2");
                      },
                      child: Text("2",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("3");
                      },
                      child: Text("3",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("4");
                      },
                      child: Text("4",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("5");
                      },
                      child: Text("5",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("6");
                      },
                      child: Text("6",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("7");
                      },
                      child: Text("7",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("8");
                      },
                      child: Text("8",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("9");
                      },
                      child: Text("9",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: CustomWidget.getText("Back ",
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      fontSize: 16.0,
                                    ))),
                    MaterialButton(
                      onPressed: () {
                        inputTextToField("0");
                      },
                      child: Text("0",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                        onPressed: () {
                          deleteText();
                        },
                        child: CustomWidget.getText("Clear ",
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      fontSize: 16.0,
                                    ))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return toppart(index);
            }, childCount: 1),
          ),
        ],
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }
    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }
    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }
    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller5;
    }
    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller6;
    }
    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if ((currController?.text?.length ?? 0) == 0) {
    } else {
      currController.text = "";
      currController = controller5;
      return;
    }
    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }
}
