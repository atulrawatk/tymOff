import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';

class ContentTileOptionsWidget extends StatefulWidget {
  final iconSize;
  final ActionContentData contentData;
  final ContentBloc _blocContent;
  final int indexToDelete;
  final bool isComingFormList;

  ContentTileOptionsWidget(this.contentData, this.indexToDelete, this._blocContent,
      {this.iconSize, this.isComingFormList});

  @override
  _ContentTileOptionsWidgetState createState() => _ContentTileOptionsWidgetState();
}

class _ContentTileOptionsWidgetState extends State<ContentTileOptionsWidget> {
  AccountBloc accountBloc;
  String buttonSelect = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }

  static const menuItems = <String>[
    "Delete",
  ];

  final List<PopupMenuItem<String>> _popUpMenuButton = menuItems
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  AlertDialog getDailogToDelete(BuildContext context, contentId) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text("Delete Post"),
      content: Text("Are you sure, you want to delete your post ?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, "Cancel");
          },
          child: Text("Cancel", style: TextStyle(color: ColorUtils.pinkColor)),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, "Delete");
            _hitDeletePost(context, contentId);
          },
          child: Text("Delete", style: TextStyle(color: ColorUtils.pinkColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateOfAccount>(
        initialData: accountBloc.getAccountState(),
        stream: accountBloc.accountStateObservable,
        builder: (context, snapshot) {
          return widget.isComingFormList == true
              ? Container(
                  width: 30.0,
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18.0,
                    ),
                    onSelected: (String newValue) {
                      setState(() {
                        buttonSelect = newValue;
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext dialogContext) =>
                              getDailogToDelete(context, widget.contentData.id),
                        );
                      });
                    },
                    itemBuilder: (BuildContext context) => _popUpMenuButton,
                  )
                  /* Icon(Icons.more_vert , size: widget.iconSize,),*/
                  )
              : Container(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) =>
                            getDailogToDelete(context, widget.contentData.id),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          " ",
                          scale: 3.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomWidget.getText("Delete Post",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontSize: 14.0)),
                            CustomWidget.getText(
                                "Do you want to delete this post",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(fontSize: 12.0)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
        });
  }

  void _hitDeletePost(BuildContext context, contentId) async {
    // TEMP CODE - Munish Thakur
    //widget._blocContent?.deleteContentFromStream(widget.contentData, widget.indexToDelete);

    var _getDeletePostResponse =
        await ApiHandler.getDeletePost(context, contentId);
    if (_getDeletePostResponse?.statusCode == 200) {
      PrintUtils.printLog("Delete Post api hit successfully");

      widget._blocContent
          ?.deleteContentFromStream(widget.contentData, indexToRemove: widget.indexToDelete);

      SnackBarUtil.show(_scaffoldKey, "Deleted successfully");
    } else {
      //SnackBarUtil.show(_scaffoldKey, "Somthing went wrong");
    }
  }
}
