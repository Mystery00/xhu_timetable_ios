// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CourseDao? _courseDaoInstance;

  PracticalCourseDao? _practicalCourseDaoInstance;

  ExperimentCourseDao? _experimentCourseDaoInstance;

  CourseColorDao? _courseColorDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_course` (`id` INTEGER, `courseName` TEXT NOT NULL, `weekStr` TEXT NOT NULL, `weekList` TEXT NOT NULL, `dayIndex` INTEGER NOT NULL, `startDayTime` INTEGER NOT NULL, `endDayTime` INTEGER NOT NULL, `startTime` TEXT NOT NULL, `endTime` TEXT NOT NULL, `location` TEXT NOT NULL, `teacher` TEXT NOT NULL, `extraData` TEXT NOT NULL, `campus` TEXT NOT NULL, `courseType` TEXT NOT NULL, `credit` REAL NOT NULL, `courseCodeType` TEXT NOT NULL, `courseCodeFlag` TEXT NOT NULL, `year` INTEGER NOT NULL, `term` INTEGER NOT NULL, `studentId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_practical_course` (`id` INTEGER, `courseName` TEXT NOT NULL, `weekStr` TEXT NOT NULL, `weekList` TEXT NOT NULL, `teacher` TEXT NOT NULL, `campus` TEXT NOT NULL, `credit` REAL NOT NULL, `year` INTEGER NOT NULL, `term` INTEGER NOT NULL, `studentId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_experiment_course` (`id` INTEGER, `courseName` TEXT NOT NULL, `experimentProjectName` TEXT NOT NULL, `teacherName` TEXT NOT NULL, `experimentGroupName` TEXT NOT NULL, `weekStr` TEXT NOT NULL, `weekList` TEXT NOT NULL, `dayIndex` INTEGER NOT NULL, `startDayTime` INTEGER NOT NULL, `endDayTime` INTEGER NOT NULL, `startTime` TEXT NOT NULL, `endTime` TEXT NOT NULL, `region` TEXT NOT NULL, `location` TEXT NOT NULL, `year` INTEGER NOT NULL, `term` INTEGER NOT NULL, `studentId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_course_color` (`id` INTEGER, `courseName` TEXT NOT NULL, `color` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CourseDao get courseDao {
    return _courseDaoInstance ??= _$CourseDao(database, changeListener);
  }

  @override
  PracticalCourseDao get practicalCourseDao {
    return _practicalCourseDaoInstance ??=
        _$PracticalCourseDao(database, changeListener);
  }

  @override
  ExperimentCourseDao get experimentCourseDao {
    return _experimentCourseDaoInstance ??=
        _$ExperimentCourseDao(database, changeListener);
  }

  @override
  CourseColorDao get courseColorDao {
    return _courseColorDaoInstance ??=
        _$CourseColorDao(database, changeListener);
  }
}

class _$CourseDao extends CourseDao {
  _$CourseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _courseEntityInsertionAdapter = InsertionAdapter(
            database,
            'tb_course',
            (CourseEntity item) => <String, Object?>{
                  'id': item.id,
                  'courseName': item.courseName,
                  'weekStr': item.weekStr,
                  'weekList': item.weekList,
                  'dayIndex': item.dayIndex,
                  'startDayTime': item.startDayTime,
                  'endDayTime': item.endDayTime,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'location': item.location,
                  'teacher': item.teacher,
                  'extraData': item.extraData,
                  'campus': item.campus,
                  'courseType': item.courseType,
                  'credit': item.credit,
                  'courseCodeType': item.courseCodeType,
                  'courseCodeFlag': item.courseCodeFlag,
                  'year': item.year,
                  'term': item.term,
                  'studentId': item.studentId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CourseEntity> _courseEntityInsertionAdapter;

  @override
  Future<void> deleteOld(
    int year,
    int term,
    String studentId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM tb_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<CourseEntity>> queryCourse(
    int year,
    int term,
    String studentId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        mapper: (Map<String, Object?> row) => CourseEntity(id: row['id'] as int?, courseName: row['courseName'] as String, weekStr: row['weekStr'] as String, weekList: row['weekList'] as String, dayIndex: row['dayIndex'] as int, startDayTime: row['startDayTime'] as int, endDayTime: row['endDayTime'] as int, startTime: row['startTime'] as String, endTime: row['endTime'] as String, location: row['location'] as String, teacher: row['teacher'] as String, extraData: row['extraData'] as String, campus: row['campus'] as String, courseType: row['courseType'] as String, credit: row['credit'] as double, courseCodeType: row['courseCodeType'] as String, courseCodeFlag: row['courseCodeFlag'] as String, year: row['year'] as int, term: row['term'] as int, studentId: row['studentId'] as String),
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<String>> queryAllCourseName() async {
    return _queryAdapter.queryList('SELECT distinct courseName FROM tb_course',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertData(CourseEntity course) async {
    await _courseEntityInsertionAdapter.insert(
        course, OnConflictStrategy.abort);
  }
}

class _$PracticalCourseDao extends PracticalCourseDao {
  _$PracticalCourseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _practicalCourseEntityInsertionAdapter = InsertionAdapter(
            database,
            'tb_practical_course',
            (PracticalCourseEntity item) => <String, Object?>{
                  'id': item.id,
                  'courseName': item.courseName,
                  'weekStr': item.weekStr,
                  'weekList': item.weekList,
                  'teacher': item.teacher,
                  'campus': item.campus,
                  'credit': item.credit,
                  'year': item.year,
                  'term': item.term,
                  'studentId': item.studentId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PracticalCourseEntity>
      _practicalCourseEntityInsertionAdapter;

  @override
  Future<void> deleteOld(
    int year,
    int term,
    String studentId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM tb_practical_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<PracticalCourseEntity>> queryPracticalCourse(
    int year,
    int term,
    String studentId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_practical_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        mapper: (Map<String, Object?> row) => PracticalCourseEntity(id: row['id'] as int?, courseName: row['courseName'] as String, weekStr: row['weekStr'] as String, weekList: row['weekList'] as String, teacher: row['teacher'] as String, campus: row['campus'] as String, credit: row['credit'] as double, year: row['year'] as int, term: row['term'] as int, studentId: row['studentId'] as String),
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<String>> queryAllCourseName() async {
    return _queryAdapter.queryList(
        'SELECT distinct courseName FROM tb_practical_course',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertData(PracticalCourseEntity practicalCourse) async {
    await _practicalCourseEntityInsertionAdapter.insert(
        practicalCourse, OnConflictStrategy.abort);
  }
}

class _$ExperimentCourseDao extends ExperimentCourseDao {
  _$ExperimentCourseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _experimentCourseEntityInsertionAdapter = InsertionAdapter(
            database,
            'tb_experiment_course',
            (ExperimentCourseEntity item) => <String, Object?>{
                  'id': item.id,
                  'courseName': item.courseName,
                  'experimentProjectName': item.experimentProjectName,
                  'teacherName': item.teacherName,
                  'experimentGroupName': item.experimentGroupName,
                  'weekStr': item.weekStr,
                  'weekList': item.weekList,
                  'dayIndex': item.dayIndex,
                  'startDayTime': item.startDayTime,
                  'endDayTime': item.endDayTime,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'region': item.region,
                  'location': item.location,
                  'year': item.year,
                  'term': item.term,
                  'studentId': item.studentId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExperimentCourseEntity>
      _experimentCourseEntityInsertionAdapter;

  @override
  Future<void> deleteOld(
    int year,
    int term,
    String studentId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM tb_experiment_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<ExperimentCourseEntity>> queryExperimentCourse(
    int year,
    int term,
    String studentId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_experiment_course WHERE year = ?1 AND term = ?2 AND studentId = ?3',
        mapper: (Map<String, Object?> row) => ExperimentCourseEntity(id: row['id'] as int?, courseName: row['courseName'] as String, experimentProjectName: row['experimentProjectName'] as String, teacherName: row['teacherName'] as String, experimentGroupName: row['experimentGroupName'] as String, weekStr: row['weekStr'] as String, weekList: row['weekList'] as String, dayIndex: row['dayIndex'] as int, startDayTime: row['startDayTime'] as int, endDayTime: row['endDayTime'] as int, startTime: row['startTime'] as String, endTime: row['endTime'] as String, region: row['region'] as String, location: row['location'] as String, year: row['year'] as int, term: row['term'] as int, studentId: row['studentId'] as String),
        arguments: [year, term, studentId]);
  }

  @override
  Future<List<String>> queryAllCourseName() async {
    return _queryAdapter.queryList(
        'SELECT distinct courseName FROM tb_experiment_course',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertData(ExperimentCourseEntity experimentCourse) async {
    await _experimentCourseEntityInsertionAdapter.insert(
        experimentCourse, OnConflictStrategy.abort);
  }
}

class _$CourseColorDao extends CourseColorDao {
  _$CourseColorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _courseColorEntityInsertionAdapter = InsertionAdapter(
            database,
            'tb_course_color',
            (CourseColorEntity item) => <String, Object?>{
                  'id': item.id,
                  'courseName': item.courseName,
                  'color': item.color
                }),
        _courseColorEntityDeletionAdapter = DeletionAdapter(
            database,
            'tb_course_color',
            ['id'],
            (CourseColorEntity item) => <String, Object?>{
                  'id': item.id,
                  'courseName': item.courseName,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CourseColorEntity> _courseColorEntityInsertionAdapter;

  final DeletionAdapter<CourseColorEntity> _courseColorEntityDeletionAdapter;

  @override
  Future<CourseColorEntity?> queryCourseColor(String courseName) async {
    return _queryAdapter.query(
        'SELECT * FROM tb_course_color WHERE courseName = ?1 limit 1',
        mapper: (Map<String, Object?> row) => CourseColorEntity(
            id: row['id'] as int?,
            courseName: row['courseName'] as String,
            color: row['color'] as String),
        arguments: [courseName]);
  }

  @override
  Future<List<CourseColorEntity>> queryAllCourseColor() async {
    return _queryAdapter.queryList('SELECT * FROM tb_course_color',
        mapper: (Map<String, Object?> row) => CourseColorEntity(
            id: row['id'] as int?,
            courseName: row['courseName'] as String,
            color: row['color'] as String));
  }

  @override
  Future<void> insertData(CourseColorEntity courseColor) async {
    await _courseColorEntityInsertionAdapter.insert(
        courseColor, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteData(CourseColorEntity courseColor) async {
    await _courseColorEntityDeletionAdapter.delete(courseColor);
  }
}
