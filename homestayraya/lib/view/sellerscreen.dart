import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/shared/config.dart';
import 'package:homestayraya/shared/mainmenu.dart';
import 'package:homestayraya/view/detailsscreen.dart';
import 'package:homestayraya/view/newhomestayscreen.dart';
import 'package:homestayraya/view/registerscreen.dart';
import 'package:homestayraya/view/userloginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class SellerScreen extends StatefulWidget {
  final User user;
  const SellerScreen({super.key, required this.user});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  late Position position;
  List<Homestay> homestayList = <Homestay>[];
  var placemarks;
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadHomestay();
  }

  @override
  void dispose() {
    homestayList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Seller"), actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New Homestay"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("My Order"),
                )
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotoNewHomestay();
                print("New Homestay is selected.");
              } else if (value == 1) {
                print("My Order is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ]),
          body: homestayList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your current homestays (${homestayList.length} found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: rowcount,
                            children:
                                List.generate(homestayList.length, (index) {
                              return Card(
                                elevation: 8,
                                child: InkWell(
                                    onTap: () {
                                      _showDetails(index);
                                    },
                                    onLongPress: () {
                                      _deleteDialog(index);
                                    },
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: CachedNetworkImage(
                                            width: resWidth / 2,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${ServerConfig.SERVER}assets/homestayimages/${homestayList[index].homestayId}.png",
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 4,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Text(
                                                    truncateString(
                                                        homestayList[index]
                                                            .homestayName
                                                            .toString(),
                                                        15),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "RM ${double.parse(homestayList[index].homestayPrice.toString()).toStringAsFixed(2)}"),
                                                  Text(df.format(DateTime.parse(
                                                      homestayList[index]
                                                          .homestayDate
                                                          .toString()))),
                                                ])))
                                      ],
                                    )),
                              );
                            })))
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user)),
    );
  }

  void registrationform() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const Registration()));
  }

  void loginform() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const Login()));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _gotoNewHomestay() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 14.0);
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (await checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHomestay(
                  position: position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadHomestay();
    } else {
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
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
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

  void _loadHomestay() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      titlecenter = "Please register an account";
      setState(() {
      });
      return; //exit method if true
    }
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/loadsellerhomestay.php?user_id=${widget.user.id}"),
    )
        .then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['homestay'] != null) {
            //check if  array object is not null
            homestayList = <Homestay>[]; //complete the array object definition
            extractdata['homestay'].forEach((v) {
              //traverse homestay array list and add to the list object array homestaylist
              homestayList.add(Homestay.fromJson(
                  v)); //add each homestay array to the list object array homestayList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Homestay Available"; //if no data returned show title center
            homestayList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        homestayList.clear(); //clear homestaylist array
      }
      setState(() {}); //refresh UI
    });
  }

  Future<void> _showDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homestayList[index].toJson());
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestay();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(homestayList[index].homestayName.toString(), 15)}",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteHomestay(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteHomestay(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/delete_homestay.php"), body: {
        "homestay_id": homestayList[index].homestayId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Delete Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadHomestay();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Delete Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
