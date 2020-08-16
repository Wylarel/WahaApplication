import 'package:firebase_auth/firebase_auth.dart';
import 'package:waha/module/login/login_view.dart';
import 'package:waha/routes/Routes.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';
import 'module/bugreport/bugreport_view.dart';
import 'module/food/food_view.dart';
import 'module/news/news_view.dart';
import 'module/notes/notes_view.dart';
import 'module/schedule/schedule_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waha',
      theme: new ThemeData(
          primarySwatch: Colors.pink
      ),
      home: HomePage(),
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
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUserConnected = false;

  @override
  Widget build(BuildContext context) {
    return isUserConnected ? NewsPage() : LoginPage();
  }
}

