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
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFFE53935),
    Color(0xFF8E24AA),
    Color(0xFFFB8C00),
    Color(0xFF3949AB),
    Color(0xFF00ACC1),
    Color(0xFF7CB342),
    Color(0xFFD81B60),
    Color(0xFF5E35B1),
    Color(0xFF00897B),
    Color(0xFF6D4C41),
    Color(0xFF546E7A),
    Color(0xFFEC407A),
    Color(0xFFAB47BC)
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

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${_floatToInt8(a).toInt().toRadixString(16).padLeft(2, '0')}'
      '${_floatToInt8(r).toInt().toRadixString(16).padLeft(2, '0')}'
      '${_floatToInt8(g).toInt().toRadixString(16).padLeft(2, '0')}'
      '${_floatToInt8(b).toInt().toRadixString(16).padLeft(2, '0')}';
}

extension ARGBColor on Color {
  Color copyWithOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }
}
