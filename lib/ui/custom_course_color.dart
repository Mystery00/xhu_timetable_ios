import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:logger/logger.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/repository/course_color.dart';
import 'package:xhu_timetable_ios/ui/base.dart';

class CustomCourseColorRoute extends StatefulWidget {
  const CustomCourseColorRoute({super.key});

  @override
  State<CustomCourseColorRoute> createState() => _CustomCourseColorRouteState();
}

class _CustomCourseColorRouteState extends SelectState<CustomCourseColorRoute> {
  EventBus eventBus = getEventBus();

  List<CustomColor> colorList = [];
  final _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async {
    try {
      var list = await _getCourseColorList();
      setState(() {
        colorList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  Future<List<CustomColor>> _getCourseColorList() async {
    var m = await loadAllCourseColor();
    var list = <CustomColor>[];
    m.forEach((key, value) {
      list.add(CustomColor(courseName: key, color: value));
    });
    list.sort((a, b) => PinyinHelper.getPinyinE(a.courseName)
        .compareTo(PinyinHelper.getPinyinE(b.courseName)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自定义课程颜色"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: buildPageOrEmptyData(
          context,
          size: colorList.length,
          itemBuilder: (context, index) => _buildItem(colorList[index]),
        ),
      ),
    );
  }

  Widget _buildItem(CustomColor item) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              InkWell(
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color,
                  ),
                ),
                onTap: () {
                  _showSelectColorPicker(item.courseName, item.color);
                },
              ),
              Expanded(
                child: Text(
                  item.courseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _showCustomColorPicker(item.courseName, item.color);
                },
                child: const Text("修改"),
              ),
            ],
          ),
        ),
      );

  void _showSelectColorPicker(String courseName, Color pickerColor) {
    showDialog(
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
                Navigator.of(context).pop();
                deleteCourseColor(courseName)
                    .then((value) =>
                        eventBus.fire(UIChangeEvent.changeCourseColor()))
                    .then((value) => _refreshController.requestRefresh());
              },
              child: const Text("重置为默认"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveCourseColor(courseName, selectedColor)
                    .then((value) =>
                        eventBus.fire(UIChangeEvent.changeCourseColor()))
                    .then((value) => _refreshController.requestRefresh());
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  void _showCustomColorPicker(String courseName, Color pickerColor) {
    showDialog(
      context: context,
      builder: (context) {
        var selectedColor = pickerColor;
        return AlertDialog(
          title: const Text("选择颜色"),
          content: SingleChildScrollView(
              child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteCourseColor(courseName)
                    .then((value) =>
                        eventBus.fire(UIChangeEvent.changeCourseColor()))
                    .then((value) => _refreshController.requestRefresh());
              },
              child: const Text("重置为默认"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveCourseColor(courseName, selectedColor)
                    .then((value) =>
                        eventBus.fire(UIChangeEvent.changeCourseColor()))
                    .then((value) => _refreshController.requestRefresh());
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }
}

class CustomColor {
  final String courseName;
  final Color color;

  CustomColor({required this.courseName, required this.color});
}
