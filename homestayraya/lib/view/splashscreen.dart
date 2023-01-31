import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homestayraya/view/userloginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override //overide is the method already available in the system, and you want to reimplement other thing
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (content) => const Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                "Homestay Raya",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(),
              Text("Version 1111")
            ]),
      ),
    );
  }
}
