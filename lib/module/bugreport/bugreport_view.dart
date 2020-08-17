import 'package:flutter/material.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BugreportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signaler un bug"),
          backgroundColor: getPink(),
        ),
        drawer: AppDrawer(),
        body: ListView(
          children: <Widget>[
            _createDrawerItem(icon: FontAwesomeIcons.facebookMessenger, text: "@wylarel", onTap: () => _launchURL("https://www.messenger.com/t/wylarel")),
            _createDrawerItem(icon: FontAwesomeIcons.instagram, text: "@wylarel", onTap: () => _launchURL("https://www.instagram.com/wylarel")),
            _createDrawerItem(icon: Icons.email, text: "contact@wylarel.com", onTap: () => _launchURL("mailto:contact@wylarel.com?subject=Signaler%20un%20bug%20sur%20l'app%20Waha")),
          ]
        )
    );
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

  _launchURL(String url) async {
    await launch(url);
  }
}