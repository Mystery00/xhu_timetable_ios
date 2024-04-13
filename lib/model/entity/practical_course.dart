const String tablePracticalCourse = 'tb_practical_course';

class PracticalCourseEntity {
  int? id;
  final String courseName;
  final String weekStr;
  final String weekList;
  final String teacher;
  final String campus;
  final double credit;
  final int year;
  final int term;
  final String studentId;

  PracticalCourseEntity({
    this.id,
    required this.courseName,
    required this.weekStr,
    required this.weekList,
    required this.teacher,
    required this.campus,
    required this.credit,
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
      'teacher': teacher,
      'campus': campus,
      'credit': credit,
      'year': year,
      'term': term,
      'studentId': studentId,
    };
  }

  static PracticalCourseEntity fromMap(Map<String, Object?> map) {
    return PracticalCourseEntity(
      id: map['id'] as int?,
      courseName: map['courseName'] as String,
      weekStr: map['weekStr'] as String,
      weekList: map['weekList'] as String,
      teacher: map['teacher'] as String,
      campus: map['campus'] as String,
      credit: map['credit'] as double,
      year: map['year'] as int,
      term: map['term'] as int,
      studentId: map['studentId'] as String,
    );
  }

  @override
  String toString() {
    return 'PracticalCourseEntity{id: $id, courseName: $courseName, weekStr: $weekStr, weekList: $weekList, teacher: $teacher, campus: $campus, credit: $credit, year: $year, term: $term, studentId: $studentId}';
  }
}
