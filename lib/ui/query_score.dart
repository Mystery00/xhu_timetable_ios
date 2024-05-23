import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/score.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/score.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class QueryScoreRoute extends StatefulWidget {
  const QueryScoreRoute({super.key});

  @override
  State<QueryScoreRoute> createState() => _QueryScoreRouteState();
}

class _QueryScoreRouteState extends SelectState<QueryScoreRoute> {
  int index = 0;
  int size = 10;
  List<SelectView> userSelectList = [];
  List<SelectView> yearSelectList = [];
  List<SelectView> termSelectList = [];

  List<ScoreResponse> scoreList = [];
  final _refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    userSelect().then((value) {
      setState(() {
        userSelectList = value;
      });
    });
    yearSelect().then((value) {
      setState(() {
        yearSelectList = value;
      });
    });
    termSelect().then((value) {
      setState(() {
        termSelectList = value;
      });
    });
  }

  void _onRefresh() async {
    try {
      var result = await _getScoreList(0, size);
      index = 0;
      var list = result.items;
      setState(() {
        scoreList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      var result = await _getScoreList(index + 1, size);
      if (result.items.isEmpty) {
        return _refreshController.loadNoData();
      }
      index++;
      var list = result.items;
      setState(() {
        scoreList = list;
      });
      _refreshController.loadComplete();
    } catch (e) {
      Logger().e(e);
      _refreshController.loadFailed();
    }
  }

  Future<PageResult<ScoreResponse>> _getScoreList(int index, size) async {
    User user = await getSelectedUser(userSelectList);
    var year = await getSelectedYear(yearSelectList);
    var term = await getSelectedTerm(termSelectList);

    return await user.withAutoLoginOnce(
        (sessionToken) => apiScoreList(sessionToken, year, term, index, size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("成绩查询"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                showUserSelect(context, userSelectList),
                showYearSelect(context, yearSelectList),
                showTermSelect(context, termSelectList),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () {
                    _refreshController.requestRefresh();
                  },
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
                itemCount: scoreList.length,
                itemBuilder: (context, index) => _buildItem(scoreList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ScoreResponse score) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        score.courseName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      SelectableText(
                        score.courseType,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      SelectableText(
                        score.scoreType,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      SelectableText(
                        "课程学分：${score.credit}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      SelectableText(
                        "课程绩点：${score.gpa}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      SelectableText(
                        "学分绩点：${score.creditGpa}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: Text(
                  score.score.toString(),
                  style: TextStyle(
                      color: score.score < 60
                          ? Colors.red
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
}
