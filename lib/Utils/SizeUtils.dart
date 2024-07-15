import 'package:format_bytes/format_bytes.dart';

class SizeUtils {

  static String getFormattedSize(int bytes) {
    double bytess = bytes / 2;
    return format(bytess);
  }
}