import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movie Search',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Search Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String info = "";
  String year = "", title = "", genre = "";
  var poster =
      'https://i.pinimg.com/originals/f5/05/24/f50524ee5f161f437400aaf215c9e12f.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 6.0,
                ),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search for a movie...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'Searching the movie...',
                                        style: TextStyle(),
                                      ),
                                      content: const Text(
                                        "Are you sure?",
                                        style: TextStyle(),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _getMovie(_searchController.text);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]));
                        },
                        child: const Text('Search')),
                    ElevatedButton(
                        onPressed: () {
                          _searchController.text = '';
                        },
                        child: const Text('Clear')),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                
                Image.network(poster),

                const SizedBox(
                  height: 10.0,
                ),
                Text(info.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getMovie(title) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    var url = Uri.parse('http://www.omdbapi.com/?t=$title&apikey=b1b91032');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200 && _searchController.text != "") {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        title = parsedJson['Title'];
        year = parsedJson['Year'];
        genre = parsedJson['Genre'];
        info = 'Title: $title \nYear: $year \nGenre: $genre';
        poster = parsedJson['Poster'];
      });
    } else {
      setState(() {
        poster =
            'https://www.nanyanglearning.com/common/images/no-records-found.jpg';
        info = 'No Records Found';
      });
    }
    progressDialog.dismiss();
  }
}
