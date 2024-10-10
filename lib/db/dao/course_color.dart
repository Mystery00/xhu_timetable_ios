import 'package:floor/floor.dart';
import 'package:xhu_timetable_ios/db/entity/course_color.dart';

@dao
abstract class CourseColorDao {
  @insert
  Future<void> insertData(CourseColorEntity courseColor);

  @delete
  Future<void> deleteData(CourseColorEntity courseColor);

  @Query('SELECT * FROM tb_course_color WHERE courseName = :courseName limit 1')
  Future<CourseColorEntity?> queryCourseColor(String courseName);

  @Query('SELECT * FROM tb_course_color')
  Future<List<CourseColorEntity>> queryAllCourseColor();
}
