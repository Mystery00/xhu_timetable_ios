import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';

const _profileImageList = [
  AssetImage("assets/icons/profile/img_boy1.webp"),
  AssetImage("assets/icons/profile/img_boy2.webp"),
  AssetImage("assets/icons/profile/img_boy3.webp"),
  AssetImage("assets/icons/profile/img_boy4.webp"),
  AssetImage("assets/icons/profile/img_girl1.webp"),
  AssetImage("assets/icons/profile/img_girl2.webp"),
  AssetImage("assets/icons/profile/img_girl3.webp"),
  AssetImage("assets/icons/profile/img_girl4.webp"),
];

ImageProvider defaultProfileImageByStudentId(String studentId) {
  var md5Index = md5.convert(utf8.encode(studentId)).toString().substring(0, 2);
  int index = int.parse(md5Index, radix: 16) % _profileImageList.length;
  return _profileImageList[index];
}
