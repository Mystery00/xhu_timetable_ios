import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Database? _db;
Database database() => _db!;

Future<void> initDatabase() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  _db = await openDatabase(join(dir, "app.db"), onCreate: (db, version) {
    db.execute('''
          CREATE TABLE `tb_course` (
            `courseName` TEXT NOT NULL,
            `weekStr` TEXT NOT NULL,
            `weekList` TEXT NOT NULL, 
            `dayIndex` INTEGER NOT NULL,
            `startDayTime` INTEGER NOT NULL,
            `endDayTime` INTEGER NOT NULL,
            `startTime` TEXT NOT NULL,
            `endTime` TEXT NOT NULL,
            `location` TEXT NOT NULL,
            `teacher` TEXT NOT NULL, 
            `extraData` TEXT NOT NULL, 
            `campus` TEXT NOT NULL,
            `courseType` TEXT NOT NULL,
            `credit` REAL NOT NULL, 
            `courseCodeType` TEXT NOT NULL,
            `courseCodeFlag` TEXT NOT NULL,
            `year` INTEGER NOT NULL, 
            `term` INTEGER NOT NULL, 
            `studentId` TEXT NOT NULL, 
            `id` INTEGER PRIMARY KEY AUTOINCREMENT
          )''');
    db.execute('''
          CREATE TABLE `tb_practical_course` (
            `courseName` TEXT NOT NULL, 
            `weekStr` TEXT NOT NULL, 
            `weekList` TEXT NOT NULL, 
            `teacher` TEXT NOT NULL, 
            `campus` TEXT NOT NULL, 
            `credit` REAL NOT NULL, 
            `year` INTEGER NOT NULL, 
            `term` INTEGER NOT NULL, 
            `studentId` TEXT NOT NULL, 
            `id` INTEGER PRIMARY KEY AUTOINCREMENT
            )''');
    db.execute('''
          CREATE TABLE `tb_experiment_course` (
            `courseName` TEXT NOT NULL, 
            `experimentProjectName` TEXT NOT NULL, 
            `teacherName` TEXT NOT NULL, 
            `experimentGroupName` TEXT NOT NULL, 
            `weekStr` TEXT NOT NULL, 
            `weekList` TEXT NOT NULL, 
            `dayIndex` INTEGER NOT NULL, 
            `startDayTime` INTEGER NOT NULL, 
            `endDayTime` INTEGER NOT NULL, 
            `startTime` TEXT NOT NULL, 
            `endTime` TEXT NOT NULL, 
            `region` TEXT NOT NULL, 
            `location` TEXT NOT NULL, 
            `year` INTEGER NOT NULL, 
            `term` INTEGER NOT NULL, 
            `studentId` TEXT NOT NULL, 
            `id` INTEGER PRIMARY KEY AUTOINCREMENT
            )''');
  }, version: 1);
}
