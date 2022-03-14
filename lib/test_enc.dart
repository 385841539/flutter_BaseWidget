import 'package:encrypt/encrypt.dart';


class TestEnc {
  void enc() {
    Future.delayed(Duration(milliseconds: 300),(){

    });
    final plainText = '1rrr';
    final key = Key.fromUtf8('fb iv32get lovesfb iv32get loves');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print("enc---$decrypted"); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print("enc--${encrypted.base64}"); // R
  }
}
