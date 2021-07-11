import 'package:effnerapp_flutter/pages/Home.dart';
import 'package:effnerapp_flutter/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EffnerApp',

      // Light Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            elevation: 0),
        brightness: Brightness.light,
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.white),
        dividerColor: Colors.white54,
        scaffoldBackgroundColor: Colors.white,
      ),

      // Dark Theme
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Colors.black,
          textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          elevation: 0,
        ),
        brightness: Brightness.dark,
        accentColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black12,
        scaffoldBackgroundColor: Colors.black,
      ),

      themeMode: ThemeMode.system,
      initialRoute: "/home",
      routes: {
        "/": (context) => MainPage(),
        HomePage.routeName: (context) => HomePage(),
        Login.routeName: (context) => Login(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _storage = new FlutterSecureStorage();
    return FutureBuilder<String?>(
        future: _storage.read(key: "token"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return Login();
          }
        });
  }
}

