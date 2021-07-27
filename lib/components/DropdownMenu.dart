/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 15:31.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  final List<String> values;

  String get getDropDownValue => _dropdownValue;

  const DropdownMenu({Key? key, required this.values}) : super(key: key);

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

String _dropdownValue = "";

class _DropdownMenuState extends State<DropdownMenu> {

  @override
  void initState() {
    _dropdownValue = widget.values.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dropDownItems = widget.values
        .map<DropdownMenuItem<String>>((String value) =>
        DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    return DropdownButton<String>(
      value: _dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          _dropdownValue = newValue!;
        });
      },
      items: _dropDownItems,
    );
  }
}
