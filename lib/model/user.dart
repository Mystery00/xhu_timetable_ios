import 'package:xhu_timetable_ios/model/user_info.dart';

class User {
  final String studentId;
  final String password;
  final String token;
  final UserInfo userInfo;
  final String? profileImage;

  User(
      {required this.studentId,
      required this.password,
      required this.token,
      required this.userInfo,
      required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      studentId: json['studentId'],
      password: json['password'],
      token: json['token'],
      userInfo: UserInfo.fromJson(json['userInfo']),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'password': password,
      'token': token,
      'userInfo': userInfo.toJson(),
      'profileImage': profileImage,
    };
  }
}
