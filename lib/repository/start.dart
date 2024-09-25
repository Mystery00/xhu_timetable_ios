import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xhu_timetable_ios/api/rest/common.dart';
import 'package:xhu_timetable_ios/api/rest/menu.dart';
import 'package:xhu_timetable_ios/model/client_init.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/downloader.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

Future<ReadyState> init() async {
  var isUserLogin = false;
  String? errorMessage;
  //初始化全局通用数据
  try {
    isUserLogin = await isLogin();
    var response = await apiClientInit();
    await setCustomTermStartDate(
        Customisable.notCustom(response.xhuStartTime.startDate));
    await setCustomNowYear(
        Customisable.notCustom(response.xhuStartTime.nowYear));
    await setCustomNowTerm(
        Customisable.notCustom(response.xhuStartTime.nowTerm));
    await setSplashList(response.splash);
  } catch (e) {
    Logger().w(e);
    errorMessage = e.toString();
  }
  //初始化菜单
  await _initMenu();
  //初始化团队成员列表
  _initTeamMember();
  //判断启动页信息
  Splash? splash = await _initSplash();
  File? splashFile;
  if (splash != null) {
    var dir = await getApplicationDocumentsDirectory();
    splashFile = getSplashFilePath(dir, splash);
  }
  return ReadyState(
      isLogin: isUserLogin,
      splashFile: splashFile,
      splash: splash,
      errorMessage: errorMessage);
}

Future<void> _initMenu() async {
  if (await isMenuStoreEmpty()) {
    //没有缓存菜单，阻塞到获取到菜单
    try {
      List<Menu> menuList = await apiGetMenuList();
      await updateMenuList(menuList);
    } catch (e) {
      Logger().w(e);
    }
  } else {
    //有缓存菜单，后台更新菜单
    apiGetMenuList().then((value) => updateMenuList(value));
  }
}

void _initTeamMember() {
  apiTeamMemberList().then((value) => setTeamMemberList(value));
}

Future<Splash?> _initSplash() async {
  try {
    var hideTime = await getHideSplashBefore();
    if (DateTime.now().isBefore(hideTime)) {
      return null;
    }
    var now = DateTime.now();
    List<Splash> existSplashList = [];
    var dir = await getApplicationDocumentsDirectory();
    List<Splash> splashList = await getSplashList();
    Map<String, String> downloadSplashMap = {};
    splashList
        .where((element) =>
            now.isAfter(element.startShowTime) &&
            now.isBefore(element.endShowTime))
        .where((e) {
      var fileName = getSplashFileName(e);
      File file = getSplashFilePath(dir, e);
      bool exist = file.existsSync();
      if (!exist) {
        downloadSplashMap[e.imageUrl] = fileName;
      }
      return exist;
    }).forEach((element) {
      existSplashList.add(element);
    });
    if (downloadSplashMap.isNotEmpty) {
      downloadSplashMap.forEach((url, fileName) {
        var task = DownloadTask(
            group: 'splash',
            url: url,
            baseDirectory: BaseDirectory.applicationDocuments,
            directory: 'splash',
            filename: fileName,
            updates: Updates.status);
        enqueueTask(task);
      });
    }
    if (existSplashList.isEmpty) {
      return null;
    }
    existSplashList.shuffle();
    Splash splash = existSplashList.first;
    return splash;
  } catch (e) {
    Logger().w(e);
    return null;
  }
}

File getSplashFilePath(Directory dir, Splash splash) {
  var fileName = getSplashFileName(splash);
  return File("${dir.path}/splash/$fileName");
}

String getSplashFileName(Splash splash) {
  var extension =
      splash.imageUrl.substring(splash.imageUrl.lastIndexOf(".") + 1);
  return "${md5.convert(utf8.encode(splash.splashId.toString()))}-${md5.convert(utf8.encode(splash.imageUrl))}.$extension";
}

class ReadyState {
  final bool isLogin;
  final File? splashFile;
  final Splash? splash;
  final String? errorMessage;

  ReadyState(
      {required this.isLogin,
      required this.splashFile,
      required this.splash,
      required this.errorMessage});
}
