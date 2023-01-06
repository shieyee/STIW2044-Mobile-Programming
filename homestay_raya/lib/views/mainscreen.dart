import 'package:flutter/material.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/shared/mainmenu.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: const Text("Buyer")),
          body: const Center(child: Text("Buyer")),
          drawer: MainMenuWidget(user: widget.user,)
          
    );
    }
    }