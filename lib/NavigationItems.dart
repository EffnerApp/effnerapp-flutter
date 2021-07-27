/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 14:58.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:effnerapp_flutter/pages/fragments/Exams.dart';
import 'package:effnerapp_flutter/pages/fragments/Home.dart';
import 'package:effnerapp_flutter/pages/fragments/Settings.dart';
import 'package:effnerapp_flutter/pages/fragments/Substitution.dart';
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
  NavItem(Home(), "Home", Icons.home),
  NavItem(Substitution(), "Vertretungen", Icons.list),
  NavItem(Exams(), "Schulaufgaben", Icons.school),
  NavItem(Settings(), "Einstellungen", Icons.settings),
];
