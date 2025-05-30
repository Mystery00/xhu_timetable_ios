import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/custom_thing.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/base.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

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
  var sheetStartDate = DateTime.now().atStartOfDay();
  var sheetStartTime = TimeOfDay.fromDateTime(DateTime.now().atHourStart());
  var sheetEndDate = DateTime.now().atStartOfDay();
  var sheetEndTime = TimeOfDay.fromDateTime(DateTime.now().atHourStart());
  var sheetColor = ColorPool.random();

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

  Future<bool> _saveCustomThing(
      int? thingId, CustomThingRequest request) async {
    User user = await getSelectedUser(userSelectList);
    return await user.withAutoLoginOnce((sessionToken) => thingId == null
        ? apiCreateCustomThing(sessionToken, request)
        : apiUpdateCustomThing(sessionToken, thingId, request));
  }

  Future<bool> _deleteCustomThing(int thingId) async {
    User user = await getSelectedUser(userSelectList);
    return await user.withAutoLoginOnce(
        (sessionToken) => apiDeleteCustomThing(sessionToken, thingId));
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
              child: buildListContentOrEmpty(),
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

  Widget buildListContentOrEmpty() {
    if (customThingList.isEmpty) {
      return buildLayout(context, 'assets/lottie/no_data.json', 240,
          text: '暂无数据');
    }
    return ListView.builder(
      itemCount: customThingList.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          _showCreateCustomThingSheet(
              context, customThingList[index]);
        },
        child: _buildItem(customThingList[index]),
      ),
    );
  }

  void _showCreateCustomThingSheet(BuildContext context, CustomThing? item) {
    setState(() {
      sheetTitleController.text = item?.title ?? '';
      sheetLocationController.text = item?.location ?? '';
      sheetRemarkController.text = item?.response.remark ?? '';
      sheetColor = item?.color ?? ColorPool.random();
    });
    var allDay = item?.response.allDay ?? false;
    var saveAsCountDown = false;
    if (item != null) {
      var metadataJson = json.decode(item.response.metadata);
      var value = metadataJson['key_save_as_count_down'] ?? "false";
      saveAsCountDown = bool.parse(value);
    }
    var startTime = item?.response.startTime ?? DateTime.now();
    var endTime =
        item?.response.endTime ?? DateTime.now().add(Duration(hours: 1));
    startTime = startTime.atHourStart();
    endTime = endTime.atHourStart();
    setState(() {
      sheetAllDay = allDay;
      sheetSaveAsCountDown = saveAsCountDown;
      sheetStartDate = startTime.atStartOfDay();
      sheetStartTime = startTime.toTimeOfDay();
      sheetEndDate = endTime.atStartOfDay();
      sheetEndTime = endTime.toTimeOfDay();
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
          var navigator = Navigator.of(context);
          return Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 32, left: 32, right: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (item != null)
                      TextButton(
                          onPressed: () {
                            _deleteCustomThing(item.thingId).then((res) {
                              if (res) {
                                showToast("删除成功");
                                navigator.pop();
                              }
                            }).catchError((e) {
                              showToast(handleException(e));
                            }).whenComplete(() {
                              _onRefresh();
                            });
                          },
                          child: const Text("删除",
                              style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () {
                          if (sheetSaveAsCountDown) {
                            //存储为倒计时，那么持续时间为一天
                            sheetEndDate =
                                sheetStartDate.add(const Duration(days: 1));
                            sheetEndTime = sheetStartTime;
                          }
                          var startTime = sheetStartDate.atTime(sheetStartTime);
                          var endTime = sheetEndDate.atTime(sheetEndTime);
                          if (endTime.isBefore(startTime)) {
                            showToast('开始时间不能晚于结束时间');
                            return;
                          }
                          var request = CustomThingRequest(
                            title: sheetTitleController.text,
                            location: sheetLocationController.text,
                            allDay: sheetAllDay,
                            startTime: startTime.millisecondsSinceEpoch,
                            endTime: endTime.millisecondsSinceEpoch,
                            remark: sheetRemarkController.text,
                            color: sheetColor.toHex(),
                            metadata: json.encode({
                              "key_save_as_count_down":
                                  sheetSaveAsCountDown.toString(),
                            }),
                          );
                          _saveCustomThing(item?.thingId, request).then((res) {
                            if (res) {
                              showToast("保存成功");
                              navigator.pop();
                            }
                          }).catchError((e) {
                            showToast(handleException(e));
                          }).whenComplete(() {
                            _onRefresh();
                          });
                        },
                        child: const Text("保存")),
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
                        InkWell(
                          child: Text(sheetStartDate.formatDate()),
                          onTap: () {
                            showDatePickerDialog(sheetStartDate)
                                .then((pickDate) {
                              if (pickDate != null) {
                                setState(() {
                                  sheetStartDate = pickDate;
                                });
                                (context as Element).markNeedsBuild();
                              }
                            });
                          },
                        ),
                        if (!sheetAllDay)
                          InkWell(
                            child: Text(sheetStartTime.formatTime()),
                            onTap: () {
                              showTimePickerDialog(sheetStartTime)
                                  .then((pickTime) {
                                if (pickTime != null) {
                                  setState(() {
                                    sheetStartTime = pickTime;
                                  });
                                  (context as Element).markNeedsBuild();
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    if (!sheetSaveAsCountDown) const SizedBox(height: 8),
                    if (!sheetSaveAsCountDown)
                      Row(
                        spacing: 16,
                        children: [
                          Expanded(child: Text(sheetAllDay ? "结束日期" : "结束时间")),
                          InkWell(
                            child: Text(sheetEndDate.formatDate()),
                            onTap: () {
                              showDatePickerDialog(sheetEndDate)
                                  .then((pickDate) {
                                if (pickDate != null) {
                                  setState(() {
                                    sheetEndDate = pickDate;
                                  });
                                  (context as Element).markNeedsBuild();
                                }
                              });
                            },
                          ),
                          if (!sheetAllDay)
                            InkWell(
                              child: Text(sheetEndTime.formatTime()),
                              onTap: () {
                                showTimePickerDialog(sheetEndTime)
                                    .then((pickTime) {
                                  if (pickTime != null) {
                                    setState(() {
                                      sheetEndTime = pickTime;
                                    });
                                    (context as Element).markNeedsBuild();
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    InkWell(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('设置颜色'),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: sheetColor,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        showSelectColorPicker(sheetColor).then((pickColor) {
                          setState(() {
                            sheetColor = pickColor;
                          });
                          (context as Element).markNeedsBuild();
                        });
                      },
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

  Future<DateTime?> showDatePickerDialog(DateTime initialDate) async {
    return await showDatePicker(
      helpText: "请选择日期",
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: initialDate,
      currentDate: DateTime.now(),
      firstDate: initialDate.subtract(const Duration(days: 730)),
      lastDate: initialDate.add(const Duration(days: 730)),
    );
  }

  Future<TimeOfDay?> showTimePickerDialog(TimeOfDay initialDate) async {
    return await showTimePicker(
      helpText: "请选择时间",
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: initialDate,
    );
  }

  Future<Color> showSelectColorPicker(Color pickerColor) async {
    return await showDialog(
      context: context,
      builder: (context) {
        var selectedColor = pickerColor;
        return AlertDialog(
          title: const Text("选择颜色"),
          content: SingleChildScrollView(
              child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pickerColor);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }
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
    thingId: response.thingId,
    title: response.title,
    location: response.location,
    showDateTime: showDateTime,
    color: response.color,
    response: response,
  );
}

class CustomThing {
  final int thingId;
  final String title;
  final String location;
  final String showDateTime;
  final Color color;
  final CustomThingResponse response;

  CustomThing({
    required this.thingId,
    required this.title,
    required this.location,
    required this.showDateTime,
    required this.color,
    required this.response,
  });
}
