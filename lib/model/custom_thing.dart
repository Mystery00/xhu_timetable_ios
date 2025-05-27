import 'dart:ui';

import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

class CustomThingResponse {
  final int thingId;
  final String title;
  final String location;
  final bool allDay;
  final DateTime startTime;
  final DateTime endTime;
  final String remark;
  final Color color;
  final String metadata;
  final DateTime createTime;

  CustomThingResponse({
    required this.thingId,
    required this.title,
    required this.location,
    required this.allDay,
    required this.startTime,
    required this.endTime,
    required this.remark,
    required this.color,
    required this.metadata,
    required this.createTime,
  });

  factory CustomThingResponse.fromJson(Map<String, dynamic> json) {
    return CustomThingResponse(
      thingId: json['thingId'],
      title: json['title'],
      location: json['location'],
      allDay: json['allDay'],
      startTime: DateTimeExt.instant(json['startTime']),
      endTime: DateTimeExt.instant(json['endTime']),
      remark: json['remark'],
      color: HexColor.fromHex(json['color']),
      metadata: json['metadata'],
      createTime: DateTimeExt.instant(json['createTime']),
    );
  }
}

class CustomThingRequest {
  final String title;
  final String location;
  final bool allDay;
  final int startTime;
  final int endTime;
  final String remark;
  final String color;
  final String metadata;

  CustomThingRequest(
      {required this.title,
      required this.location,
      required this.allDay,
      required this.startTime,
      required this.endTime,
      required this.remark,
      required this.color,
      required this.metadata});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'allDay': allDay,
      'startTime': startTime,
      'endTime': endTime,
      'remark': remark,
      'color': color,
      'metadata': metadata,
    };
  }
}
