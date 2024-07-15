import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/DynamicLinks/DynamicLinksUtils.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventAppThemeChanged.dart';
import 'package:tymoff/EventBus/EventModels/EventContentInfoChange.dart';
import 'package:tymoff/Network/Api/ApiHandlerCache.dart';
import 'package:tymoff/Network/Requests/RequestFilterContent.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/MetaDataResponse.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

enum ContentListingType {
  DEFAULT_LISTING, PROFILE
}

enum ContentAddDirection {
  TOP, BOTTOM
}

class ContentBloc extends BlocBase {
  String _profileActionType;
  ContentListingType _contentListingType;

  ContentBloc({ContentListingType contentListingType, String profileActionType}) {
    if(contentListingType != null) {
      this._contentListingType = contentListingType;
    } else {
      this._contentListingType = ContentListingType.DEFAULT_LISTING;
    }

    if(profileActionType != null) {
      this._profileActionType = profileActionType;
    } else {
      this._profileActionType = "";
    }

    _contentFetcher.add(_stateActionContentListResponse);

    _triggerObservers();
  }

  void _triggerObservers() {
    _setContentChangeObserver();
  }

  void _setContentChangeObserver() {
    eventBus.on<EventContentInfoChange>().listen((_event) {
      if(_event != null) {
        var _eventType = _event.contentChangeType;
        switch(_eventType) {

          case ContentChangeType.ADD:
            break;
          case ContentChangeType.UPDATE:
            updateContentInStream(_event.dataToUpdate);
            break;
          case ContentChangeType.DELETE:
            deleteContentFromStream(_event.dataToUpdate);
            break;
        }
      }
    });
  }

  void setProfileActionType(String _profileActionType) {
    this._profileActionType = _profileActionType;
  }

  String getProfileActionType() => _profileActionType;

  void setContentListingType(ContentListingType _contentListingType) {
    this._contentListingType = _contentListingType;
  }

  ContentListingType getContentListingType() => _contentListingType;

  ActionContentListResponse _stateActionContentListResponse;
  ActionContentListResponse _firstPageActionContentListResponse;

  // Content Object Stream
  final _contentFetcher = BehaviorSubject<ActionContentListResponse>();

  Stream<ActionContentListResponse> get contentObservable =>
      _contentFetcher.stream;

  // Content Object Stream
  /*final _listScrollOffset = BehaviorSubject<double>();

  Observable<double> get listScrollOffsetObservables =>
      _listScrollOffset.stream;*/

  // Content Object Stream
  final _listScrollToIndex = BehaviorSubject<int>();
  final _listClickOnIndex = BehaviorSubject<int>();

  Stream<int> get listScrollToIndexObservables =>
      _listScrollToIndex.stream;
  Stream<int> get listClickOnIndexObservables =>
      _listClickOnIndex.stream;

  static final DEFAULT_PAGE = 0;
  var _isResultLoading = false;
  var _isMoreResultAvailableToLoad = true;
  var _page = DEFAULT_PAGE;
  var _searchText = "";
  var _discoverId = "";

  var _filter = RequestFilterContent();

  List<MetaDataResponseDataCommon> listOfGenres = List();
  List<MetaDataResponseDataCommon> listOfContentTypeFilter = List();

  bool isMultipleContentFilterSelectionAllowed = true;
  bool isMultipleGenreSelectionAllowed = true;
  LinkedHashMap<int, MetaDataResponseDataCommon> _hmSelectedContentTypeItems =
      new LinkedHashMap();
  LinkedHashMap<int, MetaDataResponseDataCommon> _hmSelectedGenreItems =
      new LinkedHashMap();

  LinkedHashMap<int, MetaDataResponseDataCommon> getSelectedGenreItems() => _hmSelectedGenreItems;


  void scrollToTop() {
    _listScrollToIndex.value = 0;
  }
/*

  void scrollToOffset(double scrollOffset) {
    _listScrollOffset.value = scrollOffset;
  }
*/

  void scrollToTopIndex() {
    if(!_listScrollToIndex.isClosed) {
      _listScrollToIndex.value = 0;
    }
  }

  void clickOnIndex(int clickIndex) {
    if(!_listClickOnIndex.isClosed && clickIndex != null) {
      _listClickOnIndex.value = clickIndex;
    }
  }

  void scrollToIndex(int scrollToIndex) {
    if(!_listScrollToIndex.isClosed) {
      _listScrollToIndex.value = scrollToIndex;
    }
  }

  void removeScrollToIndexListener() {
    if(!_listScrollToIndex.isClosed) {
      print("Munish Thakur -> ContentListing -> ContentBloc -> removeScrollToIndexListener() - START");
      _listScrollToIndex.close();
      print("Munish Thakur -> ContentListing -> ContentBloc -> removeScrollToIndexListener() - END");
    }
  }

  void setSearchText(String _searchText) {
    this._searchText = _searchText;
  }

  void updateSearchText(String _searchText) {
    this._searchText = _searchText;
    triggerFilterChanged();
  }

