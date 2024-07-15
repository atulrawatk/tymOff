import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Screens/Account/ConfirmationPageForResetPassword.dart';
import 'package:tymoff/Screens/Account/EnterOtp.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ValidationUtil.dart';

class EnterNewPassword extends StatefulWidget {
  String email;
  String enteredOtp;
  EnterNewPassword(this.email,this.enteredOtp);

  @override
  _EnterNewPasswordState createState() => _EnterNewPasswordState(this.email,this.enteredOtp);
}

class _EnterNewPasswordState extends State<EnterNewPassword> {

  String email;
  String enteredOtp;

  _EnterNewPasswordState(this.email, this.enteredOtp);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  validateFormAndSave() {
    print("Validating Form...");
    if (formKey.currentState.validate()) {
      print("Validation Successful");
      formKey.currentState.save();
      if(_enteredNewPassword == _enteredconfirmPassword){
        hitResetPasswordApi();
      }else{
        SnackBarUtil.show(_scaffoldKey, "Password didn't match");
      }
    } else {
      print("Validation Error");
    }
  }

  hitResetPasswordApi() async {
    var otpResponse = await ApiHandler.validateOTPEmail(context, email, enteredOtp,password:_enteredNewPassword);

    if (otpResponse.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ConfirmationPageForResetPassword()));
    } else {
      Navigator.of(context).pop();
    }
  }

  TextEditingController _newPasswordController = new TextEditingController();
  String _enteredNewPassword;
  TextEditingController _confirmPasswordController = new TextEditingController();
  String _enteredconfirmPassword;

  Widget _topPart() {
    return Container(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: 50.0, bottom: 50.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: SvgPicture.asset("assets/applogo.svg", height: 25.0,),
            ),
            SizedBox(height: 30.0,),
            CustomWidget.getText("Choose a new password",
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w500)
            ),
            SizedBox(height: 20.0,),

            Container(
                height: 42.0,
                color: Theme.of(context).secondaryHeaderColor,
                padding: EdgeInsets.only(left: 10.0),
                child: Center(
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration.collapsed(
                      hintText: Strings.newPassword,
                    ),
                      obscureText: true,
                    onSaved: (String value) => _enteredNewPassword = value.trim(),
                      validator: (value) {
                      if (value.isEmpty){
                        return Strings.pleaseEnterPassword;
                      }
                      if ((value?.length ?? 0) < 6){
                        return Strings.minsixCharacter;
                      }
                          ValidationUtil.isEmpty(value, Strings.newPassword);
                        }
                  ),
                )
            ),
            SizedBox(height: 16.0,),
            Container(
                height: 42.0,
                color: Theme.of(context).secondaryHeaderColor,
                padding: EdgeInsets.only(left: 10.0),
                child: Center(
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration.collapsed(
                      hintText: Strings.confirmPassword,
                    ), obscureText: true,
                    onSaved: (String value) => _enteredconfirmPassword = value.trim(),
                      validator: (value) =>
                          ValidationUtil.isEmpty(value, Strings.confirmPassword)

                  ),
                )
            ),
            SizedBox(height: 24.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomWidget.getRaisedBtn(
                    context, "Submit", textColor: Colors.white,
                    onPressed: validateFormAndSave
                ),
              ],
            ),
            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: CustomWidget.getText("Back ",
                      style: Theme
                          .of(context)
                          .textTheme
                          .title
                          .copyWith(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context,
              int index) {
            return _topPart();
          }, childCount: 1),
          ),
        ],
      ),
    );
  }
}
