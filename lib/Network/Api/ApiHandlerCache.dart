import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tymoff/BLOC/Blocs/ContentBloc.dart';
import 'package:tymoff/Network/Requests/RequestFilterContent.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Network/Response/DiscoverListResponse.dart';
import 'package:tymoff/Screens/ContentScreen/ContentListingTile.dart';
import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';
import 'package:tymoff/Utils/PrintUtils.dart';

import 'ApiHandler.dart';
import 'ApiHandlerUtils.dart';

class ApiHandlerCache {
  static final Map<String, String> hashMapOfCacheRequest = Map();

  static final int KEY_ERROR_HASHCODE = -1;

  static void initialize() async {
    var savedCache = await SharedPrefUtil.getApiHandleCache();
    if (savedCache != null && savedCache.hashMapOfCacheRequest != null) {
      hashMapOfCacheRequest.clear();
      hashMapOfCacheRequest.addAll(savedCache.hashMapOfCacheRequest);
    }
  }

  ///
  /// Cache Related Common Methods - START
  ///
  static Future<String> getCacheKey(String requestUrl,
      {Object requestObject}) async {
    String cacheKey = requestUrl;

    try {
      String loggedInUserId = await SharedPrefUtil.getLoggedInUserId();
      String jsonFinalObject = json.encode(requestObject);
      int hashCode = jsonFinalObject?.hashCode ?? KEY_ERROR_HASHCODE;
      if (hashCode != KEY_ERROR_HASHCODE) {
        cacheKey = "$cacheKey/$hashCode/$loggedInUserId";
      }
    } catch (e) {
      //PrintUtils.printLog("Error getCacheKey() -> ${e.toString()}");
    }
    return cacheKey;
  }

  static bool isContainCacheKey(String cacheKey) {
    return hashMapOfCacheRequest.containsKey(cacheKey);
  }

  static String getCacheString(String cacheKey) {
    return hashMapOfCacheRequest[cacheKey];
  }

  static void putCacheString(String cacheKey, String cacheValue) {
    hashMapOfCacheRequest[cacheKey] = cacheValue;
    SharedPrefUtil.saveApiHandleCacheMap(hashMapOfCacheRequest);
  }

  static void removeOldContentCache() {
    var _listOfToRemoveKey = List<String>();
    hashMapOfCacheRequest?.keys?.forEach((_key) {
      if (_key.contains(ApiHandlerUtils.contentUrlPrefix)) {
        _listOfToRemoveKey.add(_key);
      }
    });

    _listOfToRemoveKey.forEach((_keyToRemove) {
      hashMapOfCacheRequest.remove(_keyToRemove);
    });
  }

  static void removeOldContentIdFromCache(String contentId) async {
    hashMapOfCacheRequest?.keys?.forEach((_key) {
      if (_key.contains(ApiHandlerUtils.contentUrlPrefix)) {
        try {
          var localCacheResponseInString = getCacheString(_key);
          var contentData = ApiHandlerUtils.getContentListResponse(
              localCacheResponseInString);

          var _listOfIndexToRemove = List<int>();
          for (int index = 0;
              index < (contentData?.data?.length ?? 0);
              index++) {
            var contentItem = contentData?.data[index];
            if (contentItem.id.toString() == contentId) {
              _listOfIndexToRemove.add(index);
            }
          }

          _listOfIndexToRemove?.forEach((indexToRemove) {
            contentData?.data?.removeAt(indexToRemove);
          });

          String responseToSaveInCache =
              ApiHandlerUtils.getContentListResponseInString(contentData);

          putCacheString(_key, responseToSaveInCache);
        } catch (e) {
          //PrintUtils.printLog("Munish -> removeOldContentIdFromCache() ${e.toString()}");
        }
      }
    });
  }

  ///
  /// Cache Related Common Methods - END
  ///

