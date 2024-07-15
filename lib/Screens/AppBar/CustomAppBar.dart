import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class CustomAppBar extends AppBar {

  static Widget getLogoWidget(String appTheme) {
    return appTheme != null && appTheme == ThemeModel.THEME_DARK ? SvgPicture.asset("assets/tymoff_dark_theme_logo.svg",height: 25.0,color: ColorUtils.whiteColor,)
        :SvgPicture.asset("assets/applogo.svg",
      height: 25.0,
    );
  }

  Widget getAppBar(
      {Key key,
        BuildContext context,
        String title = "",
        IconData leadingIcon,
        double iconSize = 20.0,
        double elevation = 1.0,
        List<Widget> actionWidget,
      }) {

    return PreferredSize(
      child: AppBar(
        elevation: elevation,
        titleSpacing: 0.0,
        leading: GestureDetector(
          child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                leadingIcon,
                color: Theme.of(context).accentColor.withOpacity(0.9),
                size: iconSize,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: CustomWidget.getText(title,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: 18.0)),
          actions: actionWidget
      ),

      preferredSize: Size.fromHeight(48.0),
    );
  }

}