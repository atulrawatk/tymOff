import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/ProfilePullResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/ListOfItems.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

import 'EditProfile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  ContentBloc blocProfileContentMyPost;
  ContentBloc blocProfileContentLike;
  ContentBloc blocProfileContentMostLike;
  ContentBloc blocProfileContentComments;

  var _scrollViewController;

  List listOfContentTypeProfile = List<ProfileOption>();

  LoginResponse _profileGetResponse;
  LoginResponse _loginResponse = LoginResponse();

  @override
  void initState() {
    listOfContentTypeProfile = ListOfItems().listOfProfile;
    blocProfileContentMyPost =
        ContentBloc(contentListingType: ContentListingType.PROFILE, profileActionType: Constant.KEY_CONTENT_TYPE_UPLOAD);
    blocProfileContentLike =
        ContentBloc(contentListingType: ContentListingType.PROFILE, profileActionType: Constant.KEY_CONTENT_TYPE_LIKE);
    blocProfileContentMostLike =
        ContentBloc(contentListingType: ContentListingType.PROFILE, profileActionType: Constant.KEY_CONTENT_TYPE_FAVORITE);
    blocProfileContentComments =
        ContentBloc(contentListingType: ContentListingType.PROFILE, profileActionType: Constant.KEY_CONTENT_TYPE_COMMENT);
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    var loginResponse = await SharedPrefUtil.getLoginData();
    if(loginResponse != null){
      setState(() {
        this._loginResponse = loginResponse;
      });
    }
    print("isLogin Data found -> $loginResponse");
    hitProfile(context);
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return getOldMainWidget();
  }

  Widget widgetTabBar(BuildContext context) {
    Widget widgetTabBar = TabBar(
      indicatorWeight: 0.0,
      labelColor: ColorUtils.textSelectedColor,
      unselectedLabelColor: ColorUtils.textNonSelectedColor,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
          color: ColorUtils.buttonSelectedColor,
          borderRadius: BorderRadius.circular(2.0),
          border: new Border.all(color: ColorUtils.buttonSelectedColor)),
      tabs: [
        Tab(
          child: Container(
            width: 80.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                border:
                    new Border.all(color: ColorUtils.buttonNonSelectedColor)),
            child: CustomWidget.getText("My Post"),
          ),
        ),
        Tab(
          child: Container(
            width: 80.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                border:
                    new Border.all(color: ColorUtils.buttonNonSelectedColor)),
            child: CustomWidget.getText("Like"),
          ),
        ),
        Tab(
          child: Container(
            width: 80.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                border:
                    new Border.all(color: ColorUtils.buttonNonSelectedColor)),
            child: CustomWidget.getText("Most Like"),
          ),
        ),
        Tab(
          child: Container(
            width: 80.0,
            padding: EdgeInsets.only(left: 4.0, right: 4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                border:
                    new Border.all(color: ColorUtils.buttonNonSelectedColor)),
            child: CustomWidget.getText("Comment"),
          ),
        ),
      ],
    );

    return widgetTabBar;
  }

  TabBarView widgetTabBarViews() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          //color: ColorUtils.whiteColor,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ContentListing(
              blocContent: blocProfileContentMyPost, isDeleteEnabled: true,),
        ),
        Container(
          //color: ColorUtils.whiteColor,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ContentListing(
              blocContent: blocProfileContentLike),
        ),
        Container(
          //color: ColorUtils.whiteColor,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ContentListing(
            blocContent: blocProfileContentMostLike,
          ),
        ),
        Container(
          //color: ColorUtils.whiteColor,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ContentListing(
            blocContent: blocProfileContentComments,
          ),
        ),
      ],
    );
  }

  DefaultTabController getOldMainWidget() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: new NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).backgroundColor,
                expandedHeight: 150.0,
                primary: false,
                pinned: false,
                floating: true,
                forceElevated: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: 150.0,
                    child: topPart(),
                  ),
                ),
              ),
              new SliverAppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                floating: false,
                pinned: true,
                bottom: PreferredSize(
                    child: Container(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 12.0),
                      child: Container(
                        height: 30.0,
                        child: widgetTabBar(context),
                      ),
                    ),
                    preferredSize: Size(0.0, -10.0)),
              ),
            ];
          },
          body: widgetTabBarViews(),
        ),
      ),
    );
  }

  hitProfile(BuildContext context) async {
    var _profileGetResponse = await ApiHandler.getProfilePull(context);
    setState(() {
      this._profileGetResponse = _profileGetResponse;
    });
    print("Profile api hit successfully");
  }

  File imageFile;

  picker(BuildContext context) async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 2000.0, maxWidth: 2000.0);
    if (img != null) {
      setState(() {
        imageFile = img;
        print(img.path);
      });
    }
  }

  /*Widget _rowProfile(img, String text) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Image.asset(
            img,
            scale: 3.2,
            color: Theme.of(context).unselectedWidgetColor,
          ),
//        Icon(icon,color: Theme.of(context).unselectedWidgetColor,size: 17.0,),
          SizedBox(
            width: 5.0,
          ),
          CustomWidget.getText(text,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }*/

  Widget topPart() {
    return Container(
      height: 220.0,
      child: Column(
        children: <Widget>[
          rowProfileDetailTemp(),
          //rowBasicDetail(),
        ],
      ),
    );
  }

  Widget editSettingWidget() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: Container(
                color: Colors.transparent,
                height: 22.0,
                width: 50.0,
                margin: EdgeInsets.all(2.0),
                child: Image.asset(
                  "assets/edit_tym.png",
                  scale: 3.5,
                )),
            onTap: () {
              AnalyticsUtils?.analyticsUtils?.eventEditprofileButtonClicked();
              NavigatorUtils.moveToEditUserScreen(context);
            },
          ),
          InkWell(
            child: Container(
                color: Colors.transparent,
                height: 22.0,
                width: 50.0,
                margin: EdgeInsets.all(2.0),
                child: Image.asset(
                  "assets/settings_tym.png",
                  scale: 3.5,
                )),
            onTap: () {
              AnalyticsUtils?.analyticsUtils?.eventProfilesettingButtonClicked();
              NavigatorUtils.moveToSettingsScreen(context);
            },
          ),
        ],
      ),
    );
  }

  Widget profileImageUI() {
    return new Stack(
      children: <Widget>[
        imageFile == null
            ? new Center(
                child: GestureDetector(
                  child: new Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: ColorUtils.blackColor,
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Image.asset(
                      "assets/dummy_user_profile.png",
                      scale: 1.5,
                    ),
                  ),
                  onTap: () {
                    picker(context);
                  },
                ),
              )
            : Center(
                child: new Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      image: DecorationImage(
                          image: new ExactAssetImage(imageFile.path),
                          fit: BoxFit.fill)),
                ),
              ),
      ],
    );
  }

  Widget rowProfileDetailTemp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              profileImageUI(),
             /* SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Text(Substring(loginResponse?.data?.name),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.w400)),
              ),*/
              //SizedBox(width: 10.0),
             Padding(
               padding: const EdgeInsets.only(right:16.0),
               child: Row(
                 children: <Widget>[
                   InkWell(
                     child: Column(
                       children: <Widget>[
                         Image.asset(
                           "assets/edit_tym.png",
                           scale: 4.0,
                         ),
                         SizedBox(height: 8.0,),
                         CustomWidget.getText("Edit Profile",style: Theme.of(context).textTheme.body1),
                       ],
               ),
                     onTap: (){
                       NavigatorUtils.moveToEditUserScreen(context);
                     },
                   ),
                   SizedBox(width: 20.0,),

                   InkWell(
                     child: Column(
                       children: <Widget>[
                         Image.asset(
                           "assets/settings_tym.png",
                           scale: 4.0,
                         ),
                         SizedBox(height: 8.0,),
                         CustomWidget.getText("Settings",style: Theme.of(context).textTheme.body1),
                       ],
                     ),
                     onTap: (){
                       NavigatorUtils.moveToSettingsScreen(context);

                     },
                   ),

                 ],
               ),
             )
              //editSettingWidget(),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(FileUtils.capitalizeString(_profileGetResponse?.data?.name ?? _loginResponse?.data?.name),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 14.0,fontWeight: FontWeight.w400)),
        ),

        /* Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _rowProfile("assets/language48.png", "Finland"),
              _rowProfile("assets/country.png", "Bangladesh"),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _rowProfile(
                  "assets/phone.png",
                  (_profileGetResponse?.data?.phone != "" &&
                          _profileGetResponse?.data?.phone != null)
                      ? _profileGetResponse?.data?.phone ?? ""
                      : "9988776655"),
              _rowProfile("assets/location48.png", "fbd"),
            ],
          ),
        ),*/
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CustomWidget.getText( _profileGetResponse?.data?.email ??
              _loginResponse?.data?.email,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 12.0, fontWeight: FontWeight.w400)),
        ),
        SizedBox(
          height: 5.0,
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }

  Widget tabWidgetProfile(String text){
    return Tab(
      child: Container(
        width: 80.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            border: new Border.all(
                color: ColorUtils.buttonNonSelectedColor)),
        child: CustomWidget.getText(text),
      ),
    );
  }

  // TEMP CODE - Munish Thakur

  Scaffold getNewMainWidget1() {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).backgroundColor,
                expandedHeight: 180.0,
                primary: false,
                pinned: false,
                floating: false,
                forceElevated: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: 180.0,
                    child: topPart(),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorWeight: 0.0,
                    labelColor: ColorUtils.textSelectedColor,
                    unselectedLabelColor: ColorUtils.textNonSelectedColor,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        color: ColorUtils.buttonSelectedColor,
                        borderRadius: BorderRadius.circular(2.0),
                        border: new Border.all(
                            color: ColorUtils.buttonSelectedColor)),
                    tabs: [
                      tabWidgetProfile("My Post"),
                      tabWidgetProfile("Like"),
                      tabWidgetProfile("Most Share"),
                      tabWidgetProfile("Comment"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                //color: ColorUtils.whiteColor,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: ContentListing(
                    blocContent: blocProfileContentMyPost, isDeleteEnabled: true,),
              ),
              Container(
                //color: ColorUtils.whiteColor,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: ContentListing(
                    blocContent: blocProfileContentLike,),
              ),
              Container(
                //color: ColorUtils.whiteColor,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: ContentListing(
                  blocContent: blocProfileContentMostLike,
                ),
              ),
              Container(
                //color: ColorUtils.whiteColor,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: ContentListing(
                  blocContent: blocProfileContentComments,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold getNewMainWidget2() {
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Collapsing Toolbar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                )),
          ),
          SliverFillRemaining(
            child: Container(
              child: DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: PreferredSize(
                      child: AppBar(
                        backgroundColor: Theme.of(context).appBarTheme.color,
                        elevation: 1.0,
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
                        titleSpacing: 0.0,
                        title: CustomWidget.getText("Upload",
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 18.0)),
                        bottom: widgetTabBar(context),
                      ),
                      preferredSize: Size.fromHeight(88.0)),
                  body: widgetTabBarViews(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
