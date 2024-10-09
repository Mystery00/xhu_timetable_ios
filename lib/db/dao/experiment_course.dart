import 'package:floor/floor.dart';
import 'package:xhu_timetable_ios/db/entity/experiment_course.dart';

@dao
abstract class ExperimentCourseDao {
  @Query(
      'DELETE FROM tb_experiment_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<void> deleteOld(int year, int term, String studentId);

  @insert
  Future<void> insertData(ExperimentCourseEntity experimentCourse);

  @Query(
      'SELECT * FROM tb_experiment_course WHERE year = :year AND term = :term AND studentId = :studentId')
  Future<List<ExperimentCourseEntity>> queryExperimentCourse(
      int year, int term, String studentId);
}