  ///
  /// Content List Api Method - START
  ///
  static Future<ActionContentListResponse> getContentCache(
    RequestFilterContent request,
    int page, {
    bool isHardRefresh = false,
  }) async {
    String cacheKey = await getCacheKey(ApiHandlerUtils.getContentUrl(page),
        requestObject: request);

    String responseInString = "";
    bool isInternetAvailable = await AppUtils.isInternetAvailable();
    if (isInternetAvailable) {
      if (isContainCacheKey(cacheKey)) {
        PrintUtils.printLog("Got Content from Cache--->");
        var localCacheResponseInString = getCacheString(cacheKey);
        var contentData =
            ApiHandlerUtils.getContentListResponse(localCacheResponseInString);

        var isExpired = ApiHandlerUtils.isContentListingCacheExpired(
            contentData.lastUpdatedTime);

        if (isExpired) {
          if (page == ContentBloc.DEFAULT_PAGE) {
            removeOldContentCache();
          }
          isHardRefresh = true;
        } else {
          responseInString = localCacheResponseInString;
        }
      } else {
        isHardRefresh = true;
      }

      if (isHardRefresh) {
        responseInString =
            await hitContentApiAndSaveCache(request, page, cacheKey);
      }
    } else {
      if (isContainCacheKey(cacheKey)) {
        PrintUtils.printLog("Got Content from Cache--->");
        responseInString = getCacheString(cacheKey);
      }
    }

    if (responseInString == null) {
      responseInString =
          await hitContentApiAndSaveCache(request, page, cacheKey);
    }
    return ApiHandlerUtils.getContentListResponse(responseInString);
  }

  static Future<String> hitContentApiAndSaveCache(
      RequestFilterContent request, int page, String cacheKey) async {
    String imageHeightWidthSeperator = "x";

    PrintUtils.printLog("Got Content from API--->");
    var response = await ApiHandler.getContent(request, page);

    ActionContentListResponse actionContentListResponse =
        ApiHandlerUtils.getContentListResponse(response);
    actionContentListResponse.lastUpdatedTime =
        DateTimeUtils().currentMillisecondsSinceEpoch();

    actionContentListResponse?.data?.forEach((contentItem) {
      try {
        contentItem?.contentUrl?.forEach((contentUrl) {
          try {
            var typeId = contentItem.typeId;
            var type = ContentTypeUtils.getType(typeId);

            var minHeight = 100.0;
            if (type == AppContentType.image || type == AppContentType.gif) {
              try {
                var dimensions = contentUrl.dimensions;
                if (dimensions != null &&
                    dimensions.contains(imageHeightWidthSeperator)) {
                  String dimensionWidthStr = (dimensions.substring(
                      0, dimensions.indexOf(imageHeightWidthSeperator)));
                  String dimensionHeightStr = (dimensions.substring(
                          dimensions.indexOf(imageHeightWidthSeperator) + 1,
                          dimensions.length))
                      .toString();

                  int dimensionWidth = int.parse(dimensionWidthStr);
                  int dimensionHeight = int.parse(dimensionHeightStr);

                  double dimensionRatio =
                      dimensionWidth / ContentListingTile.cardWidth;
                  double dimensionHeightDouble =
                      (dimensionHeight / dimensionRatio);
                  minHeight = dimensionHeightDouble;

                  contentUrl.height = minHeight;
                  contentUrl.width = ContentListingTile.cardWidth;
                }
              } catch (e) {
                PrintUtils.printLog(
                    "Munish Thakur -> minHeight Exception() -> ${e.toString()}");
              }
            }
          } catch (e) {}
        });
      } catch (e) {}
    });
    response = ApiHandlerUtils.getContentListResponseInString(
        actionContentListResponse);

    putCacheString(cacheKey, response);
    return response;
  }

  ///
  /// Content List Api Method - END
  ///

  ///
  /// Profile List Api Method - START
  ///

  static void removeOldProfileContentCache(String actionType) {
    var _listOfToRemoveKey = List<String>();
    hashMapOfCacheRequest?.keys?.forEach((_key) {
      if (_key.contains(ApiHandlerUtils.getProfileContentUrlPrefix(actionType))) {
        _listOfToRemoveKey.add(_key);
      }
    });

    _listOfToRemoveKey.forEach((_keyToRemove) {
      hashMapOfCacheRequest.remove(_keyToRemove);
    });
  }

