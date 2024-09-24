import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xhu_timetable_ios/repository/start.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/splash_image.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _doInint(context);
  }

  void _doInint(BuildContext context) {
    var startTime = DateTime.now();
    init().then((readyState) {
      var duration = DateTime.now().difference(startTime);
      log("init duration: ${duration.inMilliseconds}ms");
      if (readyState.errorMessage != null) {
        showToast(readyState.errorMessage!);
      }
      if (!readyState.isLogin) {
        Navigator.pushReplacementNamed(context, routeLogin);
      } else if (readyState.splashFile == null || readyState.splash == null) {
        Navigator.pushReplacementNamed(context, routeMain);
      } else {
        Navigator.pushReplacementNamed(context, routeSplashImage,
            arguments: SplashImageArguments(
                filePath: readyState.splashFile!.path,
                splash: readyState.splash!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF2196F3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/icon.png", width: 180, height: 180),
              const SizedBox(
                height: 156,
              ),
              const SpinKitCircle(
                color: Colors.white,
                size: 50.0,
              ),
              const SizedBox(
                height: 24,
              ),
              Image.asset("assets/images/splash_bottom.png", height: 120),
            ],
          ),
        ));
  }
}
