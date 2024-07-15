import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ThemeBloc.dart';

import 'ThemeModel.dart';

class TymOffTextTheme extends TextTheme{

 /* TymOffTextTheme() : super(

    body1 : new TextStyle(  color:Colors.red ,fontSize: 16.0,fontWeight: FontWeight.w200),

  );*/

  ThemeBloc themeBloc;
  String _theme ="";

 TymOffTextTheme(){
   themeBloc = ThemeBloc();
 }

 @override
 TextTheme copyWith(
     {TextStyle display4, TextStyle display3, TextStyle display2, TextStyle display1, TextStyle headline, TextStyle title, TextStyle subhead, TextStyle body2, TextStyle body1, TextStyle caption, TextStyle button, TextStyle subtitle, TextStyle overline}) {
   return TextTheme(
     body1: _theme == ThemeModel.THEME_LIGHT ? TextStyle(color: Colors.brown) : TextStyle(color: Colors.pink),
     body2: _theme == ThemeModel.THEME_LIGHT ? TextStyle(color: Colors.brown) : TextStyle(color: Colors.pink,fontSize: 16.0),


   );
 }


}
