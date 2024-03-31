import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/repository/start.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/toast.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _doInint();
  }

  Future<void> _doInint() async {
    var readyState = await init();
    if (readyState.errorMessage != null) {
      showToast(readyState.errorMessage!);
    }
    if (readyState.isLogin) {
      Navigator.pushReplacementNamed(context, routeMain);
    } else {
      Navigator.pushReplacementNamed(context, routeLogin);
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
