import 'package:xhu_timetable_ios/repository/xhu.dart';

class NoticeResponse {
  final int noticeId;
  final String title;
  final String content;
  final bool released;
  final DateTime createTime;
  final DateTime updateTime;

  NoticeResponse({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.released,
    required this.createTime,
    required this.updateTime,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      noticeId: json['noticeId'],
      title: json['title'],
      content: json['content'],
      released: json['released'],
      createTime: DateTimeExt.instant(json['createTime']),
      updateTime: DateTimeExt.instant(json['updateTime']),
    );
  }
}
