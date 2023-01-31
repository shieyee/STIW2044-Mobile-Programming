import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/shared/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BuyerHomestayDetails extends StatefulWidget {
  final Homestay homestay;
  final User user;
  final User seller;
  const BuyerHomestayDetails(
      {super.key,
      required this.homestay,
      required this.user,
      required this.seller});

  @override
  State<BuyerHomestayDetails> createState() => _BuyerHomestayDetailsState();
}

class _BuyerHomestayDetailsState extends State<BuyerHomestayDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Homestay Details")),
      body: Column(children: [
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
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.homestay.homestayName.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: screenWidth - 16,
          child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.none, width: 5),
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(230),
              },
              children: [
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Description',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.homestay.homestayDesc.toString(),
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Price/Night',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RM ${widget.homestay.homestayPrice}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Rooms',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayRoomqty}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Beds',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayBedqty}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('State',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayState}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Locality',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayLocal}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Owner',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.seller.name}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
              ]),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Card(
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        iconSize: 32,
                        onPressed: _makePhoneCall,
                        icon: const Icon(Icons.call)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _makeSmS,
                        icon: const Icon(Icons.message)),
                    IconButton(
                        iconSize: 32,
                        onPressed: openwhatsapp,
                        icon: const Icon(Icons.whatsapp)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onRoute,
                        icon: const Icon(Icons.map)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onShowMap,
                        icon: const Icon(Icons.maps_home_work))
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
  Future<void> _makePhoneCall() async {
     if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.seller.contactno,
    );
    await launchUrl(launchUri);
  }

Future<void> _makeSmS() async {
  if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.seller.contactno,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.homestay.homestayLat.toString() +
            "," +
            widget.homestay.homestayLng.toString() +
            "20z");
    await launchUrl(launchUri);
  }

  openwhatsapp() async {
    var whatsapp = widget.seller.contactno;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    }
  }
int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

void _onShowMap() {
  if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    double lat = double.parse(widget.homestay.homestayLat.toString());
    double lng = double.parse(widget.homestay.homestayLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: Container(
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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
}
