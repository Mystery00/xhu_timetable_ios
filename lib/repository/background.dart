import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';

Future<void> setDefaultBackground() async {
  await setBackgroundImage(Customisable.clearCustom(null));
}

Future<void> setCustomBackgroundFile(String filePath) async {
  var directory = await getApplicationDocumentsDirectory();
  var timestamp = DateTime.now().millisecondsSinceEpoch;
  var extension = filePath.split('.').last;
  var targetSaveFile =
      File("${directory.path}/background/custom-$timestamp.$extension");
  await targetSaveFile.writeAsBytes(await File(filePath).readAsBytes());
  await setBackgroundImage(Customisable.custom(targetSaveFile));
}

Future<void> setBackground(int backgroundId, int resourceId, String imageUrl,
    ProgressDialog pd) async {
  if (backgroundId == 0) {
    //设置为默认图片
    await setDefaultBackground();
    return;
  }
  if (backgroundId == -1) {
    //设置为自定义图片
    await setCustomBackgroundFile(imageUrl);
    return;
  }
  var targetSaveFile =
      await getBackgroundFile(backgroundId, resourceId, imageUrl);
  //获取当前设置的背景图信息
  var backgroundFile = await getBackgroundImage();
  if (backgroundFile.data != null &&
      backgroundFile.data!.path == targetSaveFile.path) {
    //已经设置了这张背景图，不处理
    return;
  }
  //下载背景图
  var dio = Dio();
  await dio.download(
    imageUrl,
    targetSaveFile.path,
    onReceiveProgress: (rec, total) {
      pd.update(value: (((rec / total) * 100).toInt()));
    },
  );
  if (await targetSaveFile.exists()) {
    //下载成功
    await setBackgroundImage(Customisable.notCustom(targetSaveFile));
  } else {
    //下载失败，设置为默认图
    Logger().e("download background failed: $imageUrl");
    await setBackgroundImage(Customisable.clearCustom(null));
  }
}

Future<File> getBackgroundFile(
    int backgroundId, int resourceId, String imageUrl) async {
  var fileName = generateBackgroundFileName(backgroundId, resourceId, imageUrl);
  var directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/background/$fileName");
}

String generateBackgroundFileName(
    int backgroundId, int resourceId, String imageUrl) {
  var backgroundIdMd5 =
      md5.convert(utf8.encode(backgroundId.toString())).toString();
  var resourceIdMd5 =
      md5.convert(utf8.encode(resourceId.toString())).toString();
  var imageUrlMd5 = md5.convert(utf8.encode(imageUrl)).toString();
  var name = "$backgroundIdMd5-$resourceIdMd5-$imageUrlMd5";
  var fileName = sha1.convert(utf8.encode(name)).toString();
  var extension = imageUrl.split('.').last;
  return "$fileName.$extension";
}

Future<void> downloadBackground(
    int backgroundId, int resourceId, String imageUrl) async {}
