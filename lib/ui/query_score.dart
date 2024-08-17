import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
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

  bool showMore = true;
  ScoreGpaResponse? gpa;
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
      _getGpa().then((value) => setState(() {
            gpa = value;
          }));
      index = 0;
      var result = await _getScoreList(0, size);
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

  Future<ScoreGpaResponse> _getGpa() async {
    User user = await getSelectedUser(userSelectList);
    var year = await getSelectedYear(yearSelectList);
    var term = await getSelectedTerm(termSelectList);

    return await user.withAutoLoginOnce(
        (sessionToken) => apiScoreGpa(sessionToken, year, term));
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
        title: const Text("课程成绩查询"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                showUserSelect(context, userSelectList, (list) {
                  setState(() {
                    userSelectList = list;
                  });
                }),
                const SizedBox(width: 4),
                showYearSelect(context, yearSelectList, (list) {
                  setState(() {
                    yearSelectList = list;
                  });
                }),
                const SizedBox(width: 4),
                showTermSelect(context, termSelectList, (list) {
                  setState(() {
                    termSelectList = list;
                  });
                }),
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
              child: ExpandableListView(
                  builder: SliverExpandableChildDelegate<String, ScoreSection>(
                sectionList: [
                  ScoreSection(items: List.empty()),
                  ScoreSection(items: [""]),
                  ScoreSection(
                      items: scoreList.map((e) => e.courseName).toList()),
                ],
                headerBuilder: (context, sectionIndex, index) {
                  switch (sectionIndex) {
                    case 0:
                      return Container(
                        height: 48,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: InkWell(
                          onTap: () => setState(() {
                            showMore = !showMore;
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("显示更多信息"),
                              Switch(
                                  value: showMore,
                                  onChanged: (value) {
                                    setState(() {
                                      showMore = value;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    case 1:
                      return Container(
                        height: 48,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Text("学期总览"),
                      );
                    default:
                      return Container(
                        height: 48,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Text("课程成绩列表"),
                      );
                  }
                },
                itemBuilder: (context, sectionIndex, itemIndex, index) {
                  if (sectionIndex == 1) return _buildTermInfo(gpa);
                  return _buildItem(scoreList[itemIndex], showMore);
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermInfo(ScoreGpaResponse? gpa) {
    if (gpa == null) {
      return const SizedBox();
    }
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "总成绩：${gpa.totalScore.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "平均成绩：${gpa.averageScore.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "总学分：${gpa.totalCredit.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Text(
                  "GPA = ${gpa.gpa.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ScoreResponse score, bool showMore) => Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
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
                      if (showMore)
                        SelectableText(
                          score.courseType,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (showMore)
                        SelectableText(
                          score.scoreType,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (showMore)
                        SelectableText(
                          "课程学分：${score.credit}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (showMore)
                        SelectableText(
                          "课程绩点：${score.gpa}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (showMore)
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
                SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      score.score.toString(),
                      style: TextStyle(
                          color: score.score < 60
                              ? Colors.red
                              : Theme.of(context).colorScheme.onSurface,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ScoreSection implements ExpandableListSection<String> {
  final List<String> items;

  ScoreSection({required this.items});

  @override
  List<String> getItems() => items;

  @override
  bool isSectionExpanded() => true;

  @override
  void setSectionExpanded(bool expanded) {}
}
