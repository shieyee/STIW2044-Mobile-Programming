import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/shared/config.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  const DetailsScreen({super.key, required this.homestay, required this.user});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  File? _image;
  var pathAsset = "assets/images/camera.png";
  bool _isChecked = false;
  final TextEditingController homestaynameEditingController =
      TextEditingController();
  final TextEditingController homestaydescEditingController =
      TextEditingController();
  final TextEditingController homestaypriceEditingController =
      TextEditingController();
  final TextEditingController roomqtyEditingController =
      TextEditingController();
  final TextEditingController bedqtyEditingController = TextEditingController();
  final TextEditingController homestaystateEditingController =
      TextEditingController();
  final TextEditingController homestaylocalEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
    homestaynameEditingController.text =
        widget.homestay.homestayName.toString();
    homestaydescEditingController.text =
        widget.homestay.homestayDesc.toString();
    homestaypriceEditingController.text =
        widget.homestay.homestayPrice.toString();
    roomqtyEditingController.text = widget.homestay.homestayRoomqty.toString();
    bedqtyEditingController.text = widget.homestay.homestayBedqty.toString();
    homestaystateEditingController.text =
        widget.homestay.homestayState.toString();
    homestaylocalEditingController.text =
        widget.homestay.homestayLocal.toString();
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
    return Scaffold(
        appBar: AppBar(title: const Text("Edit Homestay Details")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}assets/homestayimages/${widget.homestay.homestayId}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const Text(
                "Homestay Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: homestaynameEditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Homestay name must be longer than 3"
                                      : null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Homestay Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.home),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: homestaydescEditingController,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 10)
                                  ? "Homestay description must be longer than 10"
                                  : null,
                              maxLines: 4,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Homestay Description',
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(),
                                  icon: Icon(
                                    Icons.book,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: homestaypriceEditingController,
                                    validator: (val) => val!.isEmpty
                                        ? "Homestay price must contain value"
                                        : null,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Homestay Price',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.money),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: roomqtyEditingController,
                                    validator: (val) => val!.isEmpty
                                        ? "Room quantity should be more than 0"
                                        : null,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Room Quantity',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.bed),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                            ],
                          ),
                          Row(children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: bedqtyEditingController,
                                  validator: (val) => val!.isEmpty
                                      ? "Bed quantity should be more than 0"
                                      : null,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Bed Quantity',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.bed),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            ),
                            Flexible(
                                flex: 5,
                                child: CheckboxListTile(
                                  title: const Text("Policy"), // <‐‐ label
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                )),
                          ]),
                          Row(children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current State"
                                            : null,
                                    enabled: false,
                                    controller: homestaystateEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.flag),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    enabled: false,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current Locality"
                                            : null,
                                    controller: homestaylocalEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current Locality',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.map),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                          ]),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              child: const Text('Update Homestay'),
                              onPressed: () => {_updateHomestayDialog()},
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }

  _updateHomestayDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please agree with the policy",
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
            "Update this homestay details?",
            style: TextStyle(fontSize: 18),
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
                _updateHomestay();
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

  void _updateHomestay() {
    String homestayName = homestaynameEditingController.text;
    String homestayDesc = homestaydescEditingController.text;
    String homestayPrice = homestaypriceEditingController.text;
    String roomQty = roomqtyEditingController.text;
    String bedQty = bedqtyEditingController.text;

    http.post(Uri.parse("${ServerConfig.SERVER}php/update_homestay.php"), body: {
      "homestay_id": widget.homestay.homestayId,
      "user_id": widget.user.id,
      "homestay_name": homestayName,
      "homestay_desc": homestayDesc,
      "homestay_price": homestayPrice,
      "homestay_roomqty": roomQty,
      "homestay_bedqty": bedQty,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Successfully updated homestay",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
