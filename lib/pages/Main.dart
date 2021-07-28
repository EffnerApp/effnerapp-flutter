/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 28.07.21, 22:18.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:effnerapp/pages/fragments/Exams.dart';
import 'package:effnerapp/pages/fragments/Home.dart';
import 'package:effnerapp/pages/fragments/Settings.dart';
import 'package:effnerapp/pages/fragments/Substitution.dart';
import 'package:flutter/material.dart';

import '../NavigationItems.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  List<NavItem> navItems = <NavItem>[
    NavItem(Home(), 'Home', Icons.home),
    NavItem(Substitution(), 'Vertretungen', Icons.list),
    NavItem(Exams(), 'Schulaufgaben', Icons.school),
    NavItem(Settings(), 'Einstellungen', Icons.settings),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(navItems[_currentIndex].title)),
      body: navItems[_currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: navItems.asMap().map((key, value) => MapEntry(
          key,
          BottomNavigationBarItem(
            label: value.title,
            icon: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: _currentIndex == key
                    ? Colors.blue[600]
                    : Colors.white12,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(value.icon),
            ),
          ),
        )).values.toList(),
      ),
    );
  }
}
