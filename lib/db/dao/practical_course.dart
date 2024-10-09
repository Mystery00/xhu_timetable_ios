import 'package:floor/floor.dart';
import 'package:xhu_timetable_ios/db/entity/practical_course.dart';

@dao
abstract class PracticalCourseDao {
  @Query(
      'DELETE FROM tb_practical_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<void> deleteOld(int year, int term, String studentId);

  @insert
  Future<void> insertData(PracticalCourseEntity practicalCourse);

  @Query(
      'SELECT * FROM tb_practical_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<List<PracticalCourseEntity>> queryPracticalCourse(
      int year, int term, String studentId);
}
