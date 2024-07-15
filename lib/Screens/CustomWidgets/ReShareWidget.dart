import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Network/Response/PutActionLikeResponse.dart';
import 'package:tymoff/Network/Utils/ContentActionApiCalls.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';

class ReShareWidget extends StatefulWidget {
  final double iconSize;
  final bool isComingFromListing;
  final ActionContentData cardDetailData;

  ReShareWidget(this.cardDetailData,
      {this.iconSize, this.isComingFromListing});

  @override
  _ReShareWidgetState createState() => _ReShareWidgetState(cardDetailData,
      iconSize: this.iconSize, isComingFromListing: this.isComingFromListing);
}

class _ReShareWidgetState extends State<ReShareWidget> {
  double iconSize;
  bool isComingFromListing;
  ActionContentData cardDetailData;

  _ReShareWidgetState(this.cardDetailData,
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
            return isComingFromListing == true ? GestureDetector(
              child: Container(
                width: 40.0,
                color: Colors.transparent,
                padding:const EdgeInsets.only(left:4.0,top: 4.0,bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset("assets/reshare.png",
                        scale: 4.0,),
                    ),
                    SizedBox(width: 2.0,),
                    CustomWidget.getText(cardDetailData?.favCount.toString()??"0",style: Theme.of(context).textTheme.body1)

                  ],
                ),
              ),
              onTap: (){
                //accountBloc.isUserLoggedIn(snapshot?.data)? hitApi() : CustomWidget.showReportContentDialog(context);
              },
            ) : GestureDetector(
              child: Container(
               // height: 50.0,
                width: 50.0,
                color: Colors.transparent,
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                     Image.asset(
                        "assets/reshare.png",
                        color: ColorUtils.articleWebViewIconColor,
                        /*color: isLike == false ? Theme.of(context).unselectedWidgetColor : ColorUtils.likeIconSelectedColor,*/
                        scale: widget.iconSize,
                      ),
                    SizedBox(
                      width: 5.0,
                    ),
                    CustomWidget.getText((cardDetailData?.favCount.toString() + " Reshare"),style: Theme.of(context).textTheme.display1.copyWith(
                        color: ColorUtils.articleWebViewIconColor,fontSize: 14.0)),

                  ],
                ),
              ),
            );
          }),
    );
  }
}
