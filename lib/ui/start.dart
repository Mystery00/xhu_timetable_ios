import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/repository/start.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/toast.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _doInint().then((value) => Navigator.pushReplacementNamed(context, value));
  }

  Future<String> _doInint() async {
    var readyState = await init();
    if (readyState.errorMessage != null) {
      showToast(readyState.errorMessage!);
    }
    if (readyState.isLogin) {
      return routeMain;
    } else {
      return routeLogin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Splash Screen"),
    ));
  }
}
