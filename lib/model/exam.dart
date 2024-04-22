import 'package:xhu_timetable_ios/repository/xhu.dart';

class ExamResponse {
  final String courseNo;
  final String courseName;
  final String location;
  final String seatNo;
  final String examName;
  final DateTime examDay;
  final DateTime examStartTime;
  final DateTime examEndTime;
  final DateTime examStartTimeMills;
  final DateTime examEndTimeMills;
  final String examRegion;

  ExamResponse({
    required this.courseNo,
    required this.courseName,
    required this.location,
    required this.seatNo,
    required this.examName,
    required this.examDay,
    required this.examStartTime,
    required this.examEndTime,
    required this.examStartTimeMills,
    required this.examEndTimeMills,
    required this.examRegion,
  });

  factory ExamResponse.fromJson(Map<String, dynamic> json) {
    return ExamResponse(
      courseNo: json['courseNo'],
      courseName: json['courseName'],
      location: json['location'],
      seatNo: json['seatNo'],
      examName: json['examName'],
      examDay: DateTimeExt.localDate(json['examDay']),
      examStartTime: DateTimeExt.localTime(json['examStartTime']),
      examEndTime: DateTimeExt.localTime(json['examEndTime']),
      examStartTimeMills: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['examStartTimeMills'].toString())),
      examEndTimeMills: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['examEndTimeMills'].toString())),
      examRegion: json['examRegion'],
    );
  }
}
