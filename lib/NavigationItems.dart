import 'package:effnerapp_flutter/pages/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavItem {
  final Widget widget;
  final String title;
  final IconData icon;

  BottomNavigationBarItem get navBarItem =>
      new BottomNavigationBarItem(icon: Icon(icon), title: Text(title));

  NavItem(this.widget, this.title, this.icon);
}

List<NavItem> navItems = <NavItem>[
  NavItem(Dashboard(), "Home", Icons.home),
  NavItem(Dashboard(), "Vertretungen", Icons.list),
  NavItem(Dashboard(), "Schulaufgaben", Icons.school),
  NavItem(Dashboard(), "Einstellungen", Icons.settings),
];
