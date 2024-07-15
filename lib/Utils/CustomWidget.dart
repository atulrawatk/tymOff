 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:numberpicker/numberpicker.dart';

import 'NavigatorUtils.dart';

 import 'package:tymoff/Utils/PrintUtils.dart';

class CustomWidget {


  static Widget getRaisedBtn(BuildContext context, String text,
      {onPressed,Color textColor = Colors.white, Color disableColor , Color disableTextColor}) {

    return new RaisedButton(
      color: ColorUtils.primaryColor,      /* Theme
          .of(context)
          .primaryColor,*/
      textColor: Colors.white,
      disabledColor: disableColor,
      disabledTextColor: disableTextColor,
      elevation: 4.0,
      splashColor: ColorUtils.primaryColor,
      child: new Text(text, style: new TextStyle(fontSize: 16.0),),
      padding: const EdgeInsets.all(12.0),
      onPressed: onPressed,
    );
  }

  static Widget getHtmlText(BuildContext context, String text, {TextStyle style}) {
    if(text == null) {
      text = "";
    }

    // TEMP CODE - MUNISH THAKUR
/*

    text = "$text<a href='www.google.com'>Google Link</a>";

    for(int index = 0 ; index < 200; index++) {
      text = "$text<br>Hello $index,";
    }
*/

    return GestureDetector(
      child: new Html(data: text, defaultTextStyle: style,
        onLinkTap: (url) {
          NavigatorUtils.navigateToWebPage(context, "", url);
        },
        onImageTap: (src) {
          PrintUtils.printLog(src);
        },),
      onLongPress: (){
        Clipboard.setData(new ClipboardData(
            text: text));
      },
    );
  }

  static Widget getRoundedRaisedButton(BuildContext context, String text,
      {onPressed,Color textColor = Colors.white,FontWeight fontWeight = FontWeight.normal}) {
    return RaisedButton(
        onPressed: onPressed,
        child: CustomWidget.getText(text,textColor: textColor,fontSize: 16.0,fontWeight: fontWeight),
        color: ColorUtils.whiteColor,
        elevation: 10.0,
        highlightColor: Colors.green,
          padding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0),side:BorderSide(color: Color(0xFFFEEBF1))),

      );
  }

  static Widget getFlatBtn(BuildContext context, String text, {TextStyle style,onPressed,Color textColor}) {
    return new FlatButton(
      textColor: textColor,
      onPressed: onPressed,
      padding: EdgeInsets.all(0.0),
      child: new Text(text, style:style));
  }

  static Widget getTextField(BuildContext context,TextEditingController controller, String label,
      String hintText, {String prefixText,bool isPass = false,onChange}) {
    return Theme(
        data: Theme.of(context).copyWith(
            primaryColor: ColorUtils.iconGreyColor,
            indicatorColor: ColorUtils.iconGreyColor,
            hintColor: ColorUtils.iconGreyColor
        ),
        child: new TextField(
          style: TextStyle(
            fontSize: 18.0
          ),
          controller: controller,
          obscureText: isPass,
          decoration: new InputDecoration(
             border:  UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey,
                      width: 1.0,
                    ),
                ),

              contentPadding: EdgeInsets.only(left :2.0,bottom: 2.0),
              labelText: label,
              suffixText: prefixText,
              labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0
              ),
              hintText: hintText
          ),
          onChanged: (value){onChange(value);},
        ),
    );
  }
  static Widget getTextFormField(BuildContext context,{TextEditingController controller,String labelText, FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,bool isPass = false,TextInputType keyboardType: TextInputType.text,}) {
    return   Column(
      children: <Widget>[
        Theme(data: Theme.of(context).copyWith(
          primaryColor: Colors.black,
          //cursorColor:Colors.white,
          hintColor: Colors.grey[400],
          //accentColor: Colors.white,
        ), child:  TextFormField(
          controller: controller,
          onSaved: onSaved,
          obscureText: isPass,
          validator: validator,
          keyboardType: keyboardType,
          decoration:  InputDecoration(
           /* border:  UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white
                )
            ),*/
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: new EdgeInsets.all(10.0),
          ),
        ),
        ),
        // CustomWidget.dividerWhite,
      ],
    );
  }


  static Widget getText(String text, {TextStyle style, FontWeight fontWeight = FontWeight.normal, Color textColor = const Color(0xFF3A3A3A),
    double fontSize=16.0,TextAlign textAlign = TextAlign.start,TextOverflow overflow}) {

    return new Text(
      text != null ? text : "",
      overflow: overflow,
      style: style,
      textAlign: textAlign,
    );
  }

  static Widget getText1(String text,{TextStyle style,FontWeight fontWeight = FontWeight.normal,Color textColor = const Color(0xFF3A3A3A),
    double fontSize=16.0,TextAlign textAlign = TextAlign.start,TextOverflow overflow ,IntrinsicHeight height }) {
    return new Text(
      text != null ? text : "",
      overflow: overflow,
      style: style,
      textAlign: textAlign,


    );
  }

  static Widget getTextTemp(String text,{TextStyle style}) {
    return new Text(
        text != null ? text : "",
      style: style,

    );
  }

  static Widget getDrawerItemText(String text,{FontWeight fontWeight = FontWeight.normal,Color textColor = Colors.white,double fontSize=16.0,TextAlign textAlign = TextAlign.start,onTap}) {
    return GestureDetector(
      child: new Text(
        text,
        style: new TextStyle(
          fontSize: fontSize,

          fontWeight: fontWeight,
          color: textColor,
        ),
        textAlign: textAlign,
      ),
      onTap: onTap ,
    );
  }

  static Widget commonUi(String title,String value,{onTap}) => GestureDetector(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomWidget.getText(title),
        CustomWidget.getText(value,textColor: ColorUtils.greyColor,fontSize: 14.0),
      ],
    ),
    onTap : onTap,
  );

  static Widget commonReminderUi(String value,{onTap}) => GestureDetector(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomWidget.getText(value),
        SizedBox(width: 4.0,),
        Icon(Icons.arrow_drop_down,color: ColorUtils.greyColor,),
      ],
    ),
    onTap : onTap,
  );

 static void showReportContentDialog(BuildContext context) {
   NavigatorUtils.moveToLoginScreen(context);
  }


  static Widget getBottomNavigationBar (String text, {onTap}) {
    return GestureDetector(
      child: BottomAppBar(
          color:Color(0xfFFEA3C78),
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 42.0,
          child: Center(
              child:Text(text,style: TextStyle(fontSize:16.0,color: Colors.white,fontWeight: FontWeight.w500),)
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}