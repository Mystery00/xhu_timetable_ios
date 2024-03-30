import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xhu_timetable_ios/repository/start.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/toast.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("data error, ${snapshot.error}");
            }
            var state = snapshot.data as ReadyState;
            if (state.errorMessage != null) {
              showToast(fToast, state.errorMessage!);
            }
            if (state.isLogin) {
              Navigator.pushReplacementNamed(context, routeMain);
            } else {
              Navigator.pushReplacementNamed(context, routeLogin);
            }
            return Text(snapshot.data.toString());
          } else {
            return const Text("Splash Screen");
          }
        },
      ),
    ));
  }
}
