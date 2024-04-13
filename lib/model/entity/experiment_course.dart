const String tableExperimentCourse = 'tb_experiment_course';

class ExperimentCourseEntity {
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'experimentProjectName': experimentProjectName,
      'teacherName': teacherName,
      'experimentGroupName': experimentGroupName,
      'weekStr': weekStr,
      'weekList': weekList,
      'dayIndex': dayIndex,
      'startDayTime': startDayTime,
      'endDayTime': endDayTime,
      'startTime': startTime,
      'endTime': endTime,
      'region': region,
      'location': location,
      'year': year,
      'term': term,
      'studentId': studentId,
    };
  }

  factory ExperimentCourseEntity.fromMap(Map<String, Object?> map) {
    return ExperimentCourseEntity(
      id: map['id'] as int?,
      courseName: map['courseName'] as String,
      experimentProjectName: map['experimentProjectName'] as String,
      teacherName: map['teacherName'] as String,
      experimentGroupName: map['experimentGroupName'] as String,
      weekStr: map['weekStr'] as String,
      weekList: map['weekList'] as String,
      dayIndex: map['dayIndex'] as int,
      startDayTime: map['startDayTime'] as int,
      endDayTime: map['endDayTime'] as int,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      region: map['region'] as String,
      location: map['location'] as String,
      year: map['year'] as int,
      term: map['term'] as int,
      studentId: map['studentId'] as String,
    );
  }

  @override
  String toString() {
    return 'ExperimentCourseEntity{id: $id, courseName: $courseName, experimentProjectName: $experimentProjectName, teacherName: $teacherName, experimentGroupName: $experimentGroupName, weekStr: $weekStr, weekList: $weekList, dayIndex: $dayIndex, startDayTime: $startDayTime, endDayTime: $endDayTime, startTime: $startTime, endTime: $endTime, region: $region, location: $location, year: $year, term: $term, studentId: $studentId}';
  }
}
