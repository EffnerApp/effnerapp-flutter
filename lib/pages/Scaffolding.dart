/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 14:55.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../NavigationItems.dart';

class Scaffolding extends StatefulWidget {
  const Scaffolding({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _ScaffoldingState createState() => _ScaffoldingState();
}

class _ScaffoldingState extends State<Scaffolding> {
  int _currentIndex = 0;
  String _title = navItems[0].title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: navItems[_currentIndex].widget,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          items: navItems.map((e) => e.navBarItem).toList(),
        )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _title = navItems[index].title;
    });
  }
}
