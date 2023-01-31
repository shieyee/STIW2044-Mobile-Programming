import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/shared/config.dart';
import 'package:homestayraya/view/userloginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  void initState() {
    super.initState();
    loadEula();
  }

  bool _isChecked = false;
  String eula = '';
  bool _passwordVisible = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterpassController = TextEditingController();
  final TextEditingController _contactnoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // var screenHeight, screenWidth, cardwitdh;
  
  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Homestay Raya", style: TextStyle(fontSize: 17))),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //     height: screenHeight / 3,
              //     width: screenWidth,
              //     child: Image.asset(
              //       pathAsset,
              //       fit: BoxFit.fill,
              //     )),
              Card(
                elevation: 8,
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text("Register Account",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Name must be longer than 3"
                                : null,
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ))),
                        TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Please enter a valid email"
                                : null,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ))),
                        TextFormField(
                            controller: _contactnoController,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Please enter valid contact number"
                                    : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Contact No',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ))),
                        TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            validator: (val) =>
                                validatePassword(val.toString()),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(),
                              icon: const Icon(Icons.password),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            )),
                        TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            controller: _reenterpassController,
                            validator: (val) {
                              validatePassword(val.toString());
                              if (val != _passwordController.text) {
                                return "Password Do Not Match";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Re-Password',
                              labelStyle: const TextStyle(),
                              icon: const Icon(Icons.password),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: showEula,
                                child: const Text('Agree with terms',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minWidth: 100,
                              height: 50,
                              elevation: 10,
                              onPressed: _registerAccount,
                              color: Theme.of(context).colorScheme.primary,
                              child: const Text('REGISTER'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already Register?",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const Login()))
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              // GestureDetector(
              //   onTap: null,
              //   child: const Text(
              //     "Back to Home",
              //     style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password minimum 10 characters';
      } else {
        return null;
      }
    }
  }

  void _registerAccount() {
    String name = _nameController.text;
    String email = _emailController.text;
    String contactno = _contactnoController.text;
    String password = _passwordController.text;
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in all the fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please Accept Term",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser(name, email, contactno, password);
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

  void _registerUser(
      String name, String email, String contactno, String password) {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/register_users.php"), body: {
        'name': name,
        'email': email,
        'contactno': contactno,
        'password': password,
        'register': 'register',
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Successfully Register",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 14.0);
          progressDialog.dismiss();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Register",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 14.0);
          progressDialog.dismiss();
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
