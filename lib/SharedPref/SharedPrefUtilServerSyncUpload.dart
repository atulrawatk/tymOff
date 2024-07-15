import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/UploadContentResponse.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';

import 'SPModels/DraftUploadContentRequestToServer.dart';
import 'SPModels/SyncUploadContentRequestToServer.dart';
import 'SharedPrefUtil.dart';
import 'SharedPrefUtilDraftUpload.dart';

class SharedPrefUtilServerSyncUpload {

  ///
  ///Upload Content Related Methods - START
  ///

  static Future<SyncUploadContentRequestToServer> getServerSyncUploadContent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString(SharedPrefUtil.KEY_UPLOAD_CONTENT_SERVER_SYNC_DATA);

      Map<String, dynamic> user = json.decode(data);

      SyncUploadContentRequestToServer object =
          new SyncUploadContentRequestToServer.fromJson(user);
      return object;
    } catch (e) {
      print("Munish Thakur -> getServerSyncUploadContent() -> ${e.toString()}");
    }
    return SyncUploadContentRequestToServer();
  }

  static Future<bool> _updateServerSyncUploadContent(String dataToSavae) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefUtil.KEY_UPLOAD_CONTENT_SERVER_SYNC_DATA, dataToSavae);

    return true;
  }

  static Future<bool> _saveServerSyncUploadContentData(
      SyncUploadContentRequestToServer objectToSave) async {
    Map<String, dynamic> res = objectToSave.toJson();
    String dataToSavae = json.encode(res);
    if (objectToSave != null) {
      await _updateServerSyncUploadContent(dataToSavae);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> queueServerSyncUploadContent(
      RequestUploadDataToServer uploadData) async {
    if (uploadData != null) {
      Map<String, RequestUploadDataToServer> mapOfData = Map();
      mapOfData[uploadData.getUID()] = (uploadData);
      return queueServerSyncUploadContentAll(mapOfData);
    }
    return false;
  }

  static Future<bool> queueServerSyncUploadContentAll(
      Map<String, RequestUploadDataToServer> dataList) async {
    var contentToUpload = await getServerSyncUploadContent();

    dataList?.forEach((key, draftData) {
      contentToUpload.data[key] = draftData;
    });

    await _saveServerSyncUploadContentData(contentToUpload);

    return true;
  }

  static Future<void> updateServerSyncData(UploadContentResponse uploadContentResponse) async {

    DraftUploadContentRequestToServer _draftUploadContent = await SharedPrefUtilDraftUpload.getDraftUploadContent();
    Map<String, RequestDraftUploadData> _draftData = _draftUploadContent.data;

    Map<String, RequestUploadDataToServer> _serverSyncData = Map();

    for(int index = 0; index < (uploadContentResponse?.data?.dataList?.length ?? 0); index++) {
      ResponseUploadContentData _responseUploadContentData = uploadContentResponse.data.dataList[index];

      RequestUploadDataToServer requestUploadDataToServer = RequestUploadDataToServer();
      requestUploadDataToServer.contentId = _responseUploadContentData.contentId;
      requestUploadDataToServer.typeId = _responseUploadContentData.typeId;
      requestUploadDataToServer.requestDraftUploadData = _draftData[_responseUploadContentData.getLocalUID()];

      var contentType = ContentTypeUtils.getType(_responseUploadContentData.typeId);
      if(contentType == AppContentType.article) {

      } else if(contentType == AppContentType.text) {
        String contentId = (_responseUploadContentData?.contentId ?? "").toString();
        String descriptionRichText = requestUploadDataToServer?.requestDraftUploadData?.richTextStory ?? "";
        ApiHandler.uploadContentStories(contentId, descriptionRichText);
      } else {
        _serverSyncData[requestUploadDataToServer.getUID()] = requestUploadDataToServer;
      }

      await SharedPrefUtilDraftUpload.removeDraftUploadContentInQueueById(requestUploadDataToServer.requestDraftUploadData.getUID());
    }

    await queueServerSyncUploadContentAll(_serverSyncData);
  }

  static Future<void> updateUploadTaskId(String UID, String taskId) async {

    SyncUploadContentRequestToServer _syncUploadContent = await getServerSyncUploadContent();
    Map<String, RequestUploadDataToServer> _uploadingData = _syncUploadContent.data;

    if(UID != null && taskId != null) {
      var uploadingData = _uploadingData[UID];
      uploadingData.taskId = taskId;


      _uploadingData[UID] = uploadingData;
      _syncUploadContent.data = _uploadingData;

      await queueServerSyncUploadContentAll(_uploadingData);
    }
  }

  static Future<void> updateUploadingTask(RequestUploadDataToServer requestUploadDataToServer) async {

    Map<String, RequestUploadDataToServer> _uploadingData = Map();

    if(requestUploadDataToServer != null) {
      _uploadingData[requestUploadDataToServer.getUID()] = requestUploadDataToServer;

      await queueServerSyncUploadContentAll(_uploadingData);
    }
  }


  static Future<SyncUploadContentRequestToServer>
  removeServerSyncUploadContentInQueue(
      RequestUploadDataToServer uploadContent) async {
    if (uploadContent != null) {
      var savedContentData = await getServerSyncUploadContent();

      savedContentData.data.remove(uploadContent.getUID());

      // TEMP CODE - MUNISH THAKUR (Remove all ServerSync content in SP)
      //draftContents = SyncUploadContentRequestToServer(data: Map());

      await _saveServerSyncUploadContentData(savedContentData);
      return savedContentData;
    }

    return null;
  }

  static Future<SyncUploadContentRequestToServer> removeServerSyncUploadContentInQueueById(String UID) async {
    if (UID != null) {
      var savedContentData = await getServerSyncUploadContent();

      savedContentData.data.remove(UID);

      await _saveServerSyncUploadContentData(savedContentData);
      return savedContentData;
    }

    return null;
  }

  static Future<SyncUploadContentRequestToServer> removeServerSyncUploadContentInQueueByTaskId(String taskId) async {
    if (taskId != null) {
      var savedContentData = await getServerSyncUploadContent();

      var uidToRemove = "";
      savedContentData.data?.forEach((_UID, _contentData) {
        if(_contentData.taskId == taskId) {
          uidToRemove = _UID;
        }
      });

      savedContentData.data.remove(uidToRemove);

      await _saveServerSyncUploadContentData(savedContentData);
      return savedContentData;
    }

    return null;
  }

  ///
  ///Upload Content Related Methods - END
  ///

}
