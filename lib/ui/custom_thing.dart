import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/custom_thing.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class CustomThingRoute extends StatefulWidget {
  const CustomThingRoute({super.key});

  @override
  State<CustomThingRoute> createState() => _CustomThingRouteState();
}

class _CustomThingRouteState extends SelectState<CustomThingRoute> {
  int index = 0;
  int size = 10;
  List<SelectView> userSelectList = [];

  List<CustomThingResponse> customThingList = [];
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
      var result = await _getCustomThingList(0, size);
      index = 0;
      var list = result.items;
      setState(() {
        customThingList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      var result = await _getCustomThingList(index + 1, size);
      if (result.items.isEmpty) {
        return _refreshController.loadNoData();
      }
      index++;
      var list = result.items;
      setState(() {
        customThingList.addAll(list);
      });
      _refreshController.loadComplete();
    } catch (e) {
      Logger().e(e);
      _refreshController.loadFailed();
    }
  }

  Future<PageResult<CustomThingResponse>> _getCustomThingList(
      int index, size) async {
    User user = await getSelectedUser(userSelectList);

    return await user.withAutoLoginOnce(
        (sessionToken) => apiCustomThingList(sessionToken, index, size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自定义事项"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showUserSelect(context, userSelectList, (list) {
                  setState(() {
                    userSelectList = list;
                  });
                }),
                IconButton.filledTonal(
                  onPressed: () {
                    _refreshController.requestRefresh();
                  },
                  icon: const Icon(Icons.search_outlined),
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
                itemCount: customThingList.length,
                itemBuilder: (context, index) =>
                    _buildItem(customThingList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(CustomThingResponse item) => Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                SelectableText(
                  "时间：${item.startTime}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 13,
                  ),
                ),
                if (item.location.isNotEmpty)
                  SelectableText(
                    "地点：${item.location}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 13,
                    ),
                  ),
                SelectableText(
                  "创建时间：${item.createTime}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
