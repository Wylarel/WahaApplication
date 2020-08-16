import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waha/routes/Routes.dart';
import 'module/bugreport/bugreport_view.dart';
import 'module/food/food_view.dart';
import 'module/news/news_view.dart';
import 'module/notes/notes_view.dart';
import 'module/schedule/schedule_view.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser _user;
  String _error = '';

  @override
  void initState() {
    super.initState();
    if (_user == null)
      _onLoginButton();
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return MaterialApp(
        title: 'Waha',
        theme: new ThemeData(
            primarySwatch: Colors.pink
        ),
        home: NewsPage(),
        routes:
        {
          Routes.news: (context) => NewsPage(),
          Routes.schedule: (context) => SchedulePage(),
          Routes.notes: (context) => NotesPage(),
          Routes.editnote: (context) => EditNotePage(),
          Routes.food: (context) => FoodPage(),
          Routes.bugreport: (context) => BugreportPage(),
        },
      );
    }
    else {
      return MaterialApp(
        title: 'Waha',
        theme: new ThemeData(
            primarySwatch: Colors.pink
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Connexion"),
            backgroundColor: Colors.pink,
          ),
          body: Center(
            child: RaisedButton(
              child: Text('Se connecter'),
              onPressed: _onLoginButton,
            ),
          ),
        ),
      );
    }
  }

  void _onLoginButton() {
    if (_user == null) {
      FirebaseAuthUi.instance().launchAuth([
        AuthProvider.email(),
      ]).then((firebaseUser) {
        setState(() {
          _error = "";
          _user = firebaseUser;
        });
      }).catchError((error) {
        if (error is PlatformException) {
          setState(() {
            if (error.code == FirebaseAuthUi.kUserCancelledError) {
              _error = "User cancelled login";
            } else {
              _error = error.message ?? "Unknown error!";
            }
          });
        }
      });
    } else {
      _logout();
      print("User logged out");
    }
  }

  void _logout() async {
    await FirebaseAuthUi.instance().logout();
    setState(() {
      _user = null;
    });
  }
}