import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:mmkv/mmkv.dart";
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/page.dart';
import 'package:xhu_timetable_ios/store/app.dart';
import 'package:xhu_timetable_ios/store/downloader.dart';
import 'package:xhu_timetable_ios/ui/account_settings.dart';
import 'package:xhu_timetable_ios/ui/background.dart';
import 'package:xhu_timetable_ios/ui/class_settings.dart';
import 'package:xhu_timetable_ios/ui/custom_course_color.dart';
import 'package:xhu_timetable_ios/ui/custom_thing.dart';
import 'package:xhu_timetable_ios/ui/login.dart';
import 'package:xhu_timetable_ios/ui/query_exam.dart';
import 'package:xhu_timetable_ios/ui/query_exp_score.dart';
import 'package:xhu_timetable_ios/ui/query_notice.dart';
import 'package:xhu_timetable_ios/ui/query_score.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/school_calendar.dart';
import 'package:xhu_timetable_ios/ui/settings.dart';
import 'package:xhu_timetable_ios/ui/splash_image.dart';
import 'package:xhu_timetable_ios/ui/start.dart';
import 'package:xhu_timetable_ios/ui/main/main.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  String dir = (await getApplicationDocumentsDirectory()).path;
  await MMKV.initialize(groupDir: "$dir/mmkv");
  await FkUserAgent.init();
  await initApp();
  ColorScheme colorScheme = await ColorScheme.fromImageProvider(
      provider: const AssetImage("assets/images/main_bg.png"));
  initDownloader();

  FlutterNativeSplash.remove();
  runApp(MyApp(colorScheme: colorScheme));
}

class MyApp extends StatelessWidget {
  final ColorScheme colorScheme;

  const MyApp({super.key, required this.colorScheme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const XhuHeader(),
      footerBuilder: () => const XhuFooter(),
      child: MaterialApp(
        title: '西瓜课表',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
        ),
        //注册路由表
        routes: {
          routeStart: (context) => const StartScreen(),
          routeLogin: (context) => const LoginRoute(),
          routeSplashImage: (context) => const SplashImageRoute(),
          routeMain: (context) => const MainRoute(),
          routeAccountSettings: (context) => const AccountSettingsRoute(),
          routeClassSettings: (context) => const ClassSettingsRoute(),
          routeSettings: (context) => const SettingsRoute(),
          routeQueryExam: (context) => const QueryExamRoute(),
          routeQueryNotice: (context) => const QueryNoticeRoute(),
          routeQueryScore: (context) => const QueryScoreRoute(),
          routeQueryExpScore: (context) => const QueryExpScoreRoute(),
          routeBackground: (context) => const BackgroundRoute(),
          routeSchoolCalendar: (context) => const SchoolCalendarRoute(),
          routeCustomCourseColor: (context) => const CustomCourseColorRoute(),
          routeCustomThing: (context) => const CustomThingRoute(),
        },
        builder: FToastBuilder(),
      ),
    );
  }
}
