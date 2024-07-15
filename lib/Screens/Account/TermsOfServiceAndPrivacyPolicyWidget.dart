import 'package:flutter/material.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/OpenWebView.dart';
import 'package:tymoff/Utils/Strings.dart';

class TermsOfServiceAndPrivacyPolicyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomWidget.getText("By continuing you agree to tymoff's ",
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0),
                  textAlign: TextAlign.center,),
              GestureDetector(
                child: CustomWidget.getText(Strings.termsOfService,
                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.w500,fontSize: 12.0),
                    textAlign: TextAlign.center,),
                onTap: (){
                  NavigatorUtils.navigateToWebPage(context, Strings.termsAndCondition,
                      Strings.termsAndConditionUrl);
                },
              ),
              CustomWidget.getText(" and ",
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0),
                  textAlign: TextAlign.center),
            ],
          ),
          SizedBox(height: 5.0,),

          GestureDetector(
            child: CustomWidget.getText(Strings.privacyPolicy,
                style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.w500,fontSize: 12.0),
                textAlign: TextAlign.center,),
            onTap: (){

              NavigatorUtils.navigateToWebPage(context,  Strings.privacyPolicy,
                  Strings.privacyPolicyUrl);
            },
          ),
        ],
      ),
    );
  }
}
