


import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'AppEnums.dart';

class FileUtils {

  Future<File> writeToFile(ByteData data, MediaType type) async {
    String dir = (await getApplicationDocumentsDirectory()).path;

    var fileName = DateTime.now().millisecondsSinceEpoch;
    var extension = _getExtension(type);

    var path = '$dir/$fileName.$extension';
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _getExtension(MediaType type) {
    var extension = "";
    switch(type) {
      case MediaType.text:
        break;
      case MediaType.image:
        extension = ".jpg";
        break;
      case MediaType.video:
        extension = ".mp4";
        break;
      case MediaType.article:
        break;
      case MediaType.gif:
        extension = ".gif";
        break;
    }

    return extension;
  }

  static String getFontForText(int contentId,List<String> textFonts){
    String textFontFamily = "";
    var id = contentId;
    var lengthOfArrayOfFonts = (textFonts?.length ?? 0);
    if(id != null && lengthOfArrayOfFonts != null){
      int fontIndex = id % lengthOfArrayOfFonts;
      String fontName = textFonts[fontIndex];
      textFontFamily = textFontFamily + fontName;
    }else{
      textFontFamily = "Nickelodeon";
    }
    return textFontFamily;


  }

  static String capitalizeString(String name) {
      if (name == null) return "";

      name = name.trim();
      if ((name.length ?? 0) <= 0) return "";
      String subStringFinal = "";

      /// capitalize the first letter of the name...
      List<String> stringValue = name.split(" ");
      stringValue?.forEach((stringToCap) {
        var capString = stringToCap.substring(0, 1).toUpperCase() +
            stringToCap.substring(1).toLowerCase();
        subStringFinal = subStringFinal + " " + capString;
      });
      return subStringFinal.trim();
  }
}