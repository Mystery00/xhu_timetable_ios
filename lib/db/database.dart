import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:xhu_timetable_ios/db/dao/course.dart';
import 'package:xhu_timetable_ios/db/dao/course_color.dart';
import 'package:xhu_timetable_ios/db/dao/custom_thing.dart';
import 'package:xhu_timetable_ios/db/dao/experiment_course.dart';
import 'package:xhu_timetable_ios/db/dao/practical_course.dart';
import 'package:xhu_timetable_ios/db/entity/course.dart';
import 'package:xhu_timetable_ios/db/entity/course_color.dart';
import 'package:xhu_timetable_ios/db/entity/custom_thing.dart';
import 'package:xhu_timetable_ios/db/entity/experiment_course.dart';
import 'package:xhu_timetable_ios/db/entity/practical_course.dart';

part 'database.g.dart';

@Database(version: 3, entities: [
  CourseEntity,
  PracticalCourseEntity,
  ExperimentCourseEntity,
  CourseColorEntity,
  CustomThingEntity,
])
abstract class AppDatabase extends FloorDatabase {
  CourseDao get courseDao;

  PracticalCourseDao get practicalCourseDao;

  ExperimentCourseDao get experimentCourseDao;

  CourseColorDao get courseColorDao;

  CustomThingDao get customThingDao;
}

class DataBaseManager {
  static final migration_1_2 = Migration(1, 2, (database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS tb_course_color (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseName TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');
  });
  static final migration_2_3 = Migration(2, 3, (database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS tb_custom_thing (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        thingId INTEGER NOT NULL, 
        title TEXT NOT NULL, 
        location TEXT NOT NULL, 
        allDay INTEGER NOT NULL, 
        startTime INTEGER NOT NULL, 
        endTime INTEGER NOT NULL, 
        remark TEXT NOT NULL, 
        color TEXT NOT NULL, 
        metadata TEXT NOT NULL, 
        createTime INTEGER NOT NULL, 
        studentId TEXT NOT NULL
      )
    ''');
  });

  static Future<AppDatabase> database() async {
    return await $FloorAppDatabase.databaseBuilder('app.db').addMigrations([
      migration_1_2,
      migration_2_3,
    ]).build();
  }
}
