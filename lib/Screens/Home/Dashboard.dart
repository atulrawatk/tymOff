import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/DynamicLinks/DynamicLinksUtils.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventAppThemeChanged.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/AppBar/FabBottomAppBarItem.dart';
import 'package:tymoff/Screens/AppBar/MyAppBar.dart';
import 'package:tymoff/Screens/DiscoverScreens/Discover.dart';
import 'package:tymoff/Screens/DiscoverScreens/Notifications.dart';
import 'package:tymoff/Screens/Home/HomePage.dart';
import 'package:tymoff/Screens/ProfileScreen/ProfilePage.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilDraftUpload.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilServerSyncUpload.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';
import 'package:tymoff/Utils/NotificationUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

import '../../main.dart';

MetaDataCountryResponseDataCommon metaDataCountryResponseDataCommon;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive {
    return true;
  }

  AccountBloc _accountBloc;

  bool isOpened = false;
  int _tabSelected = 0;

  //SocialLoginUtils socialLoginUtils;
  final _scaffoldKeyLogin = GlobalKey<ScaffoldState>();

  static const List<IconData> icons = const [Icons.settings, Icons.local_bar];

  bool _screenInitializationCompleted = false;

  @override
  initState() {
    super.initState();

    AppUtils.configApp();

    ApiHandler.getMetaData(context);

    triggerObservers();

    _getIpAndCountryCode();
  }

  @override
  void didChangeDependencies() {
    if (!_screenInitializationCompleted) {
      _screenInitializationCompleted = true;
      _accountBloc = ApplicationBlocProvider.ofAccountBloc(context);

      _initializeDynamicLinks();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _appLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;

      print("Munish Thakur -> Dashboard state change to -> $_appLifecycleState");
      _checkIfAnyContentForUploadAvailable();
      /*
      if (_appLifecycleState == AppLifecycleState.resumed) {
        _checkIfAnyContentForUploadAvailable();
      }*/
    });
  }

  int draftContentCount = 0;
  int syncContentCount = 0;

  void _checkIfAnyContentForUploadAvailable() {
    SharedPrefUtilDraftUpload.getDraftUploadContent()?.then((_draftContent) {
      draftContentCount = _draftContent?.data?.length ?? 0;
      AppUtils.refreshCurrentState(this);
    });

    SharedPrefUtilServerSyncUpload.getServerSyncUploadContent().then((_syncUploadContentRequestToServer) {
      syncContentCount = _syncUploadContentRequestToServer?.data?.length ?? 0;
      AppUtils.refreshCurrentState(this);
    });
  }

  void _getIpAndCountryCode() async {
    var ipCountryResponse = await ApiHandler.getIpResponse();

    if (ipCountryResponse != null) {
      var isoCode = ipCountryResponse.ccode;
      var countryData = await SharedPrefUtil.getCountryDataByIp(isoCode);
      print(
          "Munish Thakur -> _getIpAndCountryCode() -> ipCountryResponse -> ${ipCountryResponse.ccode} (+${ipCountryResponse.code})");
      if (countryData != null) {
        _setSelectedCountryData(countryData);
        print(
            "Munish Thakur -> _getIpAndCountryCode() -> countryData -> (+${countryData.diallingCode})");
      }
    }
  }

  _setSelectedCountryData(MetaDataCountryResponseDataCommon countryData) {
    metaDataCountryResponseDataCommon = countryData;
  }

  void triggerObservers() {
    WidgetsBinding.instance.addObserver(this);
    _setThemeChangeObserver();
    _checkAndSetWidgetTheme();
    _handleLoginDataObserver();
  }

  void _handleLoginDataObserver() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (mounted) {
        setState(() {
          if (loginResponse != null) {
            String userName = loginResponse?.data?.name;
            if (!(userName != null && userName.trim().length > 0)) {
              NavigatorUtils.moveToEditUserScreenLoginFlow(context);
            }
          } else {
            print("login response from shared pref is null");
          }
        });
      }
    });
  }

  void _initializeDynamicLinks() {
    dynamicLinksUtils = DynamicLinksUtils();
    dynamicLinksUtils.initDynamicLinks(context);
  }

  void handleLoginResponse(LoginResponse parsedResponse) {
    BuildContext buildContext = context;

    _accountBloc.handleLoginResponse(
      buildContext,
      parsedResponse,
      scaffoldKey: _scaffoldKeyLogin,
      otpVerificationFlow: OtpVerificationFlow.login,
      isNeedToFinish: false,
    );
  }

  void _setThemeChangeObserver() {
    eventBus.on<EventAppThemeChanged>().listen((event) {
      _checkAndSetWidgetTheme();
    });
  }

  void _checkAndSetWidgetTheme() {
    SharedPrefUtil.getTheme().then((s) {
      if (mounted) {
        PrintUtils.printLog("Munish -> getTheme() -> $s");
        setState(() {
          appTheme = s;
          PrintUtils.printLog('shared p called $s');
        });
      }
    });
  }

  void selectedTab(int index) {
    if (_tabSelected == index) {
      tabAlreadySelected(index);
    } else if (index == 2 || index == 3) {
      var isLoggedIn = _accountBloc.isUserLoggedIn(_stateOfAccountData);
      if (!isLoggedIn) {
        NavigatorUtils.moveToLoginScreen(context);
        moveToTab(_tabSelected);
      } else {
        moveToTab(index);
      }
    } else {
      moveToTab(index);
    }

    if (index == 1) {
      discoverPage.discoverShouldRefresh();
    }
  }

  void moveToTab(int index) {
    setState(() {
      _tabSelected = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 10), curve: Curves.ease);
    });
  }

  void tabAlreadySelected(int index) {

    if (index == 0) {
      homePage.scrollToTop();
    } else if (index == 3) {
      //NavigatorUtils.moveToEditUserScreenLoginFlow(context);
    }
  }

  Widget offlineBuilderWidget(Widget className) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Container(
            color: Colors.white70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cloud_off,
                  size: 60.0,
                  color: ColorUtils.primaryColor,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "No Connection",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Check your wifi or mobile data connection",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
          );
        }

        return child;
      },
      child: className,
    );
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  var homePage = HomePage();
  var discoverPage = Discover();

  StateOfAccount _stateOfAccountData;

  Widget buildPageView() {
    //PrintUtils.printLog("Munish -> Building PageView -> $_countHomeWidgetCreation");
    var widgetNotification = _accountBloc.isUserLoggedIn(_stateOfAccountData)
        ? offlineBuilderWidget(Notifications(appTheme))
        : NavigatorUtils.getLoginScreen(isNeedToFinish: false);
    var widgetProfile = _accountBloc.isUserLoggedIn(_stateOfAccountData)
        ? ProfilePage()
        : NavigatorUtils.getLoginScreen(isNeedToFinish: false);

    return PageView(
      physics: NeverScrollableScrollPhysics(),
      pageSnapping: false,
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        homePage,
        discoverPage,
        widgetNotification,
        widgetProfile,
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      _tabSelected = index;
    });
  }

  Color borderColor = Colors.red;

  void validateName(String value) {
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (value != null && (!nameExp.hasMatch(value) || value.isEmpty))
      borderColor = Colors.red;
    else
      borderColor = Colors.blue;
  }

  Icon actionIcon = new Icon(
    Icons.search,
  );
  Icon actionIcon1 = new Icon(Icons.arrow_back_ios);
  var iconUsed = false;

  String appTheme;

  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<StateOfAccount>(
        initialData: _accountBloc.getAccountState(),
        stream: _accountBloc.accountStateObservable,
        builder: (context, snapshotAccounts) {
          _stateOfAccountData = snapshotAccounts.data;
          return getMainDashboardWidget(context);
        });
  }

  Scaffold getMainDashboardWidget(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            // here the desired height
            child: MyAppBar().getAppBar(
              context: context,
              accountBloc: _accountBloc,
              stateOfAccount: _stateOfAccountData,
              appTheme: appTheme,
              countOfDraftContent: draftContentCount,
              countOfSyncContent: syncContentCount,
            )),
        body: buildPageView(),
        bottomNavigationBar: AnimatedContainer(
            color: ColorUtils.whiteColor,
            duration: Duration(milliseconds: 500),
            //height: _isVisible ? getHeight() : 0.0,
            child: FabBottomAppBar(
              selectedIndex: _tabSelected,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              color: Theme.of(context).iconTheme.color,
              selectedColor: Theme.of(context).selectedRowColor,
              onTabSelected: selectedTab,
              items: [
                FabBottomAppBarItem(
                    selectedAssetImage: "assets/home_filled_icon.png",
                    unselectedAssetImage: "assets/home_tymoff.png",
                    text: Strings.home),
                FabBottomAppBarItem(
                    selectedAssetImage: "assets/discover_filled_icon.png",
                    unselectedAssetImage: "assets/discover_tymoff.png",
                    text: Strings.discover),
                FabBottomAppBarItem(
                    selectedAssetImage: "assets/notification_filled_icon.png",
                    unselectedAssetImage: "assets/notification_tym.png",
                    text: Strings.notification1),
                _accountBloc.isUserLoggedIn(_stateOfAccountData)
                    ? FabBottomAppBarItem(
                        selectedAssetImage: "assets/profile_filled_icon.png",
                        unselectedAssetImage: "assets/tymoff_user.png",
                        text: Strings.me)
                    : FabBottomAppBarItem(
                        selectedAssetImage: "assets/profile_filled_icon.png",
                        unselectedAssetImage: "assets/tymoff_user.png",
                        text: Strings.me),
              ],
            )));
  }
}
