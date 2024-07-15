
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'package:tymoff/SharedPref/SPModels/DraftUploadContentRequestToServer.dart';
import 'package:tymoff/Utils/AppUtils.dart';

enum ImageLightFilter {
  BRIGHTNESS, CONTRAST
}

class FilterImageMeta {
  static RequestUploadDataFileInfo getImageData(FilterImageMeta filterMediaMeta) {
    return RequestUploadDataFileInfo(filterMediaMeta.mediaFileName, filterMediaMeta.mediaFileFiltered.path);
  }

  String mediaFileName;
  File mediaFileOriginal;

  Filter appliedFilter;
  File mediaFileFiltered;
  imageLib.Image mediaFilterLib;

  double contrast = 1;
  double brightness = 0;

  int fileSize = 0;
  String fileSizeInWords = "";

  FilterImageMeta(this.mediaFileOriginal) {
    mediaFileFiltered = mediaFileOriginal;
    mediaFileName = basename(mediaFileOriginal.path);

    mediaFilterLib = imageLib.decodeImage(mediaFileOriginal.readAsBytesSync());
    mediaFilterLib = imageLib.copyResize(mediaFilterLib, width: 600);

    fileSize = AppUtils.checkFileSize(mediaFileFiltered);
    fileSizeInWords = filesize(fileSize, 1);
  }

  Future<FilterImageMeta> handleImageToOriginal(Filter activeFilter) async {
    mediaFileFiltered = mediaFileOriginal;
    mediaFileName = basename(mediaFileOriginal.path);

    mediaFilterLib = imageLib.decodeImage(mediaFileOriginal.readAsBytesSync());
    mediaFilterLib = imageLib.copyResize(mediaFilterLib, width: 600);

    return this;
  }

  void setImageFiltered(List<int> dataInBytes, File imageFileFiltered) {

    var imageFilter = imageLib.decodeImage(dataInBytes);

    this.mediaFilterLib = imageFilter;
    this.mediaFileFiltered = imageFileFiltered;
  }

  void setImageFilteredOnlyFile(File imageFileFiltered) {

    var imageFilter = imageLib.decodeImage(imageFileFiltered.readAsBytesSync());

    this.mediaFilterLib = imageFilter;
    this.mediaFileFiltered = imageFileFiltered;
  }

  Future<void> setImageFilteredUsingBytes(List<int> bytes, ImageLightFilter imageBCFilter) async {

    this.mediaFilterLib = imageLib.decodeImage(bytes);

    mediaFileFiltered = await localFileFilterLight(imageBCFilter);
    mediaFileFiltered = await File(mediaFileFiltered.path).writeAsBytes(bytes);
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(Filter activeFilter) async {
    final path = await _localPath;
    return File(
        '$path/filtered_${activeFilter?.name ?? "_"}_$mediaFileName');
  }

  Future<File> localFileFilterLight(ImageLightFilter imageBCFilter) async {
    String activeLightFilter = "";
    if(imageBCFilter != null) {
      if(imageBCFilter == ImageLightFilter.BRIGHTNESS) {
        activeLightFilter = "brightness";
      } else if(imageBCFilter == ImageLightFilter.CONTRAST) {
        activeLightFilter = "contrast";
      }
    }

    final path = await _localPath;
    return File(
        '$path/filtered_${activeLightFilter}_$mediaFileName');
  }

}