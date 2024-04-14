import 'package:encrypt/encrypt.dart';


class EncryptData {
  
  static final key = Key.fromUtf8('my 32 length key................');
  static final iv = IV.fromBase64('/ziY7nLbqJnE8/LZbb2cRw==');
  static final encrypter = Encrypter(AES(key));

  String encrypt(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

}


EncryptData cypher = EncryptData();