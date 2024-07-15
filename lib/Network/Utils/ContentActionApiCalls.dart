import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

class ContentActionApiCalls {
  static void hitLikeApi(BuildContext context, State state,
      bool isActionLike, ActionContentData cardDetailData,
      {Function func1, ContentBloc contentBloc}) async {
    var actionType = "";

    if (!isActionLike) {
      actionType = "unLike";
      PrintUtils.printLog("un-like api hit successfully");
    } else {
      actionType = "like";
      PrintUtils.printLog("like api hit successfully");
    }

    _executeFunction(func1);

    _commonContentActionApiCall(context, actionType, cardDetailData, state, func1);
  }

  static void hitFavouriteApi(BuildContext context, State state, bool isActionFavourite, ActionContentData cardDetailData, {Function func1, ContentBloc contentBloc}) async {

    var actionType = "";

    if (!isActionFavourite) {
      actionType = "unFavorite";
      PrintUtils.printLog("un-Favorite api hit successfully");
    } else {
      actionType = "favorite";
      PrintUtils.printLog("favorite api hit successfully");
    }

    _executeFunction(func1);

    _commonContentActionApiCall(context, actionType, cardDetailData, state, func1);
  }

  static void _commonContentActionApiCall(BuildContext context, String actionType, ActionContentData cardDetailData, State<StatefulWidget> state, Function func1, {ContentBloc contentBloc}) async {
    try {
      ContentDetailResponse response =
          await ApiHandler.putAction(context, actionType, cardDetailData.id);
    
      state.setState(() {
        if (response == null) {
          _executeFunction(func1);
        } else if (response?.data == null) {
          _executeFunction(func1);
        } else if (response?.data != null) {
          response.data.clone(cardDetailData);
        }
      });
    } catch (e) {
      PrintUtils.printLog("Like API Hit Exception -> $e");
    }
  }

  static void _executeFunction(func1) {
    if (func1 != null) {
      func1();
    }
  }
}
