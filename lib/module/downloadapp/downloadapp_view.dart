import 'package:flutter/material.dart';
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
                onPressed: () {Navigator.pushReplacementNamed(context, "/downloadappdesktop");},
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Transform.translate(offset: Offset(0,3),child: FaIcon(FontAwesomeIcons.desktop, size: 24.0,)),),
                      Text("Desktop", style: TextStyle(fontSize: 20),)
                    ],),
                ),),
              Padding(
                padding: const EdgeInsets.all(6.0),
              ),
              FlatButton(
                onPressed: () {_launchURL("https://play.google.com/store/apps/details?id=com.wylarel.waha");},
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Transform.translate(offset: Offset(0,3),child: FaIcon(FontAwesomeIcons.android, size: 24.0,),),),
                      Text("Android", style: TextStyle(fontSize: 20),)
                    ],),
                ),),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 24.0),
                child: Text("Bientôt disponnible:", style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,),
              ),
              FlatButton(
                onPressed: () {},
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Transform.translate(offset: Offset(0,1),child: FaIcon(FontAwesomeIcons.apple, size: 24.0),),),
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