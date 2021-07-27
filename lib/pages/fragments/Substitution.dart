/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 14:58.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Substitution extends StatefulWidget {
  const Substitution({Key? key}) : super(key: key);

  @override
  _SubstitutionState createState() => _SubstitutionState();
}

class _SubstitutionState extends State<Substitution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Coole Vertretungen")),
    );
  }
}
