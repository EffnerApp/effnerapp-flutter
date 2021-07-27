/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 14:58.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exams extends StatefulWidget {
  const Exams({Key? key}) : super(key: key);

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Uncoole Tests")),
    );
  }
}
