import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/exam.dart';
import 'package:xhu_timetable_ios/model/exam.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class QueryExamRoute extends StatefulWidget {
  const QueryExamRoute({super.key});

  @override
  State<QueryExamRoute> createState() => _QueryExamRouteState();
}

class _QueryExamRouteState extends SelectState<QueryExamRoute> {
  int index = 0;
  int size = 10;
  List<SelectView> userSelectList = [];

  List<ExamResponse> examList = [];
  final _refreshController = RefreshController(initialRefresh: false);

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
      setState(() {
        examList = result.items;
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
      setState(() {
        examList.addAll(result.items);
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
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: examList.length,
                itemBuilder: (context, index) =>
                    Text(examList[index].courseName),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
