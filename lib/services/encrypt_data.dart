import 'package:encrypt/encrypt.dart';


class EncryptData {
  
  static final key = Key.fromUtf8('my 32 length key................');
  static final iv = IV.fromBase64('/ziY7nLbqJnE8/LZbb2cRw==');
  static final encrypter = Encrypter(AES(key));

  String encrypt(String plainText) {

    Stopwatch stopwatch = Stopwatch();
    // Запуск стопwachа
    stopwatch.start();

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Остановка стопwachа
    stopwatch.stop();

    // Получение времени выполнения в миллисекундах
    int elapsedMilliseconds = stopwatch.elapsedMilliseconds;

    //print('Время выполнения функции шифрования: $elapsedMilliseconds миллисекунд');
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    Stopwatch stopwatch = Stopwatch();
    // Запуск стопwachа
    stopwatch.start();
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    // Остановка стопwachа
    stopwatch.stop();

    // Получение времени выполнения в миллисекундах
    int elapsedMilliseconds = stopwatch.elapsedMilliseconds;

    //print('Время выполнения функции дешифрования: $elapsedMilliseconds миллисекунд');
    return decrypted;
  }

}


EncryptData cypher = EncryptData();