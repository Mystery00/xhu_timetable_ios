import 'package:floor/floor.dart';

@Entity(tableName: 'tb_course')
class CourseEntity {
  @primaryKey
  int? id;
  final String courseName;
  final String weekStr;
  final String weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String location;
  final String teacher;
  final String extraData;
  final String campus;
  final String courseType;
  final double credit;
  final String courseCodeType;
  final String courseCodeFlag;
  final int year;
  final int term;
  final String studentId;

  CourseEntity({
    this.id,
    required this.courseName,
    required this.weekStr,
    required this.weekList,
    required this.dayIndex,
    required this.startDayTime,
    required this.endDayTime,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.teacher,
    required this.extraData,
    required this.campus,
    required this.courseType,
    required this.credit,
    required this.courseCodeType,
    required this.courseCodeFlag,
    required this.year,
    required this.term,
    required this.studentId,
  });
}
