class UserInfo {
  final String studentNo;
  final String name;
  final String gender;
  final int xhuGrade;
  final String college;
  final String majorName;
  final String className;
  final String majorDirection;

  UserInfo(
      {required this.studentNo,
      required this.name,
      required this.gender,
      required this.xhuGrade,
      required this.college,
      required this.majorName,
      required this.className,
      required this.majorDirection});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    var genderEnum = json['gender'];
    var gender = "未知";
    if (genderEnum == "MALE" || genderEnum == "男") {
      gender = "男";
    } else if (genderEnum == "FEMALE" || genderEnum == "女") {
      gender = "女";
    }
    return UserInfo(
      studentNo: json['studentNo'],
      name: json['name'],
      gender: gender,
      xhuGrade: json['xhuGrade'],
      college: json['college'],
      majorName: json['majorName'],
      className: json['className'],
      majorDirection: json['majorDirection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentNo': studentNo,
      'name': name,
      'gender': gender,
      'xhuGrade': xhuGrade,
      'college': college,
      'majorName': majorName,
      'className': className,
      'majorDirection': majorDirection,
    };
  }
}
