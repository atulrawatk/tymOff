import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class ConfirmationPageForResetPassword extends StatefulWidget {
  @override
  _ConfirmationPageForResetPasswordState createState() => _ConfirmationPageForResetPasswordState();
}

class _ConfirmationPageForResetPasswordState extends State<ConfirmationPageForResetPassword> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: FractionalOffset.center,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle,size: 60.0,color: ColorUtils.pinkColor,),
            SizedBox(height: 20.0,),
            CustomWidget.getText("Password Successfully Changed!",
              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500,),textAlign: TextAlign.center),
            SizedBox(height: 10.0,),
            CustomWidget.getText("Please login to tymoff with your new password.",
                style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.w500,),textAlign: TextAlign.center),
            SizedBox(height: 16.0,),
            CustomWidget.getRaisedBtn(context, "Continue to Login",onPressed: (){
             NavigatorUtils.moveToDashBoard(context);
            },textColor: ColorUtils.pinkColor),
          ],
        ),
      ),
    );
  }
}
