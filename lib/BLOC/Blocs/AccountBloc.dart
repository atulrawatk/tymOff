import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LogOutResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/Account/TempOtp.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class AccountBloc extends BlocBase {
  StateOfAccount _accountState;
  final _accountStateFetcher = PublishSubject<StateOfAccount>();

  Stream<StateOfAccount> get accountStateObservable =>
      _accountStateFetcher.stream;

  AccountBloc() {
    resetAccountFromSharedPreference();
  }

  void resetAccountFromSharedPreference() async {
    _accountState = await StateOfAccount().reset();
    _accountStateFetcher.add(_accountState);
  }

  StateOfAccount getAccountState() {
    return _accountState;
  }

  void changeAccountState(LoginResponse loginResponse) {
    _accountState.changeState(loginResponse);
    _accountStateFetcher.add(_accountState);
  }

  void changeAccountLogin(bool isLogin) {
    _accountState.setUserLoggedIn(isLogin);
    _accountStateFetcher.add(_accountState);
  }

  void handleMobileLoginResponse(BuildContext context){
    NavigatorUtils.moveToOTPValidationScreen(context);
  }

  void handleLoginResponse(BuildContext context, LoginResponse loginResponse,
      {
        GlobalKey<ScaffoldState> scaffoldKey,
        OtpVerificationFlow otpVerificationFlow,
        isNeedToFinish: true
      }) async {
    try {

      if (loginResponse?.statusCode == 200) {

        //SnackBarUtil.show(scaffoldKey, loginResponse.message);

        if(loginResponse?.data?.isOtpVerified != null) {
          if (loginResponse.data.isOtpVerified) {
            await SharedPrefUtil.saveLoginData(loginResponse);
            PrintUtils.printLog("I am here ... Login data is saved to Shared Pref");

            ApiHandler.loadAfterLoginData(context);

            resetAccountFromSharedPreference();

            EventBusUtils.eventRefreshContent();

            if(isNeedToFinish) {
              Navigator.pop(context);
            }
          }
          else {


            NavigatorUtils.moveToOTPValidationScreen(context, loginResponse: loginResponse,
                otpVerificationFlow: OtpVerificationFlow.forgot_password);
          }
        } else {
          ToastUtils.show("Something went wrong, Please try later.");
        }

      } else if(loginResponse?.statusCode == 1204 || loginResponse?.statusCode == 1203){
        if(otpVerificationFlow == OtpVerificationFlow.login ){
          var response = await ApiHandler.doVerifiedEmail(context,loginResponse?.data?.email,loginResponse?.data?.flowType,"app");
          if (response.statusCode == 200 || response.data.isOtpVerified == false){
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EnterOtpTemp(loginResponse: loginResponse, otpVerificationFlow:otpVerificationFlow))) as LoginResponse;

            if(result != null && ( result?.data?.isOtpVerified != null &&
                result?.data?.isOtpVerified)){
              await SharedPrefUtil.saveLoginData(result);
              ApiHandler.loadAfterLoginData(context);

              resetAccountFromSharedPreference();
              Navigator.pop(context); /// close login screen
            }

          }


        }else{
          SnackBarUtil.showSnackBar(context,"The email address you have entered is already registered.");
        }

      }
      else {
        SnackBarUtil.showSnackBar(context, loginResponse?.message ?? "Something went wrong! Try again later.");
      }
    } catch (e) {
      SnackBarUtil.showSnackBar(context, e.toString());
      PrintUtils.printLog(e.toString());
    }
  }
  void handleLoginResponseMobileOtpFlow(BuildContext context, LoginResponse loginResponse,
      {
        GlobalKey<ScaffoldState> scaffoldKey,
        OtpVerificationFlow otpVerificationFlow,
        isNeedToFinish: true
      }) async {
    try {

      if (loginResponse?.statusCode == 200) {

        //SnackBarUtil.show(scaffoldKey, loginResponse.message);

        if(loginResponse?.data?.id != null) {
            await SharedPrefUtil.saveLoginData(loginResponse);
            PrintUtils.printLog("I am here ... Login data is saved to Shared Pref");

            ApiHandler.loadAfterLoginData(context);

            resetAccountFromSharedPreference();

            EventBusUtils.eventRefreshContent();

            if(isNeedToFinish) {
              Navigator.pop(context);
            }

            NavigatorUtils.pushNamedDashBoard(context);

            NavigatorUtils.moveToEditUserScreenLoginFlow(context);
        } else {
          ToastUtils.show("Something went wrong, Please try later.");
        }

      } else {
        SnackBarUtil.showSnackBar(context, loginResponse?.message ?? "Something went wrong! Try again later.");
      }
    } catch (e) {
      SnackBarUtil.showSnackBar(context, e.toString());
      PrintUtils.printLog(e.toString());
    }
  }

  bool isUserLoggedIn(StateOfAccount stateOfAccount) {
    return (stateOfAccount != null) && (_accountState.isUserLoggedIn());
  }

  @override
  void dispose() {
    _accountStateFetcher.close();
  }

  void logOut(BuildContext context,{GlobalKey<ScaffoldState> scaffoldKey}) async {
/*
    await SharedPrefUtil.logout(context);
    NavigatorUtils.moveToDashBoard(context);
    resetAccountFromSharedPreference();*/

   try{
     LogOutResponse logOutResponse = await ApiHandler.getUserLogOut(context);
     if(logOutResponse.statusCode == 200){
       await SharedPrefUtil.logout(context);
       NavigatorUtils.moveToDashBoard(context);
       resetAccountFromSharedPreference();
       PrintUtils.printLog("log out api hit successfully");
     } else{
       SnackBarUtil.show(scaffoldKey, logOutResponse.message);
       PrintUtils.printLog("error in log out api ");
     }
   }catch(e){
     PrintUtils.printLog(e.toString());
   }

   EventBusUtils.eventRefreshContent();
  }

}

class StateOfAccount {
  var _isLogin = false;
  LoginResponse _loginResponse;

  StateOfAccount();

  bool isUserLoggedIn() {
    return _isLogin;
  }

  void setUserLoggedIn(bool _isLogin) {
    this._isLogin = _isLogin;
  }

  LoginResponse getLoggedInUseInfo() {
    return _loginResponse;
  }

  Future<StateOfAccount> reset() async {
    _isLogin = await SharedPrefUtil.isLogin();
    _loginResponse = await SharedPrefUtil.getLoginData();

    return this;
  }

  changeState(LoginResponse loginResponse) {
    this._loginResponse = loginResponse;
    var _email = this._loginResponse?.data?.email;
    if (_email != null && _email.trim().length > 0) {
      this._isLogin = true;
    } else {
      this._isLogin = false;
    }
  }
}
