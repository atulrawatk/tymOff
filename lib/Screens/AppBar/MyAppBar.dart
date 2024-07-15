import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/Screens/Search/ContentSearchDelegate.dart';
import 'package:tymoff/Screens/UploadNewScreens/UploadBottomSheetUI.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/NavigatorUtils.dart';

class MyAppBar extends AppBar {
  static var searchDelegate = ContentSearchDelegate();

  static Widget getLogoWidget(String appTheme) {
    return appTheme != null && appTheme == ThemeModel.THEME_DARK
        ? SvgPicture.asset(
            "assets/tymoff_dark_theme_logo.svg",
            height: 25.0,
            color: ColorUtils.whiteColor,
          )
        : SvgPicture.asset(
            "assets/applogo.svg",
            height: 25.0,
          );
  }

  void dispose() {}

  AppBar getAppBar(
      {Key key,
      Widget title,
      BuildContext context,
      AccountBloc accountBloc,
      StateOfAccount stateOfAccount,
      String appTheme,
      int countOfDraftContent,
      int countOfSyncContent}) {
    return AppBar(
        key: key,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getLogoWidget(appTheme),
          ],
        ),
        //}),
        //backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0.0,
        actions: <Widget>[
          /*GestureDetector(
            child: Image.asset(
              "assets/upload_icon_1.gif",
              scale: 1.5,
            ),
            //child:Image.asset("assets/upload_black.png"
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => UploadingContentListing()));
            },
          ),*/

          GestureDetector(
            child: Image.asset(
              "assets/search.png",
              scale: 3.3,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              AnalyticsUtils?.analyticsUtils?.eventSearchButtonClicked();
              showSearch(context: context, delegate: searchDelegate);
            },
          ),
          GestureDetector(
            child: Image.asset(
              "assets/upload.png",
              scale: 3.3,
              color: Theme.of(context).iconTheme.color,
            ),
            //child:Image.asset("assets/upload_black.png"
            onTap: () {
              //moreOptionModalBottomSheet(context);
              AnalyticsUtils?.analyticsUtils?.eventUploadButtonClicked();
              if (accountBloc != null && stateOfAccount != null) {
                if (accountBloc.isUserLoggedIn(stateOfAccount)) {
                  moreOptionModalBottomSheet(context);

                } else {
                  NavigatorUtils.moveToLoginScreen(context);
                }
              }
            },
          ),

          _isContentCountValid(countOfDraftContent, countOfSyncContent) ? Badge(
            shape: BadgeShape.circle,
            position: BadgePosition(top: 5.0, right: 5.0),
            badgeColor: ColorUtils.primaryColor,
            badgeContent: Text((_contentUploadCount(countOfDraftContent, countOfSyncContent) ?? "").toString()),
            child: IconButton(
                icon: Icon(Icons.file_upload, color: Theme.of(context).iconTheme.color),
                //icon: Icon(Icons.drafts, color: ColorUtils().randomGenerator()),
                onPressed: () {
                  NavigatorUtils.navigateToDraftUploadContentScreen(context);
                }),
          ) : Container(),
          SizedBox(
            width: 4.0,
          ),
        ]);
  }

  void moreOptionModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return UploadBottomSheetUI();
        });
  }

  bool _isContentCountValid(int countOfDraftContent, int countOfSyncContent) {
    return (countOfDraftContent != null && countOfDraftContent > 0) || (countOfSyncContent != null && countOfSyncContent > 0);
  }

  int _contentUploadCount(int countOfDraftContent, int countOfSyncContent) {
    int contentCount = 0;
    if(countOfDraftContent != null && countOfDraftContent > 0) {
      contentCount += countOfDraftContent;
    }
    if(countOfSyncContent != null && countOfSyncContent > 0) {
      contentCount += countOfSyncContent;
    }
    return contentCount;
  }
}
