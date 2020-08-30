import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waha/module/news/news_view.dart';
import 'package:waha/static/CurrentUserInfo.dart';
import 'package:waha/widget/load.dart';

import 'login.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Widget widgetToReturn = Center(child:Load(100));

  @override
  Widget build(BuildContext context) {
    return widgetToReturn;
  }

  @override
  initState() {
    super.initState();
    setWidget();
  }

  void setWidget() async {
    Widget newWidget = await getLandingPage();
    setState(() {
      widgetToReturn = newWidget;
    });
  }
}

Future<Widget> getLandingPage() async {
  return StreamBuilder<User>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData && (!snapshot.data.isAnonymous)) {
        print("User is connected");
        _updateCurrentUserInfo();
        return NewsPage();
      }
      print("User is not connected");
      return LoginPage();
    },
  );
}

void _updateCurrentUserInfo() {
  CurrentUserInfo.genFromUid(FirebaseAuth.instance.currentUser.uid);
}