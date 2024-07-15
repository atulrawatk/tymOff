import 'package:encrypt/encrypt.dart';

class SecurityUtils {
  //password :: Tym@ff2@!9N@v

  static String _BycrptKey =
      "\$2a\$10\$RiZpsCSBnPNwOOYK.cIyn.oozqdurn3zXbAJBafjPlp50Hl8w0Kt6";

  static Future<String> encryptAES256(String toEncodeString) async {
    try {
      final key = Key.fromUtf8('12345678912345671234567891234567');
      final iv = IV.fromUtf8("1234567891234567");

      print("Iv -> ${iv.bytes}");
      final encrypter = Encrypter(AES(
        key,
        mode: AESMode.cbc,
      ));

      final encrypted = encrypter.encrypt(toEncodeString, iv: iv);

      return encrypted.base64;
    } catch (e) {
      print("Munish Thakur -> encryptAES256() -> $e");
    }
    return "";
  }

  static Future<String> encryptCombinedUdid(String toEncodeString) async {
    try {
      final encyptedAppUdid = await encryptAES256(toEncodeString);
      final combinedEncryptedUdid = "$encyptedAppUdid||$_BycrptKey";

      final encyptedFinalAppUdid = await encryptAES256(combinedEncryptedUdid);

      print("encyptedFinalAppUdid -> $encyptedFinalAppUdid");
      return encyptedFinalAppUdid;
    } catch (e) {
      print("Munish Thakur -> encryptCombinedUdid() -> $e");
    }
    return "";
  }
}
