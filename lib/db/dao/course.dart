import 'package:floor/floor.dart';
import 'package:xhu_timetable_ios/db/entity/course.dart';

@dao
abstract class CourseDao {
  @Query(
      'DELETE FROM tb_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<void> deleteOld(int year, int term, String studentId);

  @insert
  Future<void> insertData(CourseEntity course);

  @Query(
      'SELECT * FROM tb_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<List<CourseEntity>> queryCourse(int year, int term, String studentId);
}
