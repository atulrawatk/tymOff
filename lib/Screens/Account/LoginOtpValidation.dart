import 'package:countdown/countdown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Utils/ColorUtils.dart';

class LoginOtpValidation extends StatefulWidget {
  final String countryCode;
  final String mobileNumber;

  LoginOtpValidation(this.countryCode, this.mobileNumber);

  @override
  _LoginOtpValidationState createState() => _LoginOtpValidationState();
}

class _LoginOtpValidationState extends State<LoginOtpValidation>
    with CodeAutoFill {

  AccountBloc accountBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController otpController = new TextEditingController();

  String enteredOtp = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startCountDownResendOtpTimer();

    _initAutoReadSMS();
    _listenForCode();
  }

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);

    super.didChangeDependencies();
  }

  void _initAutoReadSMS() {
    super.listenForCode();
  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

  int countDownTimerVal;
  CountDown cdTimer;
  bool isResendOtpVisible = false;
  int _resendOtpCountDownTimer = 30;

  void _startCountDownResendOtpTimer() async {
    cdTimer = new CountDown(new Duration(seconds: _resendOtpCountDownTimer));
    cdTimer.stream.listen((_countTimer) {
      if(mounted) {
        setState(() {
          countDownTimerVal = _countTimer.inSeconds;
          isResendOtpVisible = !(countDownTimerVal > 0);
        });
      }
    });
  }

  void validateOtpViaServer() async {
    //var enteredOtp = getOtpCodeString();
    var enteredOtp = otpController.text;
    String otp = "";

    if (enteredOtp.length != 4) {
      SnackBarUtil.show(_scaffoldKey, "Please enter the valid otp");
      return;
    } else {
      otp = enteredOtp;
    }
    var otpResponse = await ApiHandler.validateOTPMobile(context, widget.mobileNumber, otp);

    handleLoginResponse(otpResponse);
  }

  void handleLoginResponse(LoginResponse parsedResponse) {
    BuildContext buildContext = context;
    accountBloc.handleLoginResponseMobileOtpFlow(
      buildContext,
      parsedResponse,
      scaffoldKey: _scaffoldKey,
      otpVerificationFlow: OtpVerificationFlow.login,
      isNeedToFinish: true,
    );
  }

 /* Widget _text2(String text, String text1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomWidget.getText(text, fontSize: 15.0, textColor: Colors.grey),
        Visibility(
          visible: isResendOtpVisible,
          child: GestureDetector(
            child: CustomWidget.getText(text1,
                textColor: Color(0xfFFeb1d25),
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
            onTap: () {
              AnalyticsUtils?.analyticsUtils?.eventResendOTPButtonClicked();
              resendOtp();
            },
          ),
        )
      ],
    );
  }*/

  void resendOtp() {
    ApiHandler.sendOtpMobile(context, widget.countryCode, widget.mobileNumber)
        .then((commonResponse) {
      if (commonResponse != null && commonResponse.statusCode == 200) {
        _startCountDownResendOtpTimer();
        ToastUtils.show(commonResponse.message);
      } else {
        ToastUtils.show("Some error in sending the OTP. Please try later");
      }
    }).catchError((error) {
      ToastUtils.show("Some error in sending the OTP. Please try later");
    });
  }

  Widget mainWidget(int index) {
    return Container(
      padding: EdgeInsets.only(top: 60.0, left: 42.0,right: 42.0),
          child: Column(
            children: <Widget>[
              CustomWidget.getText(Strings.enterOtp,
                  style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.blackColor.withOpacity(0.9),fontSize: 22.0,fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),

              /*
              pinViewCommon(index),*/
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left : 4.0,right: 4.0),
                child: getOtpTextField(),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(left: 10.0,right: 8.0,top: 2.0,bottom: 10.0),
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0,top: 8.0,bottom: 10.0),
                    color: Colors.transparent,
                    child: CustomWidget.getText(Strings.resendOTP,textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.subtitle.copyWith(color: ColorUtils.primaryColor,fontSize: 12.0)),
                  ),
                  onTap: (){
                    AnalyticsUtils?.analyticsUtils?.eventResendOTPButtonClicked();
                    resendOtp();
                    //print("on Resend click");
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
             /* CustomWidget.getText("An OTP as been sent to your ${getSecretMobileNumber()}, please enter the same to proceed or change mobile number.",
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 12.0,fontWeight: FontWeight.w100),
                textAlign: TextAlign.start,
              ),*/
              otpAndChangeMobileNumberSubText(),
              SizedBox(
                height: 40.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomWidget.getRaisedBtn(context, Strings.proceed,
                onPressed: enteredOtp != null && enteredOtp.length > 3 ? (){
                    AnalyticsUtils?.analyticsUtils?.eventEnterOTPProceedButtonClicked();
                    validateOtpViaServer();
                    } : null ,
                    disableColor: ColorUtils.buttonDisabledBackgroundColor,
                    disableTextColor: Colors.white
                ),
              ),
              SizedBox(
                height: 26.0,
              ),
            ],
          ),
        );
  }

  Widget otpAndChangeMobileNumberSubText() {

    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: ColorUtils.primaryColor);

    return RichText(text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          style: aboutTextStyle,
          text: 'An OTP has been sent to your ${getSecretMobileNumber()}, please enter the same to proceed or ',
        ),
        _LinkTextSpan(
          style: linkStyle,
          onTap: () {
            Navigator.pop(context);
            NavigatorUtils.moveToLoginScreen(context, isForceResetOtpFlowScreen: true);
          },
          text: 'change mobile number.',
        ),
      ],
    ),);
    /*
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: CustomWidget.getText(
            "An OTP as been sent to your ${getSecretMobileNumber()}, please enter the same to proceed or ",
            style:
            Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 0,
          child: GestureDetector(
            child: CustomWidget.getText("change mobile number.",
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              NavigatorUtils.moveToLoginScreen(context, isForceResetOtpFlowScreen: true);
            },
          ),
        ),
      ],
    );
    */
  }

  Widget getOtpTextField(){
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: ColorUtils.iconGreyColor,
          indicatorColor: ColorUtils.iconGreyColor,
        ),
        child: TextField(
          cursorColor: ColorUtils.primaryColor,
          controller: otpController,
          keyboardType: TextInputType.phone,
          style: TextStyle(letterSpacing: 4.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2.0),
            ),
          onChanged: (String value) {
            setState(() {
              enteredOtp = value;
            });
          },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar().getAppBar(
          context: context,
          leadingIcon: Icons.clear,
          iconSize: 28.0,
          elevation: 0.0

      ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return mainWidget(index);
            }, childCount: 1),
          ),
        ],
      ),
    );
  }

  @override
  void codeUpdated() {
    print("Munish Thakur -> LoginOtpValidation -> New SMS OTP found -> $code");
    _inputOtpToFields(code);
    _listenForCode();
  }

  void _inputOtpToFields(String code) {
    otpController.text = code;
  }

  String getSecretMobileNumber() {
    String secretMobileNumber = "";
    try {
      var mobileNumber = widget.mobileNumber;
      var mobileNumberLength = mobileNumber.length;
      if(mobileNumberLength > 4) {
        var numberOfStars = mobileNumberLength - 4;
        var suffixOfStars = "";
        for(int index = 0; index < numberOfStars; index++) {
          try {
            var characterOfMobile = mobileNumber.substring(index, index + 1);
            if (characterOfMobile != null && characterOfMobile != " " && characterOfMobile != "-") {
              suffixOfStars += "*";
            } else {
              suffixOfStars += characterOfMobile;
            }
          } catch(e) {

          }
        }

        var prefixNumber = mobileNumber.substring(numberOfStars, mobileNumberLength);
        secretMobileNumber = suffixOfStars + prefixNumber;
      } else {
        secretMobileNumber = widget.mobileNumber;
      }
    } catch(e) {}
    return secretMobileNumber;
  }
}


class _LinkTextSpan extends TextSpan {

  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({ TextStyle style, String text, onTap}) : super(
      style: style,
      text: text,
      recognizer: TapGestureRecognizer()..onTap = () {
        onTap();
      }
  );
}