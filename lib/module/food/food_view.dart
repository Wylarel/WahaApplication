import 'package:flutter/material.dart';
import 'package:waha/widget/drawer.dart';


class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Commander un repas"),
          backgroundColor: Colors.pink,
        ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("Commander un repas")
        )
    );
  }

}