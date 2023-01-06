import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/shared/mainmenu.dart';
import 'package:homestay_raya/views/mainscreen.dart';
import 'package:homestay_raya/views/newproductscreen.dart';
import 'package:homestay_raya/views/profilescreen.dart';
import 'package:homestay_raya/views/registrationscreen.dart';
import 'package:homestay_raya/views/userloginscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SellerScreen extends StatefulWidget {
  final User user;
  const SellerScreen({super.key, required this.user});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
    late Position position;
    var placemarks;
      var _lat, _lng;
  @override
    void initState() {
    super.initState();
    // _checkPermissionGetLoc();
    // _lat = widget.position.latitude.toString();
    // _lng = widget.position.longitude.toString();
  }
  Widget build(BuildContext context) {
return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Seller'),
        actions:[
        PopupMenuButton(
          itemBuilder: (context) {
          return[
            const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New Homestay"),
            ),
            const PopupMenuItem<int>(
                  value: 1,
                  child: Text("My Order"),
            )
          ];
          },
          onSelected: (value) {
              if (value == 0) {
                _gotoNewHomestay();
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ]),
          drawer: MainMenuWidget(user: widget.user)),
        );
  }
  
  Future <void> _gotoNewHomestay() async{
    if (widget.user.name == null) {
      Fluttertoast.showToast(
          msg: "Please register an account with us",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
  }
 if (await checkPermissionGetLoc()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewProductScreen(
                  position: position,
                  user: widget.user,
                  placemarks: placemarks)));
}else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }
Future<bool> checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

}