import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:waha/routes/Routes.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) =>
    {
      if (currentUser == null)
          Navigator.pushReplacementNamed(context, "/login")
      else
          Navigator.pushReplacementNamed(context, Routes.news)
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Loading(
        indicator: BallPulseIndicator(), size: 100.0, color: Colors.pink,),),
    );
  }
}