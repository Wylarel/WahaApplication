import 'package:flutter/material.dart';
import 'package:waha/widget/drawer.dart';


class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nouveautés"),
          backgroundColor: Colors.pink,
        ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("Nouveautés")
        )
    );
  }

}