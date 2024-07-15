import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'SPModels/DraftUploadContentRequestToServer.dart';
import 'SharedPrefUtil.dart';

class SharedPrefUtilDraftUpload {

  ///
  ///Upload Content Related Methods - START
  ///

  static Future<DraftUploadContentRequestToServer> getDraftUploadContent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString(SharedPrefUtil.KEY_UPLOAD_CONTENT_DRAFT_DATA);

      Map<String, dynamic> user = json.decode(data);

      DraftUploadContentRequestToServer object =
          new DraftUploadContentRequestToServer.fromJson(user);
      return object;
    } catch (e) {
      print("Munish Thakur -> getDraftUploadContent() -> ${e.toString()}");
    }
    return DraftUploadContentRequestToServer();
  }

  static Future<bool> _updateDraftUploadContent(String dataToSavae) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefUtil.KEY_UPLOAD_CONTENT_DRAFT_DATA, dataToSavae);

    return true;
  }

  static Future<bool> _saveDraftUploadContentData(
      DraftUploadContentRequestToServer objectToSave) async {
    Map<String, dynamic> res = objectToSave.toJson();
    String dataToSavae = json.encode(res);
    if (objectToSave != null) {
      await _updateDraftUploadContent(dataToSavae);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> queueDraftUploadContent(
      RequestDraftUploadData uploadData) async {
    if (uploadData != null) {
      Map<String, RequestDraftUploadData> mapOfData = Map();
      mapOfData[uploadData.getUID()] = (uploadData);
      return queueDraftUploadContentAll(mapOfData);
    }
    return false;
  }

  static Future<bool> queueDraftUploadContentAll(
      Map<String, RequestDraftUploadData> dataList) async {
    var contentToUpload = await getDraftUploadContent();

    dataList?.forEach((key, draftData) {
      contentToUpload.data[key] = draftData;
    });

    await _saveDraftUploadContentData(contentToUpload);

    return true;
  }

  static Future<DraftUploadContentRequestToServer>
  removeDraftUploadContentInQueue(
      RequestDraftUploadData uploadContent) async {
    if (uploadContent != null) {
      var draftContents = await getDraftUploadContent();

      draftContents.data.remove(uploadContent.getUID());

      // TEMP CODE - MUNISH THAKUR (Remove all Draft content in SP)
      //draftContents = DraftUploadContentRequestToServer(data: Map());

      await _saveDraftUploadContentData(draftContents);
      return draftContents;
    }

    return null;
  }

  static Future<DraftUploadContentRequestToServer> removeDraftUploadContentInQueueById(String UID) async {
    if (UID != null) {
      var draftContents = await getDraftUploadContent();

      draftContents.data.remove(UID);

      await _saveDraftUploadContentData(draftContents);
      return draftContents;
    }

    return null;
  }


  ///
  ///Upload Content Related Methods - END
  ///

}
