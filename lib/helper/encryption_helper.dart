import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  final String encryptionKey;
  final String iv;

  EncryptionHelper(this.encryptionKey, this.iv);

  String encryptData(String requestBody) {
    final key = Key.fromUtf8(encryptionKey);
    final ivObj = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(requestBody, iv: ivObj);
    return encrypted.base64;
  }

  String decryptResponseBody(String encryptedBody) {
    final key = Key.fromUtf8(encryptionKey);
    final ivObj = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt64(encryptedBody, iv: ivObj);
    return decrypted;
  }
}
