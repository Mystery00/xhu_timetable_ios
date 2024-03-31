import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;
import 'package:basic_utils/basic_utils.dart';
import 'package:xhu_timetable_ios/api/rest/user.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

Future<User> doLogin(String username, String password) async {
  var publicKeyBase64 = await apiGetPublicKey();
  var passwordEncrypted = encryptStringWithRSA(publicKeyBase64, password);
  var sessionToken =
      await apiLogin(username, passwordEncrypted, publicKeyBase64);
  var userInfo = await apiGetUserInfo(sessionToken);
  var user = User(
      studentId: username,
      password: password,
      token: sessionToken,
      userInfo: userInfo,
      profileImage: null);
  await login(user);
  return user;
}

String encryptStringWithRSA(String publicKeyBase64, String plaintext) {
  var publicKeyAsUint8List = base64.decode(publicKeyBase64);
  var rsaPublicKey =
      CryptoUtils.rsaPublicKeyFromDERBytes(publicKeyAsUint8List);
  final encryptor = pc.PKCS1Encoding(pc.RSAEngine())
    ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(rsaPublicKey));
  final Uint8List encoded = utf8.encode(plaintext);
  final Uint8List encrypted = encryptor.process(encoded);
  return base64.encode(encrypted);
}
