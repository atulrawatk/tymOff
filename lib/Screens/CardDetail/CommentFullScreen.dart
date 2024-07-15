import 'package:flutter/material.dart';
import 'package:tymoff/BLOC/Blocs/CommentBloc.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/RequestCommentPushContent.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/Network/Response/PutActionLikeResponse.dart';
import 'package:tymoff/Screens/CardDetail/CommentView.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/Strings.dart';
class CommentFullScreen extends StatefulWidget {
  final String contentId;
  CommentBloc _commentBloc;

  CommentFullScreen(this.contentId, this._commentBloc);

  @override
  _CommentFullScreenState createState() => _CommentFullScreenState(contentId);
}

class _CommentFullScreenState extends State<CommentFullScreen> {

  String contentId;
  _CommentFullScreenState(this.contentId);


  var _scrollViewController;
  TextEditingController _textFieldController = TextEditingController();
  String commentText = "";
  int count = 0;

  CommentPullResponse _commentPullResponse;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textFieldController.dispose();
    super.dispose();
  }

  void _reloadCommentList() {
    widget._commentBloc.getCommentData(contentId);
  }

  void _loadMoreData({bool isHardRefresh = false}) {
    widget._commentBloc.getCommentData(contentId, isHardRefresh: isHardRefresh);
  }


  @override
  void initState() {
    super.initState();

    // TEMP CODE - Munish (Above Comment needs to remove)
    //contentId = "573";
  }

  @override
  void didChangeDependencies() {
    //accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }


  Widget bottomNavigationWidget(){
    return BottomAppBar(
      child:AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: new Container(
          height: 80.0,
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: <Widget>[
              Container(

                height: 80.0,
                //color: Colors.grey[200],
                padding: EdgeInsets.only(left:10.0,right: 10.0),
                child: Center(
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(color: ColorUtils.writeACommentBgColor,shape:BoxShape.rectangle,borderRadius: BorderRadius.circular(4.0)),
                    child: Container(
                      color: Theme.of(context).secondaryHeaderColor,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 3.0,bottom: 1.0),
                      child: TextField(
                            cursorColor: Theme.of(context).cursorColor,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller:_textFieldController,
                            onChanged: (value){
                              setState(() {
                                commentText = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all( 12.0),

                              //hasFloatingPlaceholder: true,
                              alignLabelWithHint: true,
                              // fillColor: Colors.pink,
                              hintText: "Write a comment",
                              fillColor: ColorUtils.writeACommentBgColor,
                              border: InputBorder.none,
                              suffixIcon:IconButton(icon:Icon(Icons.send,color: Theme.of(context).accentColor), onPressed:(){

                                widget._commentBloc.hitPushComment(context, contentId, commentText);

                                _textFieldController.clear();
                              }),
                            )

                        )
                    ),
                  ),

                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  Future<void> _onRefreshContentList() async {
    //Holding pull to refresh loader widget for 2 sec.
    //You can fetch data from server.
    await new Future.delayed(const Duration(seconds: 1));
    _reloadCommentList();

  }

  static final riKey1 = const Key('__RI_COMMENT_KEY1__');
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Widget _getCommentsUIList(AsyncSnapshot<CommentPullResponse> snapshot) {

    return (snapshot?.data?.data?.dataList?.length ?? 0) > 0
        ? getCommentListUI(snapshot) : getNoCommentWidget();
  }

  Container getCommentListUI(AsyncSnapshot<CommentPullResponse> snapshot) {
    return Container(
    // color: Theme.of(context).backgroundColor,
    child: NotificationListener<ScrollNotification>(
      key: riKey1,
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreData(isHardRefresh: false);
        }
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefreshContentList,
        //child: buildCommentSliverList(snapshot),
        child: getCommentList(snapshot?.data?.data?.dataList),
      ),
    ),
  );
  }

  ScrollController _scrollController = ScrollController();

  Widget getCommentList(List<CommentPullDataList> commentsList) {

    var sizeOfList = (commentsList?.length ?? 0);
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: sizeOfList,
      itemBuilder:
          (BuildContext context, int index) {

        print("Munish -> Comment at $index -> ${commentsList[index].comments}");
        return Container(
          child: CommentView(
              commentsList[index]),
        );
      },
    );
  }

  Widget getNoCommentWidget() {
    return Center(
        child: Container(
        child: Text(Strings.whenNoCommentIsAvailable),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommentPullResponse>(
        initialData:  widget._commentBloc.getComments(),
        stream:  widget._commentBloc.commentObservable,
        builder: (context,snapshot){
          return buildMainView(context, snapshot);
        }
    );
  }

  Widget buildMainView(BuildContext context, AsyncSnapshot<CommentPullResponse> snapshot) {
    return Scaffold(
          appBar: PreferredSize(
            child: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading:IconButton(icon: Icon(Icons.arrow_back_ios,  color: Theme.of(context).accentColor,size: 18.0,), onPressed:(){
                  Navigator.of(context).pop();
                }),
                titleSpacing: 0.0,
                title:CustomWidget.getText(/*(snapshot?.data?.totalElements?.toString()?? "0")+ " " +*/ "Comments",
                    style: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0))
            ),
            preferredSize: Size.fromHeight(48.0),
          ),

         /* body: CustomScrollView(
            controller: _scrollViewController,

            // physics: NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              snapshot.data == null ? buildCircularProgressSliverList() : _getCommentsUIList(snapshot),
              commentText == "" || commentText == null ? SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Container();
                }, childCount: 1),
              ) : SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Text(commentText);
                }, childCount: count),
              ),
            ],
          ),*/

         body: Container(
           child: snapshot.data == null ? buildCircularProgress() : _getCommentsUIList(snapshot),
         ),

          bottomNavigationBar: bottomNavigationWidget(),
        );
  }

  Widget buildCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
