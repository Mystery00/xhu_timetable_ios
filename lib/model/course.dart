class Course {
  final String courseName;
  final String weekStr;
  final List<int> weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String location;
  final String teacher;
  final List<String> extraData;
  final String campus;
  final String courseType;
  final double credit;
  final String courseCodeType;
  final String courseCodeFlag;

  Course(
      {required this.courseName,
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
      required this.courseCodeFlag});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['courseName'],
      weekStr: json['weekStr'],
      weekList: json['weekList'].cast<int>(),
      dayIndex: json['dayIndex'],
      startDayTime: json['startDayTime'],
      endDayTime: json['endDayTime'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      teacher: json['teacher'],
      extraData: json['extraData'].cast<String>(),
      campus: json['campus'],
      courseType: json['courseType'],
      credit: json['credit'],
      courseCodeType: json['courseCodeType'],
      courseCodeFlag: json['courseCodeFlag'],
    );
  }
}

class PracticalCourse {
  final String courseName;
  final String weekStr;
  final List<int> weekList;
  final String teacher;
  final String campus;
  final double credit;

  PracticalCourse(
      {required this.courseName,
      required this.weekStr,
      required this.weekList,
      required this.teacher,
      required this.campus,
      required this.credit});

  factory PracticalCourse.fromJson(Map<String, dynamic> json) {
    return PracticalCourse(
      courseName: json['courseName'],
      weekStr: json['weekStr'],
      weekList: json['weekList'].cast<int>(),
      teacher: json['teacher'],
      campus: json['campus'],
      credit: json['credit'],
    );
  }
}

class ExperimentCourse {
  final String courseName;
  final String experimentProjectName;
  final String teacherName;
  final String experimentGroupName;
  final String weekStr;
  final List<int> weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String region;
  final String location;

  ExperimentCourse(
      {required this.courseName,
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
      required this.location});

  factory ExperimentCourse.fromJson(Map<String, dynamic> json) {
    return ExperimentCourse(
      courseName: json['courseName'],
      experimentProjectName: json['experimentProjectName'],
      teacherName: json['teacherName'],
      experimentGroupName: json['experimentGroupName'],
      weekStr: json['weekStr'],
      weekList: json['weekList'].cast<int>(),
      dayIndex: json['dayIndex'],
      startDayTime: json['startDayTime'],
      endDayTime: json['endDayTime'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      region: json['region'],
      location: json['location'],
    );
  }
}
