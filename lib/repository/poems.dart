import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:xhu_timetable_ios/repository/api/poems.dart';
import 'package:xhu_timetable_ios/repository/store/store.dart';

Future<String> _getToken() async {
  File dir = await getPoemsStore();
  File file = File('${dir.path}/token');
  if (!file.existsSync()) {
    var dio = getPoemsClient();
    var response = await dio.get('/token');
    var token = response.data['data'];
    await file.writeAsString(token);
    return token;
  }
  return file.readAsString();
}

Future<PoemsResponse> getPoems() async {
  var token = await _getToken();
  var dio = getPoemsClient();
  dio.options.headers['X-User-Token'] = token;
  var response = await dio.get('/sentence');
  var data = response.data;
  dynamic jsonList = json.decode(data);
  return PoemsResponse.fromJson(jsonList);
}

class PoemsResponse {
  final String content;
  final PoemsOrigin origin;

  PoemsResponse({required this.content, required this.origin});

  factory PoemsResponse.fromJson(Map<String, dynamic> json) {
    return PoemsResponse(
      content: json['content'],
      origin: PoemsOrigin.fromJson(json['origin']),
    );
  }
}

class PoemsOrigin {
  final String title;
  final String dynasty;
  final String author;
  final List<String> content;
  final List<String>? translate;

  PoemsOrigin(
      {required this.title,
      required this.dynasty,
      required this.author,
      required this.content,
      required this.translate});

  factory PoemsOrigin.fromJson(Map<String, dynamic> json) {
    return PoemsOrigin(
      title: json['title'],
      dynasty: json['dynasty'],
      author: json['author'],
      content: json['content'],
      translate: json['translate'],
    );
  }
}
