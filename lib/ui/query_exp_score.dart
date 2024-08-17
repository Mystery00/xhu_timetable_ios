import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:xhu_timetable_ios/api/rest/score.dart';
import 'package:xhu_timetable_ios/model/score.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class QueryExpScoreRoute extends StatefulWidget {
  const QueryExpScoreRoute({super.key});

  @override
  State<QueryExpScoreRoute> createState() => _QueryExpScoreRouteState();
}

class _QueryExpScoreRouteState extends SelectState<QueryExpScoreRoute> {
  List<SelectView> userSelectList = [];
  List<SelectView> yearSelectList = [];
  List<SelectView> termSelectList = [];

  List<ExperimentScoreResponse> expScoreList = [];
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
      var list = await _getExpScoreList();
      setState(() {
        expScoreList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  Future<List<ExperimentScoreResponse>> _getExpScoreList() async {
    User user = await getSelectedUser(userSelectList);
    var year = await getSelectedYear(yearSelectList);
    var term = await getSelectedTerm(termSelectList);

    return await user.withAutoLoginOnce(
        (sessionToken) => apiExperimentScore(sessionToken, year, term));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("实验成绩查询"),
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
              child: ExpandableListView(
                  builder: SliverExpandableChildDelegate<
                      ExperimentScoreItemResponse, ExpScoreSection>(
                sectionList:
                    expScoreList.map((e) => ExpScoreSection(data: e)).toList(),
                headerBuilder: (context, sectionIndex, index) {
                  var data = expScoreList[sectionIndex];
                  return Container(
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.courseName),
                        Text("${data.totalScore}分"),
                      ],
                    ),
                  );
                },
                itemBuilder: (context, sectionIndex, itemIndex, index) {
                  var item = expScoreList[sectionIndex].itemList[itemIndex];
                  return _buildItem(item);
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ExperimentScoreItemResponse expScore) => Card(
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
                        expScore.experimentProjectName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      SelectableText(
                        expScore.mustTest,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      SelectableText(
                        "实验学分: ${expScore.credit}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      if (expScore.scoreDescription.isNotEmpty)
                        SelectableText(
                          "成绩说明: ${expScore.scoreDescription}",
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
                      expScore.score.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ExpScoreSection
    implements ExpandableListSection<ExperimentScoreItemResponse> {
  final ExperimentScoreResponse data;

  ExpScoreSection({required this.data});

  @override
  List<ExperimentScoreItemResponse> getItems() => data.itemList;

  @override
  bool isSectionExpanded() => true;

  @override
  void setSectionExpanded(bool expanded) {}
}
