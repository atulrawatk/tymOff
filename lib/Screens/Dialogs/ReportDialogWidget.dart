import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Api/ApiHandlerCache.dart';
import 'package:tymoff/Network/Requests/ReportRequest.dart';
import 'package:tymoff/Network/Response/ContentDetailResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Screens/Dialogs/ReportDialogContent.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/SnackBarUtil.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/ToastUtils.dart';

class ReportDialogWidget extends StatefulWidget {
  final int contentId;
  final BuildContext context1;
  final double iconSize;
  Function removeContent;

  ReportDialogWidget({this.contentId,this.context1,this.iconSize, this.removeContent});

  @override
  _ReportDialogWidgetState createState() => _ReportDialogWidgetState();
}

class _ReportDialogWidgetState extends State<ReportDialogWidget> {

  AccountBloc accountBloc;
  MetaDataResponse metaDataResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fireEventDetailCardDoNotChange() {
    if(widget?.contentId != null) {
      EventBusUtils.eventDetailCardDoNotChange(
          widget.contentId.toString());
    }
  }

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    getReportResponse();
    super.didChangeDependencies();
  }

  getReportResponse()async{
    var response = await SharedPrefUtil.getMetaData();
    if(response != null){
      setState(() {
        metaDataResponse = response;
      });
    }
  }

  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  String radioValue = "";

  MetaDataResponseDataCommon _metaReportData;
  void _reportContentChange(MetaDataResponseDataCommon _metaReportData) {
    this._metaReportData = _metaReportData;
  }

  _hitReportContentHideApi() async{
    if(_metaReportData.id.toString() != null){
      String contentId = widget.contentId.toString();
      var response = await ApiHandler.reportContentHide(context, contentId, _metaReportData.id.toString(), _metaReportData.name.toString());

      if(response != null && response.statusCode == 200){
        removeContent();
      }else{
        Navigator.of(context).pop();
      }
    }
    return;

  }

  void removeContent() {

    String contentId = widget.contentId.toString();
    Navigator.of(context).pop();
    ToastUtils.show("Reported successfully");
    ApiHandlerCache.removeOldContentIdFromCache(contentId);
    widget.removeContent();
  }


   void _showReportContentDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(8.0),
          title: CustomWidget.getText(Strings.reportContent, style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.primaryColor)),
          content: new SingleChildScrollView(
            child:  ReportDialogContent(reportContentListItems: metaDataResponse.data.report, reportContentChange: _reportContentChange),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child:
              CustomWidget.getText(Strings.report, style: Theme.of(context).textTheme.title.copyWith(color: ColorUtils.primaryColor)),

              onPressed: () {
                AnalyticsUtils?.analyticsUtils?.eventReportButtonClicked();

                // TEMP CODE - MUNISH THAKUR
                //removeContent("Content Reported");

                _hitReportContentHideApi();
               // Scaffold.of(context1).showSnackBar(SnackBar(content: Text("Reported")));

              },
            ),
            new FlatButton(
              child:
              CustomWidget.getText(Strings.cancel, style: Theme.of(context).textTheme.title),
              onPressed: () {

                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateOfAccount>(
        initialData: accountBloc.getAccountState(),
        stream: accountBloc.accountStateObservable,
        builder: (context, snapshot) {
          return GestureDetector(
            child: Container(
              color: Colors.transparent,
              //height: 50.0,
              width: 50.0,
              padding:  EdgeInsets.only( left:8.0,top: 4.0,bottom: 4.0),
              child: Row(
                children: <Widget>[
                  Image.asset("assets/report.png",scale: widget.iconSize, color: Theme.of(context).unselectedWidgetColor,),
                   SizedBox(width: 5.0,),
                  CustomWidget.getText("Report",
                      style: Theme.of(context).textTheme.display1.copyWith(color: ColorUtils.textDetailScreenColor,fontSize: 14.0)),
                ],
              ),
            ),
            onTap: () {
              accountBloc.isUserLoggedIn(snapshot?.data)?_showReportContentDialog(context):CustomWidget.showReportContentDialog(widget.context1);
              fireEventDetailCardDoNotChange();
            },
          );
        }
    );

  }
}
