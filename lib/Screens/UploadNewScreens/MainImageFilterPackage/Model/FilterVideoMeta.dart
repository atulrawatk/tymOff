
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FilterVideoMeta {

  static RequestUploadDataFileInfo getVideoData(FilterVideoMeta filterMediaMeta) {
    return RequestUploadDataFileInfo(filterMediaMeta.mediaFileName, filterMediaMeta.mediaFileFiltered.path, thumbnail: filterMediaMeta.thumbnail);
  }

  String mediaFileName;
  List<int> thumbnail;
  File mediaFileOriginal;
  File mediaFileFiltered;
  int fileSize = 0;
  String fileSizeInWords = "";

  FilterVideoMeta(this.mediaFileOriginal) {
    mediaFileFiltered = mediaFileOriginal;
    mediaFileName = basename(mediaFileOriginal.path);

    fileSize = AppUtils.checkFileSize(mediaFileFiltered);
    fileSizeInWords = filesize(fileSize, 1);
  }

  Future<void> generateThumbnail() async {
    thumbnail =  await VideoThumbnail.thumbnailData(
      video: mediaFileOriginal.path,
      imageFormat: ImageFormat.JPEG,
      maxHeightOrWidth: 600,
      quality: 100,
    );

    return;
  }

  String getUdid() => mediaFileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(Filter activeFilter) async {
    final path = await _localPath;
    return File(
        '$path/filtered_${activeFilter?.name ?? "_"}_$mediaFileName');
  }
}