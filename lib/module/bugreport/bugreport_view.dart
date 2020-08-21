import 'package:flutter/material.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BugreportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Signaler un bug", true),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Pour signaler un bug ou suggérer un changement/ajout, le mieux est d'ouvrir un ticket sur le dépôt Github de l'application:", textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
              ),
              _createDrawerItem(icon: FontAwesomeIcons.github, text: "Dépôt Github", onTap: () => _launchURL("https://github.com/WahaDevs/WahaApplication/issues/new")),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom:8.0, top: 26.0),
                child: Text("Alternativement, contactez les développeurs:", textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
              ),
              _createDrawerItem(icon: FontAwesomeIcons.facebookMessenger, text: "@wylarel", onTap: () => _launchURL("https://www.messenger.com/t/wylarel")),
              _createDrawerItem(icon: FontAwesomeIcons.instagram, text: "@wylarel", onTap: () => _launchURL("https://www.instagram.com/wylarel")),
              _createDrawerItem(icon: Icons.email, text: "contact@wylarel.com", onTap: () => _launchURL("mailto:contact@wylarel.com?subject=Signaler%20un%20bug%20sur%20l'app%20Waha")),
            ],
          ),
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