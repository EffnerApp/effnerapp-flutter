import 'package:effnerapp_flutter/components/DropdownMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FormText _id = new FormText("ID");
  final FormText _password = new FormText("Passwort", obscureText: true);
  DropdownMenu _dropdownMenu = DropdownMenu(values: classes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EffnerApp"),
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
                              Text("Klasse", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 10),
                              _dropdownMenu
                            ]),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: login,
                            child: Text("Anmelden".toUpperCase())),
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }

  void login() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      print('form is valid ' +
          _id.value +
          " " +
          _password.value +
          " " +
          _dropdownMenu.getDropDownValue);
    } else {
      print('form invalid');
    }
  }
}

class FormText {
  final text;
  final bool obscureText;

  String value = "";

  String get getValue => value;

  TextFormField get getField => TextFormField(
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bitte alle Felder füllen";
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

List<String> classes = <String>[
  "5A",
  "5B",
  "5C",
  "5D",
  "5E",
  "5H",
  "5I",
  "6A",
  "6B",
  "6C",
  "6D",
  "6E",
  "6H",
  "6I",
  "7A",
  "7B",
  "7C",
  "7D",
  "7E",
  "7F",
  "7G",
  "7H",
  "7I",
  "8A",
  "8B",
  "8C",
  "8D",
  "8E",
  "8F",
  "9A",
  "9B",
  "9C",
  "9D",
  "9E",
  "10A",
  "10B",
  "10C",
  "10D",
  "10E",
  "10F"
];
