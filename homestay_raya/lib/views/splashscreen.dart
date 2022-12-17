import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homestay_raya/views/userloginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (content) => const UserLoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              "Homestay Raya",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator(),
            Text("version 1.0")
          ],
        ),
      ),
    );
  }
}