  void setDiscoverId(String _discoverId) {
    this._discoverId = _discoverId;
  }

  void _setFilterData() {
    List<int> listOfGenre = List();
    _hmSelectedGenreItems.forEach((key, data) {
      listOfGenre.add(key);
    });
    _filter.genresList = listOfGenre;

    List<int> listOfContentType = List();
    _hmSelectedContentTypeItems.forEach((key, data) {
      listOfContentType.add(key);
    });
    _filter.formatsList = listOfContentType;
    _filter.contentSearch = _searchText;
    _filter.discoverId = _discoverId;
  }

  void updateContentFilterSelection(
      MetaDataResponseDataCommon contentItem, {
    bool isAddOnly = false,
    bool isDeleteOnly: false,
  }) {
    if (contentItem != null) {
      if (!isMultipleContentFilterSelectionAllowed) {
        _hmSelectedContentTypeItems.clear();
      }

      if (isAddOnly == isDeleteOnly) {
        isAddOnly = false;
        isDeleteOnly = false;
      }

      if (isAddOnly) {
        _hmSelectedContentTypeItems[contentItem.id] = contentItem;
      } else if (isDeleteOnly) {
        _hmSelectedContentTypeItems.remove(contentItem.id);
      } else {
        if (isContentFilterSelected(contentItem)) {
          _hmSelectedContentTypeItems.remove(contentItem.id);
        } else {
          _hmSelectedContentTypeItems[contentItem.id] = contentItem;
        }
      }
    }

    triggerFilterChanged();
  }

  bool isContentFilterSelected(MetaDataResponseDataCommon contentItem) {
    if (contentItem != null) {
      //PrintUtils.printLog("Checking Content Filter Type Selected -> Count -> ${_hmSelectedContentTypeItems.length}");
      return _hmSelectedContentTypeItems.containsKey(contentItem.id);
    }

    return false;
  }

  void clearGenreSelection() {
    _hmSelectedGenreItems.clear();
  }

  void updateGenreSelection(
      State state,
      MetaDataResponseDataCommon genreItem, {
        bool isAddOnly = false,
        bool isDeleteOnly: false,
      }) {
      if (genreItem != null) {
        if (!isMultipleGenreSelectionAllowed) {
          _hmSelectedGenreItems.clear();
        }

        if (isAddOnly == isDeleteOnly) {
          isAddOnly = false;
          isDeleteOnly = false;
        }

        if (isAddOnly) {
          _hmSelectedGenreItems[genreItem.id] = genreItem;
        } else if (isDeleteOnly) {
          _hmSelectedGenreItems.remove(genreItem.id);
        } else {
          if (_isGenreSelected(genreItem)) {
            _hmSelectedGenreItems.remove(genreItem.id);
          } else {
            _hmSelectedGenreItems[genreItem.id] = genreItem;
          }
        }
      }

      triggerFilterChanged();
  }

  bool _isGenreSelected(MetaDataResponseDataCommon genreItem) {
    if (genreItem != null) {
      return _hmSelectedGenreItems.containsKey(genreItem.id);
    }

    return false;
  }

  void triggerFilterChanged() {
    reloadContentList(false);
  }

  String getSelectedContentTitle() {
    String title = "";
    _hmSelectedContentTypeItems?.values?.forEach((metaData) {
      title = "$title, ${metaData.name}";
    });
    title = title.replaceFirst(",", "");
    title.trim();
    return title;
  }

  void reloadContentList(bool isHardRefresh) {
    _isResultLoading = false;
    _page = DEFAULT_PAGE;
    _isMoreResultAvailableToLoad = true;

    changeContentState(null);
    getContentData(isHardRefresh: isHardRefresh);
  }

  void getContentData({bool isHardRefresh = false, ContentAddDirection contentAddDirection = ContentAddDirection.BOTTOM}) async {
    try {
      if (!_isResultLoading) {
        _isResultLoading = true;

        if (_isMoreResultAvailableToLoad) {
          _setFilterData();

          ActionContentListResponse _contentResponse;
          switch(_contentListingType) {
            case ContentListingType.DEFAULT_LISTING:
              _contentResponse = await ApiHandlerCache.getContentCache(_filter, _page, isHardRefresh: isHardRefresh);
              break;
            case ContentListingType.PROFILE:
              _contentResponse = await ApiHandlerCache.getProfileContentCache(_page, _profileActionType, isHardRefresh: isHardRefresh);
              break;
          }

          _page++;

          if (isHardRefresh) {
            changeContentState(null);
          }

          if (_contentResponse?.data != null &&
              _contentResponse.data.length > 0) {
            _isResultLoading = false;
            _addMoreContent(_contentResponse, contentAddDirection: contentAddDirection);
            if(_page == (DEFAULT_PAGE + 1)) {
              saveFirstCallDataForExpireCheckPurpose(_contentResponse);
            }
            if (_page < 4) {
              getContentData();
            }
          } else {
            if (_page == 1) {
              var _contentResponse = ActionContentListResponse();
              _contentResponse.data = List<ActionContentData>();
              _addNoDataFound(_contentResponse);
            }
            _isMoreResultAvailableToLoad = false;
          }
        } else {
          PrintUtils.printLog("No Result To Load -> Total Result Found ->(Pages : $_page)");
        }

        _isResultLoading = false;
      }
    } catch (e) {
      _isResultLoading = false;
      PrintUtils.printLog(e.toString());
    }
  }

