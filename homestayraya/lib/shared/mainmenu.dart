import 'package:flutter/material.dart';
import 'package:homestayraya/view/buyerscreen.dart';
import 'package:homestayraya/view/profilescreen.dart';
import 'package:homestayraya/view/sellerscreen.dart';
import 'EnterExitRoute.dart';

import '../../models/user.dart';


class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('Buyer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: BuyerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Seller'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: SellerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: ProfileScreen(
                        user: widget.user,
                      )));
            },
          ),
        ],
      ),
    );
  }
}