import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waha/module/auth/login.dart';
import 'package:waha/module/bugreport/bugreport_view.dart';
import 'package:waha/module/calculator/calculator_view.dart';
import 'package:waha/module/cloudstorage/upload_download_view.dart';
import 'package:waha/module/downloadapp/downloadapp_view.dart';
import 'package:waha/module/food/food_view.dart';
import 'package:waha/module/news/news_view.dart';
import 'package:waha/module/notes/notes_view.dart';
import 'package:waha/module/periodictable/periodictable_view.dart';
import 'package:waha/module/schedule/schedule_view.dart';
import 'package:waha/static/CurrentUserInfo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:page_transition/page_transition.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
              icon: Icons.list,
              text: 'Nouveautés',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: NewsPage()))),
          _createDrawerItem(
              icon: FontAwesomeIcons.calendarAlt,
              text: 'Horaire',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: SchedulePage()))),
          _createDrawerItem(
              icon: Icons.book,
              text: 'Notes',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: NotesPage()))),
          Divider(),
          _createDrawerItem(
              icon: FontAwesomeIcons.atom,
              text: 'Tableau périodique',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: PeriodicTablePage()))),
          _createDrawerItem(
              icon: FontAwesomeIcons.calculator,
              text: 'Calculatrice',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CalculatorPage()))),
          Divider(),
          _createDrawerItem(
              icon: Icons.file_upload,
              text: 'Envoyer un fichier',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: UploadPage()))),
          _createDrawerItem(
              icon: Icons.file_download,
              text: 'Recevoir un fichier',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DownloadPage(isGuest: false)))),
          Divider(),
          _createDrawerItem(
              icon: Icons.fastfood,
              text: 'Commander un repas',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: FoodPage()))),
          _createDrawerItem(
              icon: Icons.bug_report,
              text: 'Signaler un bug',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: BugreportPage()))),
          Divider(),
          !kIsWeb ? Container() : _createDrawerItem(
              icon: Icons.cloud_download,
              text: 'Télécharger l\'app',
              onTap: () =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DownloadAppPage()))),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Se déconnecter',
              onTap: () => FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: LoginPage())))
                  .catchError((err) => print(err))),
          SwitchListTile(
            title: Text("Theme sombre"),
            onChanged: (value) {
              setState(() {darkTheme = value;});
              AdaptiveTheme.of(context).toggleThemeMode();
              },
            value: darkTheme,
            activeColor: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration( color: Theme.of(context).primaryColor),
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
          FaIcon(icon),
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
  Widget build(BuildContext context) {
    return Text("${CurrentUserInfo.displayName}",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500
        )
    );
  }

  void initState() {
    super.initState();
  }
}