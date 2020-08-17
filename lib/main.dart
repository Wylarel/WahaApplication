import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:waha/routes/Routes.dart';
import 'data/colors.dart';
import 'module/auth/register.dart';
import 'module/auth/splash.dart';
import 'module/auth/login.dart';
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
        theme: ThemeData(
          primarySwatch: getPink(),
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          Routes.splash: (context) => SplashPage(),
          Routes.login: (context) => LoginPage(),
          Routes.register: (context) => RegisterPage(),
          Routes.news: (context) => NewsPage(),
          Routes.schedule: (context) => SchedulePage(),
          Routes.notes: (context) => NotesPage(),
          Routes.editnote: (context) => EditNotePage(),
          Routes.food: (context) => FoodPage(),
          Routes.bugreport: (context) => BugreportPage(),
        });
  }
}