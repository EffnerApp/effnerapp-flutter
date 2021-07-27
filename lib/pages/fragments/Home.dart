/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 14:58.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Krasse Home seite")),
    );
  }
}
