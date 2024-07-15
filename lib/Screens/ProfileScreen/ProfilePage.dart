import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListing.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/FileUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ContentBloc blocProfileContentProfile;

  ScrollController _scrollViewController;

  LoginResponse _loginResponse = LoginResponse();

  @override
  void initState() {
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    blocProfileContentProfile = ContentBloc(
      contentListingType: ContentListingType.PROFILE,
      profileActionType: Constant.KEY_CONTENT_TYPE_UPLOAD,
    );
    handleLoginData();
    super.didChangeDependencies();
  }

  String _imageFileUrl;

  void handleLoginData() {
    SharedPrefUtil.getLoginData().then((loginResponse) {
      if (mounted) {
        setState(() {
          if (loginResponse != null) {
            this._loginResponse = loginResponse;
            _imageFileUrl = loginResponse?.data?.picUrl;
          }
        });
      }
    });
  }

  var _isTitleVisibleWhenNotScrolling = false;
  var _titleMyPosts = "My Posts";

  Widget getTitle() {
    Widget titleContainerWidget = Container();
    if (_isTitleVisibleWhenNotScrolling) {
      titleContainerWidget = Container(
        margin: EdgeInsets.only(bottom: 6.0),
        child: CustomWidget.getText(_titleMyPosts,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 22.0, fontWeight: FontWeight.bold)),
      );
    } else {
      titleContainerWidget = Container(
        child: CustomWidget.getText(_titleMyPosts,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 12.0, fontWeight: FontWeight.w400)),
      );
    }

    return titleContainerWidget;
  }

  Widget build(BuildContext context) {
    super.build(context);

    return buildProfileUI_Temp();

    //return buildProfileUI_Main();
  }

  Widget buildProfileUI_Main() {
    return Scaffold(
      body: new NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[

            SliverList(delegate: SliverChildBuilderDelegate((context , int index){
              return topPart();
            }, childCount: 1))
          ];
        },
        body: ContentListing(
          blocContent: blocProfileContentProfile,
          //functionScrollListener: contentListingScrolledTo,
          isDeleteEnabled: true,
        ),
      ),
    );
  }

  Widget buildProfileUI_Temp() {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            topPart(),
            Expanded(
              child: NestedScrollView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                controller: _scrollViewController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[

                    SliverList(delegate: SliverChildBuilderDelegate((context , int index){
                      return Container();
                    }, childCount: 1))
                  ];
                },
                body: ContentListing(
                  blocContent: blocProfileContentProfile,
                  //functionScrollListener: contentListingScrolledTo,
                  isDeleteEnabled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topPart() {
    return Container(
      color: Theme.of(context).backgroundColor.withOpacity(0.4),
      height: 110.0,
      child: Column(
        children: <Widget>[
          rowProfileDetailTemp(),
        ],
      ),
    );
  }

  Widget profileImageUI() {
    return Container(
      child: Stack(
        children: <Widget>[
          (_imageFileUrl?.length ?? 0) > 0
              ? Center(
            child: InkWell(
              child: Container(
                width: 64.0,
                height: 64.0,
                decoration: new BoxDecoration(
                  border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.3),width: 0.5),
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new CachedNetworkImageProvider(_imageFileUrl),
                  ),
                ),
              ),
              onTap: () {
                NavigatorUtils.moveToProfileImageFullScreen(
                    context, _imageFileUrl);
              },
            ),
          )
              : Center(
            child: InkWell(
              child: Container(
                height: 64.0,
                width: 64.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorUtils.lightGreyColor.withOpacity(0.1),
                      width: 0.5),
                  color: ColorUtils.userPicBgColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/dummy_user_profile.png",
                      ),
                      fit: BoxFit.fill),
                ),
              ),
              onTap: () {
                NavigatorUtils.moveToEditUserScreen(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rowProfileDetailTemp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 0.0, top: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: profileImageUI(),
                flex: 0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding:
                            const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // color: Colors.green,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Visibility(
                                          visible: ((_loginResponse
                                              ?.data?.name?.length ??
                                              0) >
                                              0),
                                          child: SizedBox(
                                            height: 20.0,
                                            child: CustomWidget.getText(
                                                FileUtils.capitalizeString(_loginResponse?.data?.name),
                                                overflow: TextOverflow.ellipsis,
                                                //maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                          ),
                                        ),
                                        CustomWidget.getText(
                                            _loginResponse?.data?.phone ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(
                                                fontSize: 12.0,
                                                fontWeight:
                                                FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                  flex: 3,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 0.0),
                                    color: Colors.transparent,
                                    alignment: (Alignment.centerLeft),
                                    height: 40.0,
                                    //width: 24.0,
                                    child: Image.asset(
                                      "assets/edit_tym.png",
                                      scale: 3.0,
                                    ),
                                  ),
                                  flex: 2,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            NavigatorUtils.moveToEditUserScreen(context);
                          },
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          child: Container(
                              height: 48.0,
                              color: Colors.transparent,
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 2.0),
                                child: Image.asset(
                                  "assets/settings_tym.png",
                                  scale: 2.0,
                                ),
                              )),
                          onTap: () {
                            NavigatorUtils.moveToSettingsScreen(context);
                          },
                        ),
                        flex: 0,
                      )
                    ],
                  ),
                ),
                flex: 3,
              )
              //editSettingWidget(),
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CustomWidget.getText("My Posts",
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w400)),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}