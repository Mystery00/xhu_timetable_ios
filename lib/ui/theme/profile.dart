import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';

const _boyPool = [
  AssetImage("assets/icons/profile/img_boy1.webp"),
  AssetImage("assets/icons/profile/img_boy2.webp"),
  AssetImage("assets/icons/profile/img_boy3.webp"),
  AssetImage("assets/icons/profile/img_boy4.webp"),
];
const _girlPool = [
  AssetImage("assets/icons/profile/img_girl1.webp"),
  AssetImage("assets/icons/profile/img_girl2.webp"),
  AssetImage("assets/icons/profile/img_girl3.webp"),
  AssetImage("assets/icons/profile/img_girl4.webp"),
];

ImageProvider defaultProfileImageByStudentId(String userName, String gender) {
  var md5Index = md5.convert(utf8.encode(userName)).toString().substring(0, 2);
  var pool = gender == "男" ? _boyPool : _girlPool;
  return pool[int.parse(md5Index, radix: 16) % pool.length];
}
