import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../NavigationItems.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("lol")),
    );
  }
}
