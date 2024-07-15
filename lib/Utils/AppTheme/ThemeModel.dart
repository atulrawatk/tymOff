import 'package:flutter/material.dart';
import 'package:tymoff/Utils/AppTheme/TymTextThemeTemp.dart';
import 'package:tymoff/Utils/ColorUtils.dart';

class ThemeModel {
  static final String THEME_LIGHT = "light";
  static final String THEME_DARK = "dark";

  final ThemeData themeData;
  final String name;

  const ThemeModel({this.name, this.themeData});

  static ThemeModel getTheme(String name) {
    if (name == THEME_LIGHT) {
      return ThemeModel(
          name: THEME_LIGHT,
          themeData: ThemeData(
            brightness: Brightness.light,
            accentColor: ColorUtils.blackColor,
            primaryColor: ColorUtils.whiteColor,
            buttonColor: Colors.yellow,
            textSelectionColor: ColorUtils.textSelectedColor,
            textTheme: TextTheme(
              body1: TextStyle(color: ColorUtils.blackColor,fontSize: 12.0,fontWeight: FontWeight.normal),
              body2: TextStyle(color: ColorUtils.subtitleTextColor, fontSize: 10.0,fontWeight: FontWeight.normal),
              display1: TextStyle(color: ColorUtils.subtitleTextColor, fontSize: 10.0,fontWeight: FontWeight.normal),
              display2: TextStyle(color: ColorUtils.textSelectedColor, fontSize: 16.0,fontWeight: FontWeight.w500),
              title: TextStyle(color: ColorUtils.blackColor,fontSize: 16.0,fontWeight: FontWeight.normal),
              subtitle: TextStyle(color: ColorUtils.subtitleTextColor,fontSize: 14.0,fontWeight: FontWeight.normal),
              headline: TextStyle(color: ColorUtils.subtitleTextColor,fontSize: 16.0,fontWeight: FontWeight.normal),

            ),
            bottomAppBarColor: ColorUtils.whiteColor.withOpacity(1.0),
            iconTheme: IconThemeData(
                color: ColorUtils.iconColors
            ),

              appBarTheme: AppBarTheme(
                  color: ColorUtils.appBarColor,
                elevation: 0.4,

              ),
            secondaryHeaderColor: ColorUtils.buttonNonSelectedBgColor,
            backgroundColor: ColorUtils.whiteColor,
            //dividerColor: ColorUtils.dividerColor,
            unselectedWidgetColor: ColorUtils.iconDetailScreenColor,
            selectedRowColor: ColorUtils.pinkColor,
            cardColor: ColorUtils.whiteColor,
            dialogBackgroundColor: ColorUtils.whiteColor,
            cursorColor: ColorUtils.greyColor
          ));
    } else {
      return ThemeModel(
          name: THEME_DARK,
          themeData: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.white,
            fontFamily: 'Ubuntu',
            primaryColor: Colors.black,
            buttonColor: Colors.red,
          textTheme: TextTheme(
              body1: TextStyle(color: ColorUtils.whiteColor,fontSize: 12.0,fontWeight: FontWeight.normal),
              body2: TextStyle(color: ColorUtils.subtitleTextColor, fontSize: 10.0,fontWeight: FontWeight.normal),
              title: TextStyle(color: ColorUtils.whiteColor,fontSize: 16.0,fontWeight: FontWeight.normal),
              display1: TextStyle(color: ColorUtils.whiteColor, fontSize: 10.0,fontWeight: FontWeight.normal),
              display2: TextStyle(color: ColorUtils.whiteColor, fontSize: 16.0,fontWeight: FontWeight.w500),
              subtitle: TextStyle(color: ColorUtils.subtitleTextColor,fontSize: 14.0,fontWeight: FontWeight.normal),
          ),
            iconTheme: IconThemeData(
                color: ColorUtils.iconGreyColor
            ),
          appBarTheme: AppBarTheme(
            color: ColorUtils.bottomAppBarDarkColor,
            elevation: 0.4,

          ),
          secondaryHeaderColor: ColorUtils.iconGreyColor,
          bottomAppBarColor: ColorUtils.bottomAppBarDarkColor,
          backgroundColor: ColorUtils.backgroundColorDark,
          dividerColor: ColorUtils.dividerColor,
          unselectedWidgetColor: ColorUtils.iconGreyColor,
          selectedRowColor: ColorUtils.whiteColor,
          cardColor: ColorUtils.cardDarkColor,
          dialogBackgroundColor: ColorUtils.backgroundColorDark,
          cursorColor: ColorUtils.whiteColor
          ));
    }
  }
}