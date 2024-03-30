import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/repository/splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: clientInit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("data error, ${snapshot.error}");
            }
            // setState(() {
            // Navigator.pushNamed(context, "/login");
            // });
            return Text(snapshot.data.toString());
          } else {
            return const Text("Splash Screen");
          }
        },
      ),
    ));
  }
}
