/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 15:31.
 * Copyright (c) 2021 EffnerApp.
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:effnerapp/components/DropdownMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FormText _id = new FormText('ID');
  final FormText _password = new FormText('Passwort', obscureText: true);

  late DropdownMenu _dropdownMenu;
  late Future<Classes> futureList;

  @override
  void initState() {
    super.initState();
    futureList = fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EffnerApp'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _id.getField,
                        SizedBox(height: 20),
                        _password.getField,
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Klasse', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 10),
                              FutureBuilder<Classes>(
                                future: futureList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    _dropdownMenu = DropdownMenu(
                                        values: snapshot.data!.classes.cast<
                                            String>()); // .cast<String>(); to cast a List<dynamic> to a List<String>
                                    return _dropdownMenu;
                                  } else if (snapshot.hasError) {
                                    _dropdownMenu =
                                        DropdownMenu(values: ['error']);
                                    return _dropdownMenu;
                                  }

                                  return CircularProgressIndicator();
                                },
                              )
                            ]),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: login,
                            child: Text('Anmelden'.toUpperCase())),
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }

  void login() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      print('form is valid ' +
          _id.value +
          ' ' +
          _password.value +
          ' ' +
          _dropdownMenu.getDropDownValue);

      final String credentials = _id.value + ':' + _password.value;
      final String time = DateTime.now().millisecondsSinceEpoch.toString();

      final response = await http.post(
          Uri.parse('https://api.effner.app/auth/login'),
          headers: <String, String>{
            'Authorization': 'Basic ' +
                sha512
                    .convert(utf8.encode(credentials + ':' + time))
                    .toString(),
            'X-Time': time
          });

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route route) => false);
        final _storage = new FlutterSecureStorage();
        _storage.write(key: 'credentials', value: credentials);
        _storage.write(key: 'class', value: _dropdownMenu.getDropDownValue);
      } else {
        print(response.statusCode.toString() + ' ' + response.body);
      }
    } else {
      print('form invalid');
    }
  }
}

class FormText {
  final text;
  final bool obscureText;

  String value = '';

  String get getValue => value;

  TextFormField get getField => TextFormField(
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Bitte alle Felder füllen';
        }
        return null;
      },
      onSaved: (newValue) => value = newValue!,
      decoration: InputDecoration(
          labelText: text,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange))));

  FormText(this.text, {this.obscureText = false});
}

Future<Classes> fetchClasses() async {
  final response =
  await http.get(Uri.parse('https://api.effner.app/data/classes'));

  if (response.statusCode == 200) {
    return Classes(jsonDecode(response.body));
  } else {
    throw Exception('error ' + response.statusCode.toString());
  }
}

class Classes {
  final List<dynamic> classes;

  Classes(this.classes);
}
