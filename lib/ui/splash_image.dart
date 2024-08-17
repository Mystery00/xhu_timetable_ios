import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/client_init.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';
import 'package:xhu_timetable_ios/url.dart';

class SplashImageArguments {
  final String filePath;
  final Splash splash;

  SplashImageArguments({required this.filePath, required this.splash});
}

class SplashImageRoute extends StatefulWidget {
  const SplashImageRoute({super.key});

  @override
  SplashImageRouteState createState() => SplashImageRouteState();
}

class SplashImageRouteState extends State<SplashImageRoute> {
  late Timer _timer;
  int stopTime = 10;
  int _time = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _time++;
      if (_time >= stopTime) {
        _timer.cancel();
        Navigator.pushReplacementNamed(context, routeMain);
      }
      setState(() {});
    });
  }

  void tapHide() async {
    var hideDate = DateTime.now().add(const Duration(days: 7));
    setHideSplashBefore(hideDate);
    showToast("启动图将会隐藏7天");
  }

  void tapSkip() {
    _timer.cancel();
    Navigator.pushReplacementNamed(context, routeMain);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SplashImageArguments;
    setState(() {
      stopTime = args.splash.showTime;
    });
    return Stack(
      children: [
        if (args.splash.backgroundColor.isNotEmpty)
          Container(color: HexColor.fromHex(args.splash.backgroundColor)),
        GestureDetector(
          onTap: () => {
            if (args.splash.locationUrl.isNotEmpty)
              loadInBrowser(args.splash.locationUrl)
          },
          child: Image.file(
            File(args.filePath),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          bottom: 48,
          right: 36,
          child: TextButton(
              onPressed: tapSkip,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0x80000000)),
              ),
              child: Text(stopTime == 0 ? "跳 过" : "跳 过 ${stopTime - _time}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center)),
        ),
        Positioned(
          bottom: 48,
          left: 36,
          child: TextButton(
              onPressed: tapHide,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0x80000000)),
              ),
              child: const Text('隐藏',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
