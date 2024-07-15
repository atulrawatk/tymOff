
import 'package:tymoff/SharedPref/SharedPrefUtilDraftUpload.dart';
import 'package:tymoff/SharedPref/SharedPrefUtilServerSyncUpload.dart';

class UploadUtils {
  static Future<void> removeDraftUploadContent(String UID) async {
    await SharedPrefUtilDraftUpload.removeDraftUploadContentInQueueById(UID);
  }

  static void removeSyncUploadContent(String UID) async {
    await SharedPrefUtilServerSyncUpload.removeServerSyncUploadContentInQueueById(UID);
  }
}