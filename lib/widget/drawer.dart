import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waha/main.dart';
import 'package:waha/routes/Routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.list,
              text: 'Nouveautés',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.news)),
          _createDrawerItem(
              icon: Icons.calendar_today,
              text: 'Horaire',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.schedule)),
          _createDrawerItem(
              icon: Icons.book,
              text: 'Notes',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.notes)),
          Divider(),
          _createDrawerItem(
              icon: Icons.fastfood,
              text: 'Commander un repas',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.food)),
          _createDrawerItem(
              icon: Icons.bug_report,
              text: 'Signaler un bug',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.bugreport)),
          Divider(),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Se déconnecter',
              onTap: () => FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                  Navigator.pushReplacementNamed(context, Routes.login))
                  .catchError((err) => print(err))),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration( color: Colors.pink,),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: UserDisplayNameText()
          ),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class UserDisplayNameText extends StatefulWidget {
  @override
  _UserDisplayNameTextState createState() => _UserDisplayNameTextState();
}

class _UserDisplayNameTextState extends State<UserDisplayNameText> {
  String displayName = "";
  Widget build(BuildContext context) {
    return Text(displayName != null ? displayName : "Invité",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500
        )
    );
  }

  void initState() {
    super.initState();
    setDisplayName();
  }

  void setDisplayName() async {
    FirebaseAuth.instance.currentUser().then((user) =>
      Firestore.instance.document('users/' + user.uid).get().then((documentSnapshot) => setState(() {displayName = '${documentSnapshot.data["fname"]} ${documentSnapshot.data["surname"]}';}))
    );
  }
}