import 'package:xhu_timetable_ios/model/user_info.dart';

class CustomAccountTitle {
  final String todayTemplate;
  final String weekTemplate;

  CustomAccountTitle({required this.todayTemplate, required this.weekTemplate});

  factory CustomAccountTitle.fromJson(Map<String, dynamic> json) {
    return CustomAccountTitle(
      todayTemplate: json['todayTemplate'],
      weekTemplate: json['weekTemplate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayTemplate': todayTemplate,
      'weekTemplate': weekTemplate,
    };
  }

  String formatToday(UserInfo userInfo) => _format(userInfo, todayTemplate);

  String formatWeek(UserInfo userInfo) => _format(userInfo, weekTemplate);

  String _format(UserInfo userInfo, String tpl) => tpl
      .replaceAll("{studentNo}", userInfo.studentNo)
      .replaceAll("{name}", userInfo.name)
      .replaceAll("{nickName}", userInfo.name);
}

// ignore: non_constant_identifier_names
var DEFAULT_CUSTOM_ACCOUNT_TITLE = CustomAccountTitle(
  todayTemplate: "{name}",
  weekTemplate: "{studentNo}({name})",
);
