import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadContentScreen.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';

class UploadAppBar extends AppBar{

  Widget getAppBar(
      {Key key,
        String title,
        BuildContext context,
        AccountBloc accountBloc,
        StateOfAccount stateOfAccount,
        String appTheme,
        onTapNextButton
      }) {
    return PreferredSize(
      child: AppBar(
        elevation: 1.0,
        titleSpacing: 0.0,
        leading: GestureDetector(
          child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).accentColor,
                size: 20.0,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              color: Colors.transparent,
              width: 70.0,
              alignment: Alignment.center,
              child: CustomWidget.getText(Strings.next,
                  style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.primaryColor,fontWeight: FontWeight.normal)),
            ),
            onTap: onTapNextButton
          ),
        ],
        title: CustomWidget.getText(title,
            style: Theme.of(context)
                .textTheme
                .title),
      ),
      preferredSize: Size.fromHeight(48.0),
    );
  }
}