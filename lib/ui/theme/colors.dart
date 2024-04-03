import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class ProfileColor {
  static const List<Color> pool = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static Color safeGet(int index) {
    return pool[index % pool.length];
  }

  static Color hash(String text) {
    var md5Index = md5.convert(utf8.encode(text)).toString().substring(0, 2);
    int index = int.parse(md5Index, radix: 16) % pool.length;
    return pool[index];
  }
}

class ColorPool {
  static const List<Color> pool = [
    Color(0xFFF44336),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF2196F3),
    Color(0xFF03A9F4),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
    Color(0xFFCDDC39),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF9E9E9E),
    Color(0xFF607D8B),
  ];

  static Color random() {
    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    return pool[random.nextInt(pool.length)];
  }

  static Color safeGet(int index) {
    return pool[index % pool.length];
  }

  static Color hash(String text) {
    var md5Index = md5.convert(utf8.encode(text)).toString().substring(0, 2);
    return safeGet(int.parse(md5Index, radix: 16));
  }
}
