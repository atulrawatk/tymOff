import 'package:flutter/material.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/FeedbackRequest.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

class SubmitFeedback extends StatefulWidget {
  @override
  _SubmitFeedbackState createState() => _SubmitFeedbackState();
}
class _SubmitFeedbackState extends State<SubmitFeedback> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController _controllerdescription;
  TextEditingController _controllersubject;
  String subject;
  String title;
  String description;


  hitPutFeedbackProfile(BuildContext context)async{
    FeedbackRequest  feedbackRequest = FeedbackRequest(subject: "subject",title: title,description: description);
    var feedbackResponse = await  ApiHandler.putFeedback(context, feedbackRequest);
    if(feedbackResponse.statusCode== 200){
      var _alertDialog = getAlertDialog(context);
      if (_alertDialog != null) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => _alertDialog,
        );
      }
    }
    else{
      print("Error in Feedback hit api.");
    }
  }
  validateFormAndSave() {
    print("Validating Form...");

    if (formKey.currentState.validate()) {
      print("Validation Successful");
      formKey.currentState.save();
      hitPutFeedbackProfile(context);
    } else {
      print("Validation Error");
    }
  }

  AlertDialog getAlertDialog(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))
      ),
//      title: Text("Submitted"),
      content: contentOfDialog(),  /*CustomWidget.getText("Feedback Submited",textColor: Theme.of(context).unselectedWidgetColor),*/
      actions: [
        CustomWidget.getFlatBtn(context, "Ok",textColor: ColorUtils.pinkColor,
            onPressed: ()async{
              await new Future.delayed(const Duration(milliseconds: 200));
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget contentOfDialog(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomWidget.getText(Strings.feedbackSubmitDialogTitle,style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w400,color: ColorUtils.greyColor)),
      ],
    );
  }

  Widget _mainPart() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0,bottom: 50.0),
      child: Form(
        key: this.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Column(
              children: <Widget>[
                Container(
                  height: 42.0,
                  color: Theme.of(context).secondaryHeaderColor,
                  padding: EdgeInsets.only(left: 10.0),
                  child: Center(
                    child:TextFormField(
                     style: Theme.of(context).textTheme.title,
                      decoration: new InputDecoration.collapsed(hintText: "Add title",),
                      controller: _controllerdescription,
                     onSaved: (String value) => title = value,
                        validator: (value) =>
                            value.isEmpty?Strings.fieldCanNotBeBlank:null,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: <Widget>[
                Container(
                    height: 150.0,
                    color: Theme.of(context).secondaryHeaderColor,
                    padding: EdgeInsets.only(left: 10.0,top: 10.0),
                    child: TextFormField(

                        maxLines: null,
                          decoration: new InputDecoration.collapsed(hintText: "Write your feedback"),
                          controller: _controllersubject,
                        onSaved: (String value) => description = value,
                          validator: (value) =>
                              value.isEmpty?Strings.fieldCanNotBeBlank:null,
                   ),
                ),
              ],
            ),
            SizedBox(
              height: 14.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomWidget.getRaisedBtn(context, Strings.submit, textColor: ColorUtils.whiteColor, onPressed: () {
                  AnalyticsUtils?.analyticsUtils?.eventFeedbackSubmitButtonClicked();
                      validateFormAndSave();
                    }),
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
      backgroundColor: Theme.of(context).appBarTheme.color,
      key: _scaffoldKey,
      appBar: CustomAppBar().getAppBar(
        context: context,
        title: Strings.feedback,
        leadingIcon: Icons.clear,
        iconSize: 24.0,
      ),
      body:CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index){
            return _mainPart();
          },childCount: 1),
        ),
      ],
     ),
    );
  }
}
