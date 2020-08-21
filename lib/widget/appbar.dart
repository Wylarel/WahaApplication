import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/routes/Routes.dart';
import 'package:waha/static/CurrentUserInfo.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final bool isMenu;

  CustomAppBar(this.name, this.isMenu);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(name),
      leading: !isMenu ? null : Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Ouvrir le menu',
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight);
}