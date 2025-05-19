import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/custom_thing.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
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

  List<CustomThing> customThingList = [];
  final _refreshController = RefreshController(initialRefresh: true);
  final TextEditingController sheetTitleController = TextEditingController();
  final TextEditingController sheetLocationController = TextEditingController();
  final TextEditingController sheetRemarkController = TextEditingController();
  var sheetAllDay = false;
  var sheetSaveAsCountDown = false;
  var sheetStartTime = DateTime.now();
  var sheetEndTime = DateTime.now();

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
      var list = result.items.map((e) => _mapCustomThingResponse(e)).toList();
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
      var list = result.items.map((e) => _mapCustomThingResponse(e)).toList();
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
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    _showCreateCustomThingSheet(
                        context, customThingList[index]);
                  },
                  child: _buildItem(customThingList[index]),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_outlined),
        label: const Text("新增"),
        onPressed: () {
          _showCreateCustomThingSheet(context, null);
        },
      ),
    );
  }

  void _showCreateCustomThingSheet(BuildContext context, CustomThing? item) {
    setState(() {
      sheetTitleController.text = item?.title ?? '';
      sheetLocationController.text = item?.location ?? '';
      sheetRemarkController.text = item?.response.remark ?? '';
    });
    var allDay = item?.response.allDay ?? false;
    var saveAsCountDown = false;
    if (item != null) {
      var metadataJson = json.decode(item.response.metadata);
      saveAsCountDown = metadataJson['saveAsCountDown'] ?? false;
    }
    var startTime = item?.response.startTime ?? DateTime.now();
    var endTime =
        item?.response.endTime ?? DateTime.now().add(Duration(hours: 1));
    startTime = startTime.atHourStart();
    endTime = endTime.atHourStart();
    setState(() {
      sheetAllDay = allDay;
      sheetSaveAsCountDown = saveAsCountDown;
      sheetStartTime = startTime;
      sheetEndTime = endTime;
    });
    showMaterialModalBottomSheet(
        context: context,
        shape: ShapeBorder.lerp(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            0),
        duration: const Duration(milliseconds: 200),
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 32, left: 32, right: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("保存"))
                  ],
                ),
                Column(
                  spacing: 8,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "标题",
                        hintText: "请输入标题",
                      ),
                      controller: sheetTitleController,
                      autofocus: true,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "地点",
                        hintText: "请输入地点（选填）",
                      ),
                      controller: sheetLocationController,
                      autofocus: true,
                    ),
                    Row(
                      children: [
                        const Text("全天事项"),
                        const Expanded(child: SizedBox()),
                        Switch(
                            value: sheetAllDay,
                            onChanged: (value) {
                              setState(() {
                                sheetAllDay = value;
                              });
                              (context as Element).markNeedsBuild();
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("存储为倒计时"),
                        const Expanded(child: SizedBox()),
                        Switch(
                            value: sheetSaveAsCountDown,
                            onChanged: (value) {
                              setState(() {
                                sheetSaveAsCountDown = value;
                              });
                              (context as Element).markNeedsBuild();
                            }),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                            child: Text(sheetSaveAsCountDown
                                ? "倒计时日期"
                                : sheetAllDay
                                    ? "开始日期"
                                    : "开始时间")),
                        Text(sheetStartTime.formatDate()),
                        if (!sheetAllDay)
                          Text(sheetStartTime.formatTimeNoSecond()),
                      ],
                    ),
                    if (!sheetSaveAsCountDown) const SizedBox(height: 8),
                    if (!sheetSaveAsCountDown)
                      Row(
                        spacing: 16,
                        children: [
                          Expanded(child: Text(sheetAllDay ? "结束日期" : "结束时间")),
                          Text(sheetEndTime.formatDate()),
                          if (!sheetAllDay)
                            Text(sheetEndTime.formatTimeNoSecond()),
                        ],
                      ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "备注",
                        hintText: "请输入备注（选填）",
                      ),
                      controller: sheetRemarkController,
                      autofocus: true,
                      maxLines: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
  }

  Widget _buildItem(CustomThing item) => Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: item.color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                width: 8,
                height: double.infinity,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        if (item.location.isNotEmpty)
                          Text(
                            item.location,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 13,
                            ),
                          ),
                        Text(
                          item.showDateTime,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

CustomThing _mapCustomThingResponse(CustomThingResponse response) {
  var metadataJson = json.decode(response.metadata);
  var saveAsCountDown = metadataJson['saveAsCountDown'] ?? false;
  var startText = response.allDay
      ? response.startTime.formatChinaDate()
      : response.startTime.formatThingDateTime();
  var endText = response.allDay
      ? response.endTime.formatChinaDate()
      : response.endTime.formatThingDateTime();
  var showDateTime = saveAsCountDown ? startText : "$startText - $endText";
  return CustomThing(
    title: response.title,
    location: response.location,
    showDateTime: showDateTime,
    color: response.color,
    response: response,
  );
}

class CustomThing {
  final String title;
  final String location;
  final String showDateTime;
  final Color color;
  final CustomThingResponse response;

  CustomThing({
    required this.title,
    required this.location,
    required this.showDateTime,
    required this.color,
    required this.response,
  });
}
