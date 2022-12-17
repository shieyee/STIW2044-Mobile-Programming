import 'package:flutter/material.dart';
import 'package:homestay_raya/views/registrationscreen.dart';
import 'package:homestay_raya/views/userloginscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(title: const Text("Homestay Raya"), actions: [
            IconButton(
                onPressed: _registrationForm,
                icon: const Icon(Icons.app_registration)),
            IconButton(onPressed: _loginForm, icon: const Icon(Icons.login)),
          ]),
          body: const Center(child: Text("Home Page")),
        ));
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const UserLoginScreen()));
  }
}
