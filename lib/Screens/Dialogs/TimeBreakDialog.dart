import 'package:flutter/material.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
class TimeBreakDialog extends StatefulWidget {
  @override
  _TimeBreakDialogState createState() => _TimeBreakDialogState();
}

class _TimeBreakDialogState extends State<TimeBreakDialog> {


  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Text('hello'),

            ],
          ),
          onTap: () {
           // Navigator.pop(context),
            _settingModalBottomSheet(context);          },
        )
    );
  }
  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top:14.0,bottom: 14.0,left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          CustomWidget.getText(Strings.remainder,fontSize: 19,textColor: Colors.black,fontWeight: FontWeight.w500),
                          Icon(Icons.clear,color: Colors.black38,size: 28,),
                        ],

                      ),
                    ),
                  ),




                  Image.asset("assets/children.png",scale: 2.0,),
                  SizedBox(height: 10.0,),

                  CustomWidget.getText('Time to Take a break ?',fontSize: 19,textColor: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: CustomWidget.getText(' you have been watching for 5 minutes.Adjust or turn off this remainder in settings',textAlign: TextAlign.center,fontSize: 16,textColor: Colors.black),
                  ),
                  SizedBox(height: 16.0,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomWidget.getFlatBtn(context, "SETTINGS",textColor: Colors.lightBlueAccent,
                      onPressed: (){}),
                      CustomWidget.getRaisedBtn(context, "DISMIIS",textColor:Colors.lightBlueAccent,
                      onPressed: (){}),
                    ],
                  ),


                ],




          );
        }
    );
  }


}
