import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'splash_screen.dart';

void main() {

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {

  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState
    extends State<MyApp> {

  String? token;

  @override
  void initState() {

    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    token =
    prefs.getString("access_token");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner:
      false,

      home: const SplashScreen(),
    );
  }
}