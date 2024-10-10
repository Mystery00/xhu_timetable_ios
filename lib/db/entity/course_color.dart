import 'package:floor/floor.dart';

@Entity(tableName: 'tb_course_color')
class CourseColorEntity {
  @primaryKey
  int? id;
  final String courseName;
  final String color;

  CourseColorEntity({
    this.id,
    required this.courseName,
    required this.color,
  });
}
