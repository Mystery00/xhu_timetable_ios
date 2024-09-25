import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:xhu_timetable_ios/api/rest/background.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/background.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class BackgroundRoute extends StatefulWidget {
  const BackgroundRoute({super.key});

  @override
  State<BackgroundRoute> createState() => _BackgroundRouteState();
}

class _BackgroundRouteState extends SelectState<BackgroundRoute> {
  EventBus eventBus = getEventBus();

  List<_background> backgroundList = [];
  final _refreshController = RefreshController(initialRefresh: true);

  Future<void> _justSelectUpdate() async {
    var copyList = backgroundList.map((e) {
      e.selected = false;
      return e;
    }).toList();
    var backgroundImage = await getBackgroundImage();
    //没有设置背景图
    if (backgroundImage.data == null) {
      copyList[0].selected = true;
    } else if (backgroundImage.data != null && backgroundImage.custom) {
      //设置了背景图
      copyList[1].selected = true;
    } else {
      //设置了背景图，但是是图库的
      var selectedBackgroundFileName =
          backgroundImage.data!.path.split('/').last;
      backgroundList.firstWhere((element) {
        var backgroundFileName = generateBackgroundFileName(
            element.backgroundId, element.resourceId, element.imageUrl);
        return backgroundFileName == selectedBackgroundFileName;
      }).selected = true;
    }
    setState(() {
      backgroundList = copyList;
    });
  }

  void _onRefresh() async {
    try {
      var list = await _getBackgroundList();
      setState(() {
        backgroundList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  Future<List<_background>> _getBackgroundList() async {
    var backgroundImage = await getBackgroundImage();
    User user = await mainUser();
    var list = await user
        .withAutoLoginOnce((sessionToken) => apiBackgroundList(sessionToken));
    var resultList = list
        .map((e) => _background(
              backgroundId: e.backgroundId,
              resourceId: e.resourceId,
              thumbnailUrl: e.thumbnailUrl,
              imageUrl: e.imageUrl,
            ))
        .toList();
    //添加默认背景图
    resultList = [
      _background(
        backgroundId: 0,
        resourceId: 0,
        assertPath: "assets/images/main_bg.png",
      ),
      //自定义了图片
      if (backgroundImage.data != null && backgroundImage.custom)
        _background(
            backgroundId: -1, resourceId: -1, imageFile: backgroundImage.data),
      ...resultList,
    ];
    //没有设置背景图
    if (backgroundImage.data == null) {
      resultList[0].selected = true;
    } else if (backgroundImage.data != null && backgroundImage.custom) {
      //设置了背景图
      resultList[1].selected = true;
    } else {
      //设置了背景图，但是是图库的
      var selectedBackgroundFileName =
          backgroundImage.data!.path.split('/').last;
      for (var element in resultList) {
        var backgroundFileName = generateBackgroundFileName(
            element.backgroundId, element.resourceId, element.imageUrl);
        if (backgroundFileName == selectedBackgroundFileName) {
          element.selected = true;
        }
      }
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自定义背景图片"),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore_outlined),
            onPressed: () {
              setDefaultBackground().then((value) => _justSelectUpdate()).then(
                  (value) => eventBus.fire(UIChangeEvent.changeBackground()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              //TODO: 设置为自定义图片
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.0),
            itemCount: backgroundList.length,
            itemBuilder: (context, index) => _buildItem(backgroundList[index])),
      ),
    );
  }

  Widget _buildItem(_background b) {
    Image image;
    if (b.thumbnailUrl.isNotEmpty) {
      image = Image.network(
        b.thumbnailUrl,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : const CircularProgressIndicator(),
      );
    } else if (b.assertPath.isNotEmpty) {
      image = Image.asset(b.assertPath);
    } else {
      image = Image.file(b.imageFile!);
    }
    return InkWell(
      onTap: () {
        var pd = ProgressDialog(context: context);
        pd.show(
          max: 100,
          msg: "下载文件中...",
          completed: Completed(
            completedMsg: "下载完成",
          ),
        );
        setBackground(b.backgroundId, b.resourceId, b.imageUrl, pd)
            .then((value) => _justSelectUpdate())
            .then((value) => pd.close(delay: 300))
            .then((value) => eventBus.fire(UIChangeEvent.changeBackground()));
      },
      child: Stack(
        children: [
          Center(
            child: image,
          ),
          if (b.selected)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 6,
                ),
              ),
            ),
          if (b.selected)
            const Positioned(
              bottom: 2,
              right: 2,
              child: Image(
                width: 24,
                height: 24,
                image: Svg("assets/icons/svg/ic_checked.svg"),
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _background {
  final int backgroundId;
  final int resourceId;
  String thumbnailUrl;
  String imageUrl;
  String assertPath;
  File? imageFile;
  bool selected = false;

  _background({
    required this.backgroundId,
    required this.resourceId,
    this.thumbnailUrl = "",
    this.imageUrl = "",
    this.assertPath = "",
    this.imageFile,
  });
}
