import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/exam.dart';
import 'package:xhu_timetable_ios/model/exam.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

class QueryExamRoute extends StatefulWidget {
  const QueryExamRoute({super.key});

  @override
  State<QueryExamRoute> createState() => _QueryExamRouteState();
}

class _QueryExamRouteState extends SelectState<QueryExamRoute> {
  int index = 0;
  int size = 10;
  List<SelectView> userSelectList = [];

  List<Exam> examList = [];
  final _refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    userSelect().then((value) {
      setState(() {
        userSelectList = value;
      });
    });
  }

  void _onRefresh() async {
    try {
      var result = await _getExamList(0, size);
      index = 0;
      var now = DateTime.now();
      var list = result.items.map((e) => _mapExamResponse(e, now)).toList();
      setState(() {
        examList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      var result = await _getExamList(index + 1, size);
      if (result.items.isEmpty) {
        return _refreshController.loadNoData();
      }
      index++;
      var now = DateTime.now();
      var list = result.items.map((e) => _mapExamResponse(e, now)).toList();
      setState(() {
        examList.addAll(list);
      });
      _refreshController.loadComplete();
    } catch (e) {
      Logger().e(e);
      _refreshController.loadFailed();
    }
  }

  Future<PageResult<ExamResponse>> _getExamList(int index, size) async {
    User user = await getSelectedUser(userSelectList);
    var year = await getNowYear();
    var term = await getNowTerm();

    return await user.withAutoLoginOnce(
        (sessionToken) => apiExamList(sessionToken, year, term, index, size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("考试查询"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      userSelectList.isEmpty
                          ? "未登录"
                          : userSelectList
                              .firstWhere((element) => element.selected)
                              .valueTitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    showSelectDialog(
                        title: "请选择要查询的学生",
                        list: userSelectList,
                        updateState: (list) {
                          setState(() {
                            userSelectList = list;
                          });
                        });
                  },
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).colorScheme.outline),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: examList.length,
                itemBuilder: (context, index) => _buildItem(examList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Exam exam) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: exam.examStatus.color,
            width: exam.examStatus.strokeWidth,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: exam.courseColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                width: 72,
                height: double.infinity,
                child: Center(
                  child: Text(
                    exam.showText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "考试时间：${exam.dateString} ${exam.time}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "考试地点：${exam.location}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "考试类型：${exam.examName}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  color: exam.courseColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                width: 72,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "座位号\n${exam.seatNo}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

Exam _mapExamResponse(ExamResponse response, DateTime now) {
  var examStatus = ExamStatus.ing;
  if (now.isBefore(response.examStartTimeMills)) {
    examStatus = ExamStatus.before;
  } else if (now.isAfter(response.examEndTimeMills)) {
    examStatus = ExamStatus.after;
  }
  var time =
      "${response.examStartTime.formatTimeNoSecond()} - ${response.examEndTime.formatTimeNoSecond()}";
  var statusShowText = "";
  if (examStatus.index == ExamStatus.before.index) {
    var duration = response.examStartTimeMills.difference(now);
    var remainDays = duration.inDays;
    if (remainDays > 0) {
      //还有超过1天的时间，显示 x天
      var dayDuration = response.examDay.difference(now.atStartOfDay());
      //如果在明天之外，不计算小时
      if (dayDuration.inDays > 1) {
        statusShowText = "${remainDays + 1}\n天";
      } else {
        statusShowText = "$remainDays\n天";
      }
    } else {
      //剩余时间不足一天，显示 x小时
      var remainHours = duration.inHours;
      statusShowText = "$remainHours\n小时后";
    }
  } else if (examStatus.index == ExamStatus.ing.index) {
    statusShowText = "今天";
  } else if (examStatus.index == ExamStatus.after.index) {
    statusShowText = "已结束";
  }
  return Exam(
    courseColor: ColorPool.hash(response.courseName),
    date: response.examDay,
    dateString: response.examDay.formatDate(),
    seatNo: response.seatNo,
    courseName: response.courseName,
    examName: response.examName,
    location: response.location,
    time: time,
    examRegion: response.examRegion,
    examStatus: examStatus,
    showText: statusShowText,
  );
}

class Exam {
  final Color courseColor;
  final DateTime date;
  final String dateString;
  final String seatNo;
  final String courseName;
  final String examName;
  final String location;
  final String time;
  final String examRegion;
  final ExamStatus examStatus;
  final String showText;

  Exam({
    required this.courseColor,
    required this.date,
    required this.dateString,
    required this.seatNo,
    required this.courseName,
    required this.examName,
    required this.location,
    required this.time,
    required this.examRegion,
    required this.examStatus,
    required this.showText,
  });
}

class ExamStatus {
  final int index;
  final String title;
  final Color color;
  final double strokeWidth;

  ExamStatus({
    required this.index,
    required this.title,
    required this.color,
    required this.strokeWidth,
  });

  static ExamStatus before = ExamStatus(
      index: 1, title: "未开始", color: const Color(0xFF4CAF50), strokeWidth: 2);
  static ExamStatus ing = ExamStatus(
      index: 0, title: "进行中", color: const Color(0xFFFF9800), strokeWidth: 3);
  static ExamStatus after = ExamStatus(
      index: 2, title: "已结束", color: const Color(0xFFC6C6C6), strokeWidth: 1);
}
