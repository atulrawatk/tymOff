enum AppContentType { text, image, video, article, gif, youtube }

class ContentTypeUtils {
  static const int APP_CONTENT_TYPE_TEXT = 1;
  static const int APP_CONTENT_TYPE_VIDEO = 2;
  static const int APP_CONTENT_TYPE_ARTICLE = 3;
  static const int APP_CONTENT_TYPE_IMAGE = 4;

  static AppContentType getType(int typeId, {String contentUrl}) {
    AppContentType type;
    switch (typeId) {
      case APP_CONTENT_TYPE_TEXT:
        type = AppContentType.text;
        break;
      case APP_CONTENT_TYPE_VIDEO:
        type = AppContentType.video;
        break;
      case APP_CONTENT_TYPE_ARTICLE:
        {
          if (contentUrl != null) {
            if (isYouTubeUrl(contentUrl)) {
              type = AppContentType.youtube;
            }
          }

          if (type == null) {
            type = AppContentType.article;
          }
        }
        break;
      case APP_CONTENT_TYPE_IMAGE:
        type = AppContentType.image;
        break;
    }

    return type;
  }

  static bool isYouTubeUrl(String contentUrl) {
    bool matchesFound = false;
    try {
      String regEx = "^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?";
      RegExp expression = RegExp(
        regEx,
        multiLine: true,
        caseSensitive: false,
      );

      var itrMatches = expression.allMatches(contentUrl);
      matchesFound = itrMatches.length > 0;

      print(
          "\nMunish Thakur -> Youtube matches: $itrMatches -> Found: $matchesFound");
    } catch (e) {}

    return matchesFound;
  }
}
