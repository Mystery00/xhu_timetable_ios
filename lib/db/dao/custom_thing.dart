import 'package:floor/floor.dart';
import 'package:xhu_timetable_ios/db/entity/course_color.dart';
import 'package:xhu_timetable_ios/db/entity/custom_thing.dart';

@dao
abstract class CustomThingDao {
  @insert
  Future<void> insertData(CustomThingEntity entity);

  @delete
  Future<void> deleteData(CustomThingEntity entity);

  @Query('SELECT * FROM tb_custom_thing WHERE studentId = :username')
  Future<List<CustomThingEntity>> queryByUsername(String username);
}
