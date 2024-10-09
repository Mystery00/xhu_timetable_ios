import 'package:floor/floor.dart';

@Entity(tableName: 'tb_experiment_course')
class ExperimentCourseEntity {
  @primaryKey
  int? id;
  final String courseName;
  final String experimentProjectName;
  final String teacherName;
  final String experimentGroupName;
  final String weekStr;
  final String weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String region;
  final String location;
  final int year;
  final int term;
  final String studentId;

  ExperimentCourseEntity({
    this.id,
    required this.courseName,
    required this.experimentProjectName,
    required this.teacherName,
    required this.experimentGroupName,
    required this.weekStr,
    required this.weekList,
    required this.dayIndex,
    required this.startDayTime,
    required this.endDayTime,
    required this.startTime,
    required this.endTime,
    required this.region,
    required this.location,
    required this.year,
    required this.term,
    required this.studentId,
  });
}
