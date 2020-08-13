import 'package:flutter/material.dart';
import 'package:waha/routes/Routes.dart';
import 'module/bugreport/bugreport_view.dart';
import 'module/food/food_view.dart';
import 'module/news/news_view.dart';
import 'module/notes/note_list_view.dart';
import 'module/schedule/schedule_view.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Waha',
      theme: new ThemeData(
        primarySwatch: Colors.pink
      ),
      home: NewsPage(),
      routes:  {
        Routes.news: (context) => NewsPage(),
        Routes.schedule: (context) => SchedulePage(),
        Routes.notes: (context) => NotesPage(),
        Routes.food: (context) => FoodPage(),
        Routes.bugreport: (context) => BugreportPage(),
      },
    )
  );
}
