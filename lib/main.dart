import 'package:flutter/material.dart';
import "package:mmkv/mmkv.dart";
import 'package:xhu_timetable_ios/ui/login.dart';
import 'ui/home/home.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String dir = (await getApplicationDocumentsDirectory()).path;
  await MMKV.initialize(groupDir: "$dir/mmkv");
  await FkUserAgent.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '西瓜课表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //注册路由表
      routes: {
        "login": (context) => const LoginRoute(),
        "main":(context) => const MainRoute(),
      },
      home: const LoginRoute(),
    );
  }
}
