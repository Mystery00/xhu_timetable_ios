import 'package:floor/floor.dart';

@Entity(tableName: 'tb_practical_course')
class PracticalCourseEntity {
  @primaryKey
  int? id;
  final String courseName;
  final String weekStr;
  final String weekList;
  final String teacher;
  final String campus;
  final double credit;
  final int year;
  final int term;
  final String studentId;

  PracticalCourseEntity({
    this.id,
    required this.courseName,
    required this.weekStr,
    required this.weekList,
    required this.teacher,
    required this.campus,
    required this.credit,
    required this.year,
    required this.term,
    required this.studentId,
  });
}
