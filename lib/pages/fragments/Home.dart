/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 20:40.
 * Copyright (c) 2021 EffnerApp.
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:effnerapp_flutter/utils/json/MOTD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<MOTD> motd;

  @override
  void initState() {
    super.initState();
    motd = fetchMotd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<MOTD>(builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new Text(snapshot.data!.motd, style: TextStyle(fontSize: 25, color: Colors.blue));
                  } else if (snapshot.hasError) {
                    return new Text(snapshot.error!.toString());
                  }

                  return new CircularProgressIndicator();
                }, future: motd)
              ],
            )
          ]),

    ));
  }
}

Future<MOTD> fetchMotd() async {
  final storage = new FlutterSecureStorage();
  final credentials = await storage.read(key: "credentials");
  final String time = DateTime.now().millisecondsSinceEpoch.toString();

  final response = await http.get(Uri.parse('https://api.effner.app/data/motd'),
      headers: <String, String>{
        'Authorization': 'Basic ' +
            sha512.convert(utf8.encode(credentials! + ":" + time)).toString(),
        'X-Time': time
      });

  if (response.statusCode == 200) {
    return MOTD.fromJson(jsonDecode(response.body));
  } else {
    throw new Exception("Could not retrieve motd.");
  }
}
