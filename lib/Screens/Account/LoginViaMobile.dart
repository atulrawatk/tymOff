import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/EventBus/EventModels/EventAppThemeChanged.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Screens/Home/Dashboard.dart';
import 'package:tymoff/Screens/Others/SelectCountry.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class LoginViaMobile extends StatefulWidget {
  bool _isNeedToFinish;

  LoginViaMobile({isNeedToFinish: true}) {
    _isNeedToFinish = isNeedToFinish;
  }

  @override
  _LoginViaMobileState createState() => _LoginViaMobileState();
}

class _LoginViaMobileState extends State<LoginViaMobile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  BuildContext contextForLoginHandler;
  AccountBloc accountBloc;

  final formKey = new GlobalKey<FormState>();

  bool _autoValidate = false;

  String appTheme = "";

  TextEditingController _controllerMobileNumber = TextEditingController();
  String mobileNumber;

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _checkOTPObserver();
    _setControllers();
    _triggerObservers();

    if(metaDataCountryResponseDataCommon == null) {
      _getIpAndCountryCode();
    }
  }

  void _checkOTPObserver() async {
    SharedPrefUtil.getShowOTPScreenMeta().then((_otpMeta){
      if(_otpMeta != null && !_otpMeta.isExpired()){
        NavigatorUtils.moveToLoginOTPValidationScreen(context, _otpMeta.countryCode, _otpMeta.mobile);
      }
    });
  }

  void _setControllers() {
    _controllerMobileNumber = new TextEditingController(text: "");
  }

  void _triggerObservers() {
    _setThemeChangeObserver();
    _checkAndSetWidgetTheme();
  }

  void _setThemeChangeObserver() {
    eventBus.on<EventAppThemeChanged>().listen((event) {
      _checkAndSetWidgetTheme();
    });
  }

  void _checkAndSetWidgetTheme() {
    SharedPrefUtil.getTheme().then((s) {
      if (mounted) {
        PrintUtils.printLog("Munish -> getTheme() -> $s");
        setState(() {
          appTheme = s;
          PrintUtils.printLog('shared p called $s');
        });
      }
    });
  }

  void _getIpAndCountryCode() async {
    var ipCountryResponse = await ApiHandler.getIpResponse();

    if (ipCountryResponse != null) {
      var isoCode = ipCountryResponse.ccode;
      var countryData = await SharedPrefUtil.getCountryDataByIp(isoCode);
      print(
          "Munish Thakur -> _getIpAndCountryCode() -> ipCountryResponse -> ${ipCountryResponse.ccode} (+${ipCountryResponse.code})");
      if (countryData != null) {
        _setSelectedCountryData(countryData);
        print(
            "Munish Thakur -> _getIpAndCountryCode() -> countryData -> (+${countryData.diallingCode})");
      }
    }
  }

  _setSelectedCountryData(MetaDataCountryResponseDataCommon countryData) {
    if(countryData != null) {
      if (mounted) {
        setState(() {
          metaDataCountryResponseDataCommon = countryData;
        });
      } else {
        metaDataCountryResponseDataCommon = countryData;
      }
    }
  }

  void validateFormAndSave() async {

    // TEMP CODE - Munish Thakur
    var countryCode = metaDataCountryResponseDataCommon?.isoCode ?? "0";
    var mobileNumber = _controllerMobileNumber.value.text.toString();
    ApiHandler.sendOtpMobile(context, countryCode, mobileNumber)
        .then((commonResponse) {
      if (commonResponse != null && commonResponse.statusCode == 200) {
        NavigatorUtils.moveToLoginOTPValidationScreen(
            context, countryCode, mobileNumber);
      } else {
        ToastUtils.show("Some error in sending the OTP. Please try later");
      }
    }).catchError((error) {
      ToastUtils.show("Some error in sending the OTP. Please try later");
    });


    /*if (formKey.currentState.validate()) {
      formKey.currentState.save();

      var countryCode = metaDataCountryResponseDataCommon?.isoCode ?? "0";
      var mobileNumber = _controllerMobileNumber.value.text.toString();
      ApiHandler.sendOtpMobile(context, countryCode, mobileNumber)
          .then((commonResponse) {
        if (commonResponse != null && commonResponse.statusCode == 200) {
          NavigatorUtils.moveToLoginOTPValidationScreen(
              context, countryCode, mobileNumber);
        } else {
          ToastUtils.show("Some error in sending the OTP. Please try later");
        }
      }).catchError((error) {
        ToastUtils.show("Some error in sending the OTP. Please try later");
      });

      //onSimpleLogin();
    } else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      print("Validation Error");
    }*/
  }

  Widget termsAndCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: CustomWidget.getText(
            "By continuing, I accept the ",
            style:
                Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 0,
          child: GestureDetector(
            child: CustomWidget.getText(
              Strings.termsAndCondition,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              NavigatorUtils.navigateToWebPage(context,
                  Strings.termsAndCondition, Strings.termsAndConditionUrl);
            },
          ),
        ),
      ],
    );
  }

  Widget _mainPart() {
    return Container(
      padding:
          EdgeInsets.only(top: 50.0, left: 42.0, right: 42.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomWidget.getText(Strings.mobileVerification,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: ColorUtils.blackColor.withOpacity(0.9),fontSize: 22.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          SizedBox(
            height: 30.0,
          ),
          CustomWidget.getText(
            Strings.enterYourPhoneNumberToRecieveThe,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 14.0,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30.0,
          ),
          textFieldForNumber(),
          SizedBox(
            height: 30.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.topCenter,
                  height: 60.0,
                  child: Icon(Icons.lock,color: Color(0xffA3A3A3),size: 22.0,),
                ),
                flex: 1,
              ),
              Expanded(
                flex: 9,
                child: Container(
                  height: 60.0,
                  alignment: Alignment.topLeft,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomWidget.getText(
                        Strings.yourNumberIsSafeAndWontBeSharedAnywhere,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(fontSize: 14.0, color: Color(0xffA3A3A3)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40.0,
          ),
          CustomWidget.getRaisedBtn(context, Strings.next,
              onPressed: mobileNumber != null && mobileNumber.length > 5
                  ? () {
                      validateFormAndSave();
                    }
                  : null,
              disableColor: ColorUtils.buttonDisabledBackgroundColor,
              disableTextColor: Colors.white),
          SizedBox(
            height: 20.0,
          ),
          termsAndCondition(),
        ],
      ),
    );
  }

  Widget textFieldForNumber() {
    return Center(
      child: Theme(
        data: Theme.of(context).copyWith(
            primaryColor: ColorUtils.iconGreyColor,
            indicatorColor: ColorUtils.iconGreyColor,
          ),
        child: TextField(
          cursorColor: ColorUtils.primaryColor,
          cursorWidth: 1.0,
          controller: _controllerMobileNumber,
          style: Theme.of(context).textTheme.title,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 8.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB8B8B8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB8B8B8)),
              ),
              prefixIcon: InkWell(
                onTap: () async {
                  try {
                    var countryData = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    SelectCountry()))
                        as MetaDataCountryResponseDataCommon;
                    _setSelectedCountryData(countryData);
                  } catch (e) {}
                },
                child: Padding(
                  padding: const EdgeInsets.only(right :8.0),
                  child: Container(
                   // color: Colors.purple,
                    width: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0)),
                        color: Color(0xffF8F8F8),
                        border: Border.all(color: Color(0xffB8B8B8))),
                    child: Center(
                        child: CustomWidget.getText(_getCountryCode(),
                            style: Theme.of(context).textTheme.title)),
                  ),
                ),
              ),
              hintText: Strings.enterYourNumber,
              hintStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: ColorUtils.hintTextColor,)),
          onChanged: (String value) {
            setState(() {
              mobileNumber = value;
            });
          },
        ),
      ),
    );
  }

  String _getCountryCode() {
    return "+${(metaDataCountryResponseDataCommon?.diallingCode ?? "")}";
  }

  Widget getAppBar() {
    Widget appBar;
    if (widget._isNeedToFinish) {
      appBar = CustomAppBar().getAppBar(
        context: context,
        leadingIcon: Icons.clear,
        iconSize: 28.0,
        elevation: 0.0

      );
    } else {
      appBar = PreferredSize(
          child: Container(), preferredSize: Size.fromHeight(0.0));
    }
    return appBar;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: getAppBar(),
      body: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshot) {
            contextForLoginHandler = context;
            return ListView(
              children: <Widget>[_mainPart()],
            );
          }),
    );
  }

  onSimpleLogin() async {
    try {
      AnalyticsUtils?.analyticsUtils?.loginInSimpleButtonClicked();

      // LoginResponse parsedResponse = await ApiHandler.doSimpleLogin(context, _mobileNumber);
      // handleLoginResponse(parsedResponse);
    } catch (e) {
      print("Munish Thakur -> onSimpleLogin() -> ${e.toString()}");
    }
  }

  void handleLoginResponse(LoginResponse parsedResponse) {
    BuildContext buildContext = context;
    if (contextForLoginHandler != null) {
      buildContext = contextForLoginHandler;
    }
    accountBloc.handleMobileLoginResponse(buildContext);
  }
}
