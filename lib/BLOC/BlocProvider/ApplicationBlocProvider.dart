import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/DashboardBloc.dart';
import 'package:tymoff/BLOC/Blocs/ThemeBloc.dart';

class ApplicationBlocProvider extends InheritedWidget {

  final Widget child;
  final AccountBloc accountBlocMain;
  final ThemeBloc themeBloc;
  final DashboardBloc dashboardBloc;

  ApplicationBlocProvider(
      {
        this.accountBlocMain,
        this.themeBloc,
        this.child,
        this.dashboardBloc,
      }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AccountBloc ofAccountBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationBlocProvider)
      as ApplicationBlocProvider)
          .accountBlocMain;

  static ThemeBloc ofThemeBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationBlocProvider)
      as ApplicationBlocProvider)
          .themeBloc;

  static DashboardBloc ofDashboardBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationBlocProvider)
      as ApplicationBlocProvider)
          .dashboardBloc;
}