  static Future<ActionContentListResponse> getProfileContentCache(
    int page,
    String actionType, {
    bool isHardRefresh = false,
  }) async {
    String cacheKey = await getCacheKey(
        ApiHandlerUtils.getProfileContentUrl(page, actionType));

    String responseInString = "";
    bool isInternetAvailable = await AppUtils.isInternetAvailable();
    if (isInternetAvailable) {
      if (isContainCacheKey(cacheKey)) {
        PrintUtils.printLog("Got Content from Cache--->");
        responseInString = getCacheString(cacheKey);

        if (isHardRefresh) {
          removeOldProfileContentCache(actionType);
          responseInString = await hitProfileContentApiAndSaveCache(
              page, actionType, cacheKey);
        }
      } else {
        responseInString = await hitProfileContentApiAndSaveCache(
            page, actionType, cacheKey);
      }
    } else {
      if (isContainCacheKey(cacheKey)) {
        PrintUtils.printLog("Got Content from Cache--->");
        responseInString = getCacheString(cacheKey);
      }
    }

    if (responseInString == null) {
      responseInString =
          await hitProfileContentApiAndSaveCache(page, actionType, cacheKey);
    }

    return ApiHandlerUtils.getContentListResponse(responseInString);
  }

  static Future<String> hitProfileContentApiAndSaveCache(
      int page, String actionType, String cacheKey) async {
    var response = await ApiHandler.getProfileContent(page, actionType);
    putCacheString(cacheKey, response);
    return response;
  }

  ///
  /// Profile List Api Method - START
  ///

  ///
  /// Discover List Api Method - START
  ///
  static Future<DiscoverListResponse> getDiscoverListResponse(
    BuildContext context, {
    bool isHardRefresh = false,
  }) async {
    String cacheKey = await getCacheKey(ApiHandlerUtils.getDiscoverUrl());

    String responseInString = "";
    if (isContainCacheKey(cacheKey) && !isHardRefresh) {
      PrintUtils.printLog("Got Discover from Cache--->");
      responseInString = getCacheString(cacheKey);
    } else {
      PrintUtils.printLog("Got Discover from API--->");
      responseInString = await hitDiscoverApiAndSaveCache(context, cacheKey);
    }

    if (responseInString == null) {
      responseInString = await hitDiscoverApiAndSaveCache(context, cacheKey);
    }
    return ApiHandlerUtils.getDiscoverListResponse(responseInString);
  }

  static Future<DiscoverListResponse> getDiscoverListUserSpecificResponse(
    BuildContext context, {
    bool isHardRefresh = false,
  }) async {
    String cacheKey =
        await getCacheKey(ApiHandlerUtils.getUserSpecificDiscoverUrl());

    String responseInString = "";
    if (isContainCacheKey(cacheKey) && !isHardRefresh) {
      PrintUtils.printLog("Got Discover from Cache--->");
      responseInString = getCacheString(cacheKey);
    } else {
      PrintUtils.printLog("Got Discover from API--->");
      responseInString =
          await hitUserSpecificDiscoverApiAndSaveCache(context, cacheKey);
    }

    if (responseInString == null) {
      responseInString =
          await hitUserSpecificDiscoverApiAndSaveCache(context, cacheKey);
    }
    return ApiHandlerUtils.getDiscoverListResponse(responseInString);
  }

  static Future<String> hitDiscoverApiAndSaveCache(
      BuildContext context, String cacheKey) async {
    var response = await ApiHandler.getDiscoverListResponse(
        context, ApiHandlerUtils.getDiscoverUrl());
    putCacheString(cacheKey, response);
    return response;
  }

  static Future<String> hitUserSpecificDiscoverApiAndSaveCache(
      BuildContext context, String cacheKey) async {
    var response = await ApiHandler.getDiscoverListResponse(
        context, ApiHandlerUtils.getUserSpecificDiscoverUrl());
    putCacheString(cacheKey, response);
    return response;
  }

  ///
  /// Discover List Api Method - END
  ///
}
