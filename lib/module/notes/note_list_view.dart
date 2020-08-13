import 'package:flutter/material.dart';
import 'package:waha/widget/drawer.dart';


class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
          backgroundColor: Colors.pink,
        ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("Notes")
        )
    );
  }

}