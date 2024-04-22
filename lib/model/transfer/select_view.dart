import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class SelectView {
  final String title;
  final String valueTitle;
  final String value;
  final bool selected;

  SelectView({
    required this.title,
    required this.valueTitle,
    required this.value,
    required this.selected,
  });
}

Future<List<SelectView>> userSelect() async {
  var userList = await loggedUserList();
  var userId = await mainUserId();
  return userList
      .map((e) => SelectView(
            title: "${e.userInfo.name}(${e.studentId})",
            valueTitle: e.userInfo.name,
            value: e.studentId,
            selected: e.studentId == userId,
          ))
      .toList()
    ..sort((a, b) => a.title.compareTo(b.title));
}

Future<User> getSelectedUser(List<SelectView> list) async {
  var userId = list.firstWhere((element) => element.selected).value;
  return await getUserByStudentId(userId).then((value) => value!);
}

Future<List<SelectView>> yearSelect() async {
  var userList = await loggedUserList();
  var termStartDate = await getTermStartDate();
  var nowYear = await getNowYear();
  userList.sort((a, b) => a.userInfo.xhuGrade.compareTo(b.userInfo.xhuGrade));
  var minYear = userList.firstOrNull?.userInfo.xhuGrade ?? 2019;
  var maxYear =
      termStartDate.month < 6 ? termStartDate.year : termStartDate.year - 1;
  if (maxYear < nowYear) {
    maxYear = nowYear;
  }
  if (minYear > maxYear) {
    maxYear = minYear;
  }
  var resultList = <SelectView>[];
  for (var i = minYear; i <= maxYear; i++) {
    resultList.add(SelectView(
      title: "$i-${i + 1}学年",
      valueTitle: "$i-${i + 1}学年",
      value: i.toString(),
      selected: i == nowYear,
    ));
  }
  return resultList.reversed.toList();
}

Future<List<SelectView>> termSelect() async {
  var nowTerm = await getNowTerm();
  var resultList = <SelectView>[];
  for (var i = 0; i < 2; i++) {
    resultList.add(SelectView(
      title: "第${i + 1}学期",
      valueTitle: "第${i + 1}学期",
      value: (i + 1).toString(),
      selected: i + 1 == nowTerm,
    ));
  }
  return resultList;
}

List<SelectView> doSelect(List<SelectView> list, String value) => list
    .map((e) => SelectView(
          title: e.title,
          valueTitle: e.valueTitle,
          value: e.value,
          selected: e.value == value,
        ))
    .toList();

abstract class SelectState<T extends StatefulWidget> extends State<T> {
  void showSelectDialog({
    required String title,
    required List<SelectView> list,
    required void Function(List<SelectView>) updateState,
  }) async {
    String? selectedValue =
        list.firstWhere((element) => element.selected).value;
    String? v = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in list)
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      (context as Element).markNeedsBuild();
                      selectedValue = item.value;
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: selectedValue == item.value
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      child: Text(item.title),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedValue);
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
    if (v == null) {
      return;
    }
    updateState(doSelect(list, v));
  }
}
