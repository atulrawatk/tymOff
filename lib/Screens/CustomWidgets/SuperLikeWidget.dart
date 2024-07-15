import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Network/Response/PutActionLikeResponse.dart';
import 'package:tymoff/Network/Utils/ContentActionApiCalls.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class SuperLikeWidget extends StatefulWidget {
  final double iconSize;
  final bool isComingFromListing;
  final ActionContentData cardDetailData;

  SuperLikeWidget(this.cardDetailData,
      {this.iconSize, this.isComingFromListing});

  @override
  _SuperLikeWidgetState createState() => _SuperLikeWidgetState(cardDetailData,
      iconSize: this.iconSize, isComingFromListing: this.isComingFromListing);
}

class _SuperLikeWidgetState extends State<SuperLikeWidget> {
  double iconSize;
  bool isComingFromListing;
  ActionContentData cardDetailData;

  _SuperLikeWidgetState(this.cardDetailData,
      {this.iconSize, this.isComingFromListing});

  ContentDetailResponse response;
  AccountBloc accountBloc;

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }

  bool isFavorite() {
    return cardDetailData?.isFavorite ?? false;
  }

  hitApi() {
    ContentActionApiCalls.hitFavouriteApi(context, this, !isFavorite(), cardDetailData, func1: toggleIconAndData);
  }

  void toggleIconAndData() {

    if(isFavorite()) {
      setState(() {
        cardDetailData.isFavorite = false;
        if (cardDetailData.favCount > 0) {
          --cardDetailData.favCount;
        }
      });
    } else {
      setState(() {
        cardDetailData.isFavorite = true;
        ++cardDetailData.favCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshot) {
            return isComingFromListing == true
                ? Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/heart_unfill.png",
                          /*color: isLike == false ? Theme.of(context).unselectedWidgetColor : ColorUtils.likeIconSelectedColor,*/
                          scale: 4.0,
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      CustomWidget.getText(
                          cardDetailData?.favCount.toString() ?? "0",
                          style: Theme.of(context).textTheme.body1)
                    ],
                  )
                : GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: isFavorite()
                              ? Image.asset(
                                  "assets/circle_heart48.png",
                                  /*color: isLike == false ? Theme.of(context).unselectedWidgetColor : ColorUtils.likeIconSelectedColor,*/
                                  scale: 3.0,
                                )
                              : Image.asset(
                                  "assets/inactive_heart.png",
                                  scale: 3.0,
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
                                ),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        CustomWidget.getText(
                            (cardDetailData?.favCount.toString() +
                                " Superlikes"),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                    onTap: () {

                      AnalyticsUtils?.analyticsUtils?.eventSuperlikeButtonClicked();
                      accountBloc.isUserLoggedIn(snapshot?.data)
                          ? hitApi()
                          : CustomWidget.showReportContentDialog(context);
                    },
                  );
          }),
    );
  }
}
