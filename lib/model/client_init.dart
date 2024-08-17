import 'package:xhu_timetable_ios/repository/xhu.dart';

class ClientInitResponse {
  final XhuStartTime xhuStartTime;
  final List<Splash> splash;

  ClientInitResponse({required this.xhuStartTime, required this.splash});

  factory ClientInitResponse.fromJson(Map<String, dynamic> json) {
    return ClientInitResponse(
      xhuStartTime: XhuStartTime.fromJson(json['xhuStartTime']),
      splash: (json['splash'] as List).map((e) => Splash.fromJson(e)).toList(),
    );
  }
}

class XhuStartTime {
  final DateTime startDate;
  final int nowYear;
  final int nowTerm;

  XhuStartTime(
      {required this.startDate, required this.nowYear, required this.nowTerm});

  factory XhuStartTime.fromJson(Map<String, dynamic> json) {
    return XhuStartTime(
      startDate: DateTime.parse(json['startDate']),
      nowYear: json['nowYear'],
      nowTerm: json['nowTerm'],
    );
  }
}

class Splash {
  final int splashId;
  final String imageUrl;
  final String backgroundColor;
  final String locationUrl;
  final int showTime;
  final DateTime startShowTime;
  final DateTime endShowTime;

  Splash(
      {required this.splashId,
      required this.imageUrl,
      required this.backgroundColor,
      required this.locationUrl,
      required this.showTime,
      required this.startShowTime,
      required this.endShowTime});

  factory Splash.fromJson(Map<String, dynamic> json) {
    return Splash(
      splashId: json['splashId'],
      imageUrl: json['imageUrl'],
      backgroundColor: json['backgroundColor'],
      locationUrl: json['locationUrl'],
      showTime: json['showTime'],
      startShowTime: DateTimeExt.instant(json['startShowTime']),
      endShowTime: DateTimeExt.instant(json['endShowTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'splashId': splashId,
      'imageUrl': imageUrl,
      'backgroundColor': backgroundColor,
      'locationUrl': locationUrl,
      'showTime': showTime,
      'startShowTime': startShowTime.millisecondsSinceEpoch,
      'endShowTime': endShowTime.millisecondsSinceEpoch,
    };
  }
}
