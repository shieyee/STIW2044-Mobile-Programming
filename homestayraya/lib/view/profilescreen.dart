import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/shared/config.dart';
import 'package:homestayraya/shared/mainmenu.dart';
import 'package:homestayraya/view/buyerscreen.dart';
import 'package:homestayraya/view/registerscreen.dart';
import 'package:homestayraya/view/userloginscreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "assets/images/profile.png";
  final df = DateFormat('dd/MM/yyyy');
  var val = 50;
  bool isDisable = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldpassController = TextEditingController();
  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _contactnoController = TextEditingController();
  Random random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.user.id == "0") {
      isDisable = true;
    } else {
      isDisable = false;
    }
    _nameController.text = widget.user.name.toString();
    _contactnoController.text = widget.user.contactno.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Column(children: [
            Padding(padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: screenHeight * 0.25,
              child: Row(
                children: [
                  Flexible(flex: 4,
                  child: SizedBox(height: screenHeight * 0.25,
                  child: GestureDetector(
                    onTap: isDisable ? null : _updateImageDialog,
                    child: Padding(padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: CachedNetworkImage(imageUrl: "${ServerConfig.SERVER}assets/profileimages/${widget.user.id}.png?v=$val",
                    placeholder: (context, url) => 
                    const LinearProgressIndicator(),
                    errorWidget:(context, url, error) => 
                    const Icon
                    (Icons.image_not_supported,
                    size: 128,
                  ),
                  ),
                  ),
                  )),
              ),
              Flexible(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.user.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                                child: Divider(
                                  color: Colors.blueGrey,
                                  height: 2,
                                  thickness: 2.0,
                                ),
                              ),
                              Table(
                                columnWidths: const {
                                  0: FractionColumnWidth(0.3),
                                  1: FractionColumnWidth(0.7)
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    const Icon(Icons.email),
                                    Text(widget.user.email.toString()),
                                  ]),
                                  TableRow(children: [
                                    const Icon(Icons.phone),
                                    Text(widget.user.contactno.toString()),
                                  ]),
                                  // TableRow(children: [
                                  //   const Icon(Icons.credit_score),
                                  //   Text(widget.user.credit.toString()),
                                  // ]),
                                  widget.user.regdate.toString() == ""
                                      ? TableRow(children: [
                                          const Icon(Icons.date_range),
                                          Text(df.format(DateTime.parse(
                                              widget.user.regdate.toString())))
                                        ])
                                      : TableRow(children: [
                                          const Icon(Icons.date_range),
                                          Text(df.format(DateTime.now()))
                                        ]),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
                Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        alignment: Alignment.center,
                        color: Theme.of(context).backgroundColor,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text("PROFILE SETTINGS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                     Expanded(
                          child: ListView(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              shrinkWrap: true,
                              children: [
                            MaterialButton(
                              onPressed: isDisable ? null : _updateNameDialog,
                              child: const Text("UPDATE NAME"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: isDisable ? null : _updateContactDialog,
                              child: const Text("UPDATE CONTACT"),
                            ),
                            MaterialButton(
                              onPressed: isDisable ? null : _changePassDialog,
                              child: const Text("UPDATE PASSWORD"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: _registerAccountDialog,
                              child: const Text("NEW REGISTRATION"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: _loginDialog,
                              child: const Text("LOGIN"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            // MaterialButton(
                            //   onPressed: isDisable ? null : buyCreditPage,
                            //   child: const Text("BUY CREDIT"),
                            // ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: isDisable ? null : _logoutDialog,
                              child: const Text("LOGOUT"),
                            ),
                          ])),
                    ],
                  ),
                )),
          ]),
          drawer: MainMenuWidget(
            user: widget.user,
          )),
    );
  } 

void _registerAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "New Account Registration",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const Registration()));
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

  void _loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Login",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const Login()));
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

   _updateImageDialog() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
     },
    );
   }
    
     _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }
  
    _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage(_image);
    }
  }

void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(Uri.parse("${ServerConfig.SERVER}php/update_profile.php"),
        body: {
          "user_id": widget.user.id,
          "image": base64Image,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        val = random.nextInt(1000);
        setState(() {});
        DefaultCacheManager manager = DefaultCacheManager();
        manager.emptyCache();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }


     void _updateNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Name?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newname = _nameController.text;
                _updateName(newname);
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

  void _updateName(String newname) {
    http.post(Uri.parse("${ServerConfig.SERVER}php/update_profile.php"),
        body: {
          "user_id": widget.user.id,
          "newname": newname,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.name = newname;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updateContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Contact?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _contactnoController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'Contact',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new your contact number';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newcontact = _contactnoController.text;
                _updateContact(newcontact);
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

  void _updateContact(String newcontact) {
    http.post(Uri.parse("${ServerConfig.SERVER}php/update_profile.php"),
        body: {
          "user_id": widget.user.id,
          "newcontact": newcontact,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.contactno = newcontact;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldpassController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newpassController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
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

void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(),
          ),
          content: const Text("Are your sure"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                await prefs.setBool('remember', false);
                User user = User(
                    id: "0",
                    email: "unregistered@email.com",
                    name: "unregistered",
                    contactno: '0184723800',
                    regdate: "0",
                    address: "na",
                    );
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => BuyerScreen(user: user)));
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
  void changePass() {
    http.post(Uri.parse("${ServerConfig.SERVER}php/update_profile.php"),
        body: {
          "user_id": widget.user.id,
          "oldpass": _oldpassController.text,
          "newpass": _newpassController.text,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  }
  // void _registrationForm() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (content) => const Registration()));
  // }

  // void _loginForm() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (content) => const Login()));
  // }
