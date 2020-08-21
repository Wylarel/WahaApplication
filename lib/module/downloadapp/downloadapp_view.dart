import 'package:flutter/material.dart';
import 'package:waha/routes/Routes.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DownloadAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Télécharger l'app", true),
        drawer: AppDrawer(),
        body:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Déjà disponnible:", style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,),
              ),
              FlatButton(
                onPressed: () {Navigator.pushReplacementNamed(context, Routes.downloadappdesktop);},
                color: Colors.redAccent,
                textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: FaIcon(FontAwesomeIcons.desktop, size: 24.0,),),
                      Text("Desktop", style: TextStyle(fontSize: 20),)
                    ],),
                ),),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Bientôt disponnible:", style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,),
              ),
              FlatButton(
                onPressed: () {},
                color: Colors.greenAccent,
                textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: FaIcon(FontAwesomeIcons.android, size: 24.0,),),
                      Text("Android", style: TextStyle(fontSize: 20),)
                    ],),
                ),),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
              ),
              FlatButton(
                onPressed: () {},
                color: Colors.black54,
                textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: FaIcon(FontAwesomeIcons.apple, size: 24.0),),
                      Text("iOS", style: TextStyle(fontSize: 20),)
                    ],),
                ),),
            ]
            ,),
        )
    );
  }

  _launchURL(String url) async {
    await launch(url);
  }
}