import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Requests/RequestCommentPushContent.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Network/Response/LoginResponse.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';

class CommentBloc extends BlocBase {
  CommentPullResponse _stateCommentListResponse;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Content Object Stream
  final _contentFetcher = PublishSubject<CommentPullResponse>();

  Stream<CommentPullResponse> get commentObservable =>
      _contentFetcher.stream;

  BuildContext _context;
  static final DEFAULT_PAGE = 0;
  var _isResultLoading = false;
  var _isMoreResultAvailableToLoad = true;
  var _page = DEFAULT_PAGE;

  CommentBloc(BuildContext context) {
    this._context = context;
    _contentFetcher.add(_stateCommentListResponse);
  }

  CommentPullResponse getComments() {
    return _stateCommentListResponse;
  }

  void reloadContentList(String contentId) {
    _isResultLoading = false;
    _page = DEFAULT_PAGE;
    _isMoreResultAvailableToLoad = true;

    changeContentState(null);
    getCommentData(contentId);
  }

  void getCommentData(String contentId, {bool isHardRefresh = false}) async {
    try {
      if (!_isResultLoading) {
        _isResultLoading = true;

        if (_isMoreResultAvailableToLoad) {
          // _setFilterData();

          var _commentResponse =
              await ApiHandler.getCommentPull(_context, _page, contentId);

          _page++;

          if (isHardRefresh) {
            changeContentState(null);
          }

          if (_commentResponse.statusCode == 200) {
            if (_commentResponse?.data?.dataList != null &&
                _commentResponse.data.dataList.length > 0) {

              _commentResponse.data.dataList.sort(((item1, item2) {
                try {
                  var dateTime1 = DateTime.parse(item1.commentTime);
                  var dateTime2 = DateTime.parse(item2.commentTime);

                  return dateTime2.compareTo(dateTime1);
                } catch(e){

                }

                return 0;
              }));

              _addMoreComment(_commentResponse);
            } else {
              if (_page == 1) {
                var _commentResponse = CommentPullResponse();
                _commentResponse.data.dataList = List<CommentPullDataList>();
                _addNoDataFound(_commentResponse);
              }
              _isMoreResultAvailableToLoad = false;
            }
          } else {
            noCommentDataPopulate();
          }
        } else {
          print("No Result To Load -> Total Result Found ->(Pages : $_page)");
        }

        _isResultLoading = false;
      }
    } catch (e) {
      print("Munish Thakur -> getCommentData() -> ${e.toString()}");
      noCommentDataPopulate();
    }
  }

  void hitPushComment(BuildContext context, String contentId, String commentText) async{
    LoginResponse loginResponse = await SharedPrefUtil.getLoginData();
    var userId = loginResponse.data.id.toString();
    if(commentText.length > 0){
      RequestCommentPushContent _push = RequestCommentPushContent(parentId: "1", contentId: contentId, userId: userId, comments: commentText);
      var _commentPutResponse = await ApiHandler.putComment(context, _push);
      // print("request dat $_commentPutResponse");
      if(_commentPutResponse.statusCode == 200) {
        _addComment(_commentPutResponse.data);
      }
      print("comment  push api hit successfully");
    }else{
      print("Enter Comment");
    }
  }

  void noCommentDataPopulate() {
    print("no comment found");
    var _commentResponse = CommentPullResponse();
    _commentResponse.data = CommentPullData();
    _commentResponse.data.dataList = List<CommentPullDataList>();
    _addMoreComment(_commentResponse);
  }

  void _addMoreComment(CommentPullResponse _commentResponse) {
    if (_stateCommentListResponse != null) {
      _stateCommentListResponse?.data?.dataList
          ?.addAll(_commentResponse.data.dataList);
    } else {
      _stateCommentListResponse = _commentResponse;
    }
    addContentInStream();
  }

  void _addComment(CommentPullDataList _commentResponse) {
    if (_stateCommentListResponse != null) {
      _stateCommentListResponse?.data?.dataList?.insert(0, _commentResponse);
    }
    addContentInStream();
  }

  void _addNoDataFound(CommentPullResponse _contentResponse) {
    _stateCommentListResponse = _contentResponse;
    addContentInStream();
  }

  void changeContentState(CommentPullResponse _stateActionContentListResponse) {
    this._stateCommentListResponse = _stateActionContentListResponse;
    addContentInStream();
  }

  void addContentInStream() {
    _contentFetcher.add(_stateCommentListResponse);
  }

  @override
  void dispose() {
    _contentFetcher.close();
  }
}
