import 'package:flutter/material.dart';
import 'package:waha/routes/Routes.dart';
import 'module/bugreport/bugreport_view.dart';
import 'module/food/food_view.dart';
import 'module/news/news_view.dart';
import 'module/notes/notes_view.dart';
import 'module/schedule/schedule_view.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';


void main() => runApp(WahaApp());

class WahaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}