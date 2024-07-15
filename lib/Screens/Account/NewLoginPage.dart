import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class NewLoginPage extends StatefulWidget {
  @override
  _NewLoginPageState createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {

  TextEditingController _phoneNumberController = new TextEditingController();
  var _prefixCountryCode = "+91";
  String mobileNumber ;
/*
  Widget getTextFieldForNumber(TextEditingController controller,
      {String prefixText, onChange, Widget suffixWidget}) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorUtils.iconGreyColor,
        indicatorColor: ColorUtils.iconGreyColor,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(4.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              )),
          prefixText: prefixText,
          prefixStyle: TextStyle(color: Colors.blue),
          suffix: suffixWidget,
        ),
        onChanged: onChange,
      ),
    );
  }*/

  Widget textFieldForNumber(){
    return Center(
      child: TextField(
        style: TextStyle( fontSize:18.0 ),
           keyboardType: TextInputType.phone,
           decoration: InputDecoration(
             contentPadding: EdgeInsets.only(top:8.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffB8B8B8)),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffB8B8B8)),
      ),
      prefixIcon: Container(
        width: 45.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0)),
            color: Color(0xffF8F8F8),
          border: Border.all(color: Color(0xffB8B8B8))
        ),
        child: Center(
            child: Text(_prefixCountryCode,
              style: TextStyle(fontSize: 16.0))),
      ),
             hintText: "Enter your number",
             hintStyle: TextStyle(color: Color(0xffA3A3A3))
           ),
        onChanged: (String value){
          mobileNumber = value;
        },
      ),
    );
  }


  Widget topPartText(){
    return Column(
      children: <Widget>[
        Text(Strings.mobileVerification , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.w500),),
        SizedBox(height: 16.0,),
        Text(Strings.enterYourPhoneNumberToRecieveThe, style: TextStyle(fontSize: 14.0 ,) , textAlign: TextAlign.center,),
        SizedBox(
          height: 30.0,
        ),

//        GestureDetector(
//          child: Container(
//              color: Colors.transparent,
//              child: IgnorePointer(
//                child: Center(child: getTextFieldForNumber(_phoneNumberController,prefixText: "($_prefixCountryCode)  ")),
//              )),
//          onTap: () {
//            ToastUtils.show("Sorry! You can't edit phone number.");
//          },
//        ),
      ],
    );
  }

  Widget middleText(){
    return Row(
      children: <Widget>[
//        Icon(Icons.lock , color: Colors.grey[300],),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
            Text(Strings.yourNumberIsSafeAndWontBeSharedAnywhere,
              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14.0 ,color: Color(0xffA3A3A3)),
              textAlign: TextAlign.center,),
            ],
          ),
        ),
      ],
    );
  }

  Widget buttonPart(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CustomWidget.getRaisedBtn(
            context,
            Strings.next,
            onPressed: mobileNumber!=null && mobileNumber!=""?(){}:null,
          disableColor: Color(0xffFFB4CE),
          disableTextColor: Colors.white

        ),
      ],
    );
  }

  Widget termsCondition(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex:0,
          child: CustomWidget.getText("By continuing, I accept the ",
            style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12.0),
            textAlign: TextAlign.center,),),
        Expanded(
          flex: 0,
          child: GestureDetector(
            child: CustomWidget.getText(Strings.termsAndCondition,
              style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.w500,fontSize: 12.0),
              textAlign: TextAlign.center,),
            onTap: (){
              NavigatorUtils.navigateToWebPage(context, Strings.termsAndCondition,
                  Strings.termsAndConditionUrl);
            },
          ),
        ),
      ],
    );
  }



  Widget mainPart(){
    return Container(
      padding: EdgeInsets.only(top: 50.0, left: 30.0 , right: 30.0 , bottom: 10.0),
      child: Column(
        children: <Widget>[
          topPartText(),
          textFieldForNumber(),
          SizedBox(height: 30.0,),
          middleText(),
        SizedBox(height: 40.0,),
          buttonPart(),
          SizedBox(height: 20.0,),
          termsCondition(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(delegate: SliverChildBuilderDelegate((context , int index){
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  mainPart()
                ]);
          }, childCount: 1))
        ],
      ),
    );
  }
}
