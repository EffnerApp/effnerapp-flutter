/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 20:40.
 * Copyright (c) 2021 EffnerApp.
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:effnerapp/utils/json/MOTD.dart';
import 'package:effnerapp/config/styles.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        _sliver1(screenHeight),
      ],
    ));
  }

  // Container(
  // child: Column(
  // children: [
  // SizedBox(height: 20),
  // Row(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // FutureBuilder<MOTD>(builder: (context, snapshot) {
  // if (snapshot.hasData) {
  // return new Text(snapshot.data!.motd, style: TextStyle(fontSize: 25, color: Colors.blue));
  // } else if (snapshot.hasError) {
  // return new Text(snapshot.error!.toString());
  // }
  //
  // return new CircularProgressIndicator();
  // }, future: motd)
  // ],
  // )
  // ]),
  //
  // ));

  SliverToBoxAdapter _sliver1(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF40C9FF), Color(0xFFE81CFF)],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'EffnerApp',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<MOTD>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.motd,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error!.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return Text(
                        'Loading ...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                    future: motd),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Mega spannender Infotext oder aktuelle infos idk?',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {},
                      // TODO: navigate to timetable screen
                      color: Color(0xFFF36A6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.today,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Stundenplan',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {},
                      // TODO: navigate to mvv screen
                      color: Color(0xFF86EC82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.train,
                        color: Colors.white,
                      ),
                      label: Text(
                        'MVV',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<MOTD> fetchMotd() async {
  final storage = new FlutterSecureStorage();
  final credentials = await storage.read(key: 'credentials');
  final String time = DateTime.now().millisecondsSinceEpoch.toString();

  final response = await http.get(Uri.parse('https://api.effner.app/data/motd'),
      headers: <String, String>{
        'Authorization': 'Basic ' +
            sha512.convert(utf8.encode(credentials! + ':' + time)).toString(),
        'X-Time': time
      });

  if (response.statusCode == 200) {
    return MOTD.fromJson(jsonDecode(response.body));
  } else {
    throw new Exception('Could not retrieve motd.');
  }
}