  void _addMoreContent(ActionContentListResponse _contentResponse, {ContentAddDirection contentAddDirection = ContentAddDirection.BOTTOM}) {
    if (_stateActionContentListResponse != null) {
      if(contentAddDirection != null) {
        if(contentAddDirection == ContentAddDirection.TOP) {
          _stateActionContentListResponse?.data?.insertAll(0, _contentResponse.data);
        } else if(contentAddDirection == ContentAddDirection.TOP) {
          _stateActionContentListResponse?.data?.addAll(_contentResponse.data);
        } else {
          _stateActionContentListResponse?.data?.addAll(_contentResponse.data);
        }
      } else {
        _stateActionContentListResponse?.data?.addAll(_contentResponse.data);
      }
    } else {
      _stateActionContentListResponse = _contentResponse;
    }
    addContentInStream();
  }

  void _addNoDataFound(ActionContentListResponse _contentResponse) {
    _stateActionContentListResponse = _contentResponse;
    addContentInStream();
  }

  void changeContentState(
      ActionContentListResponse _stateActionContentListResponse) {
    this._stateActionContentListResponse = _stateActionContentListResponse;
    addContentInStream();
  }

  void updateContentInStream(ActionContentData dataToUpdate) async {
    int contentFoundAt = findContentIndex(dataToUpdate);

    if (contentFoundAt > -1) {
      var listOfContent = List<ActionContentData>();
      listOfContent.add(dataToUpdate);
      _stateActionContentListResponse?.data
          ?.replaceRange(contentFoundAt, contentFoundAt + 1, listOfContent);
    }

    addContentInStream();
  }

  int findContentIndex(ActionContentData dataToUpdate) {
    int contentFoundAt = -1;
    for (int index = 0;
    index < (_stateActionContentListResponse?.data?.length ?? 0);
    index++) {
      var content = _stateActionContentListResponse?.data[index];
      if (content.id == dataToUpdate.id) {
        contentFoundAt = index;
        break;
      }
    }

    return contentFoundAt;
  }

  void deleteContentFromStream(ActionContentData dataToUpdate, {int indexToRemove}) async {

    if (!(indexToRemove != null && indexToRemove > -1)) {
      indexToRemove = findContentIndex(dataToUpdate);
    }

    _removeDataFromStream(indexToRemove);
  }

  void _removeDataFromStream(int contentFoundAt) {
    var listOfContent = List<ActionContentData>();
    _stateActionContentListResponse?.data
        ?.replaceRange(contentFoundAt, contentFoundAt + 1, listOfContent);

    updateContentDataInStream();
  }

  void addContentInStream() {
    _contentFetcher.add(_stateActionContentListResponse);
    updateContentWithDynamicLinkInStream();
  }

  void updateContentDataInStream() {
    _contentFetcher.add(_stateActionContentListResponse);
  }

  Future<void> updateContentWithDynamicLinkInStream() async {

    try {
      if (_stateActionContentListResponse?.data != null) {
        int contentCount = 0;
        //PrintUtils.printLog("Munish -> updateContentWithDynamicLinkInStream() - START -> 1");
        //PrintUtils.printLog("Munish -> updateContentWithDynamicLinkInStream() -> ${_stateActionContentListResponse?.data?.length}");

        await Future.forEach(
            _stateActionContentListResponse?.data, (_contentData) async {
          contentCount++;
          if (_contentData.sharingUrl != null &&
              _contentData.sharingUrl.length > 0) {

          } else {
            var dynamicUtils = DynamicLinksUtils();
            var shortDynamicUrl = await dynamicUtils.getShortDynamicUrlFromContent(_contentData);
            _contentData.sharingUrl = shortDynamicUrl;
          }

          //PrintUtils.printLog("Munish -> updateContentWithDynamicLinkInStream() -> $contentCount). Content Id : ${_contentData.id} -> sharingUrl: ${_contentData.sharingUrl}");
        });

        _contentFetcher.add(_stateActionContentListResponse);
        //PrintUtils.printLog("Munish -> updateContentWithDynamicLinkInStream() - END -> 2");
      }
    } catch(e) {

    }
  }

  void saveFirstCallDataForExpireCheckPurpose(ActionContentListResponse contentResponse) {
    this._firstPageActionContentListResponse = contentResponse;
  }

  DateTime getFirstLoadedContentDateTime() {
   try {
     int firstLoadedTime = _firstPageActionContentListResponse.lastUpdatedTime;
     return DateTime.fromMillisecondsSinceEpoch(firstLoadedTime);
   } catch(e){
     return null;
   }
  }

  @override
  void dispose() {
    _contentFetcher.close();
  }
}
