import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/ThemeBloc.dart';
import 'package:tymoff/Network/CustomHttpOverrides.dart';
import 'package:tymoff/Screens/Home/Dashboard.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

import 'BLOC/Blocs/DashboardBloc.dart';
import 'DynamicLinks/DynamicLinksUtils.dart';
import 'Network/Api/ApiHandlerCache.dart';
import 'ParentComponents/BaseState.dart';
import 'Utils/AnalyticsUtils.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
DynamicLinksUtils dynamicLinksUtils;

///
///With Crashlytics
///

//void main() => runApp(MyApp());

FlutterUploader appUploader;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Flutter Downloader
  await FlutterDownloader.initialize();

  HttpOverrides.global = CustomHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  appUploader = FlutterUploader();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.


  bool isInDebugMode = false;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);

      PrintUtils.printLog("-------------------   START (Munish Thakur -- Crashlytics) ------");
      PrintUtils.printLog("Stack -> ${details.stack.toString()}");
      PrintUtils.printLog("exception -> ${details.exception.toString()}");
      PrintUtils.printLog("-------------------   END (Munish Thakur -- Crashlytics) ------");

    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    await FlutterCrashlytics()
        .reportCrash(error, stackTrace, forceCrash: false);
  });
}

class MyApp extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  State createState() {
    AnalyticsUtils?.analyticsUtils?.logAppOpen();

    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  final _accountBloc = AccountBloc();
  final _dashboardBloc = DashboardBloc();
  ThemeBloc _themeBloc;

  SharedPrefUtil prefs;
  String themeName;

  @override
  void initState() {
    SharedPrefUtil.setAppUDID();

    WidgetsBinding.instance.addObserver(this);
    _themeBloc = ThemeBloc();
    SharedPrefUtil.getTheme().then((s) {
      themeName = s;
      if (s == null) _themeBloc.updateTheme(ThemeModel.getTheme(ThemeModel.THEME_LIGHT));
      setState(() {});
      _themeBloc.setTheme.add(ThemeModel.getTheme(themeName ?? ThemeModel.THEME_LIGHT));
    });

    super.initState();

    ApiHandlerCache.initialize();
    AnalyticsUtils().init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBlocProvider(
      accountBlocMain: _accountBloc,
      themeBloc: _themeBloc,
      dashboardBloc: _dashboardBloc,
      child: StreamBuilder<ThemeModel>(
        stream: _themeBloc.getTheme,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            return BaseState(
              child: MaterialApp(
                //title: 'Bloc Theme Dynamic',
                navigatorKey: MyApp.navKey,
                theme: snapshot.data.themeData,
                navigatorObservers: <NavigatorObserver>[AnalyticsUtils.observer],
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                routes: <String, WidgetBuilder>{
                  /// initial route is compulsory to give... Please change when Splash Screen added to project...
                   //'/': (context) => SplashScreen(),
                  //'/': (context) => MainCollapsingToolbar(),
                  //'/onboarding': (context) => MyOnBoardingPage(),
                  '/': (context) => Dashboard(),
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
