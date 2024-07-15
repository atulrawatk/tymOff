import 'package:flutter/material.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class EmptyNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(),
              flex: 2,
            ),

            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/no_notification_bell.png",/*color: ColorUtils.iconGreyColor.withOpacity(0.5),*/scale: 2.4,),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    alignment: Alignment.center,
                    child: CustomWidget.getText("You have no new notifications yet",
                        style: Theme.of(context).textTheme.subtitle,textAlign: TextAlign.center , fontSize: 18),
                  ),
                ],
              ),
              flex: 4,
            ),

          ],
        ),
    );
  }
}
