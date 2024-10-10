import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:xhu_timetable_ios/api/rest/calendar.dart';
import 'package:xhu_timetable_ios/model/calendar.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';

class SchoolCalendarRoute extends StatefulWidget {
  const SchoolCalendarRoute({super.key});

  @override
  State<SchoolCalendarRoute> createState() => _SchoolCalendarRouteState();
}

class _SchoolCalendarRouteState extends SelectState<SchoolCalendarRoute> {
  String selectedArea = "数据请求中...";
  String areaImageUrl = "";
  List<SchoolCalendarResponse> calendarList = [];

  @override
  void initState() {
    super.initState();
    _getSchoolCalendarList().then((value) {
      setState(() {
        calendarList = value;
      });
      _changeArea(value[0].area);
    });
  }

  Future<void> _changeArea(String area) async {
    var url = areaImageUrl;
    for (var element in calendarList) {
      if (element.area == area) {
        url = element.imageUrl;
      }
    }
    setState(() {
      selectedArea = area;
      areaImageUrl = url;
    });
  }

  Future<List<SchoolCalendarResponse>> _getSchoolCalendarList() async {
    User user = await mainUser();
    var list = await user.withAutoLoginOnce(
        (sessionToken) => apiSchoolCalendarList(sessionToken));
    return list;
  }

  Future<bool> _saveImage() async {
    var extension = areaImageUrl.split(".").last;
    var response = await Dio()
        .get(areaImageUrl, options: Options(responseType: ResponseType.bytes));
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        name: "校历-$selectedArea.$extension");
    return result['isSuccess'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("校历($selectedArea)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              _saveImage().then((value) => showToast(value ? "保存成功" : "保存失败"));
            },
          ),
        ],
      ),
      body: areaImageUrl.isNotEmpty
          ? PhotoView(
              imageProvider: NetworkImage(areaImageUrl),
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.refresh_outlined),
        label: const Text("切换校区"),
        onPressed: () {
          var index = calendarList
              .indexWhere((element) => element.area == selectedArea);
          var nextIndex = (index + 1) % calendarList.length;
          _changeArea(calendarList[nextIndex].area);
        },
      ),
    );
  }
}
