const String tableCourse = 'tb_course';

class CourseEntity {
  int? id;
  final String courseName;
  final String weekStr;
  final String weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String location;
  final String teacher;
  final String extraData;
  final String campus;
  final String courseType;
  final double credit;
  final String courseCodeType;
  final String courseCodeFlag;
  final int year;
  final int term;
  final String studentId;

  CourseEntity({
    this.id,
    required this.courseName,
    required this.weekStr,
    required this.weekList,
    required this.dayIndex,
    required this.startDayTime,
    required this.endDayTime,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.teacher,
    required this.extraData,
    required this.campus,
    required this.courseType,
    required this.credit,
    required this.courseCodeType,
    required this.courseCodeFlag,
    required this.year,
    required this.term,
    required this.studentId,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'weekStr': weekStr,
      'weekList': weekList,
      'dayIndex': dayIndex,
      'startDayTime': startDayTime,
      'endDayTime': endDayTime,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'teacher': teacher,
      'extraData': extraData,
      'campus': campus,
      'courseType': courseType,
      'credit': credit,
      'courseCodeType': courseCodeType,
      'courseCodeFlag': courseCodeFlag,
      'year': year,
      'term': term,
      'studentId': studentId,
    };
  }

  factory CourseEntity.fromMap(Map<String, Object?> map) {
    return CourseEntity(
      id: map['id'] as int?,
      courseName: map['courseName'] as String,
      weekStr: map['weekStr'] as String,
      weekList: map['weekList'] as String,
      dayIndex: map['dayIndex'] as int,
      startDayTime: map['startDayTime'] as int,
      endDayTime: map['endDayTime'] as int,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      location: map['location'] as String,
      teacher: map['teacher'] as String,
      extraData: map['extraData'] as String,
      campus: map['campus'] as String,
      courseType: map['courseType'] as String,
      credit: map['credit'] as double,
      courseCodeType: map['courseCodeType'] as String,
      courseCodeFlag: map['courseCodeFlag'] as String,
      year: map['year'] as int,
      term: map['term'] as int,
      studentId: map['studentId'] as String,
    );
  }

  @override
  String toString() {
    return 'CourseEntity{id: $id, courseName: $courseName, weekStr: $weekStr, weekList: $weekList, dayIndex: $dayIndex, startDayTime: $startDayTime, endDayTime: $endDayTime, startTime: $startTime, endTime: $endTime, location: $location, teacher: $teacher, extraData: $extraData, campus: $campus, courseType: $courseType, credit: $credit, courseCodeType: $courseCodeType, courseCodeFlag: $courseCodeFlag, year: $year, term: $term, studentId: $studentId}';
  }
}
