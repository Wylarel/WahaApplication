import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';


class DownloadAppDesktopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Télécharger l'app Desktop", true),
        drawer: AppDrawer(),
        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(color: Colors.green,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.chrome, color: Colors.white,),
                          ),
                          Text("Chrome", style: TextStyle(color: Colors.white),)
                        ],))),
              Padding(child: Text('1. Ouvrez le menu déroulant en haut à droite', textAlign: TextAlign.center,),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('2. Navigez à Plus d\'outils > Créer un raccourci', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('3. Activez "Ouvrir dans une nouvelle fenêtre" et cliquez sur "Créer"', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('4. Vous avez désormais accès à l\'app, vous pouvez par exemple l\'attacher à la bare de tâche ou la mettre sur le bureau.', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Divider(),
              Card(color: Colors.blue,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.edge, color: Colors.white,),
                          ),
                          Text("Edge", style: TextStyle(color: Colors.white),)
                        ],))),
              Padding(child: Text('1. Ouvrez le menu déroulant en haut à droite', textAlign: TextAlign.center,),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('2. Navigez à Applications > Installer ce site en tant qu\'application', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('3. Vous avez désormais accès à l\'app, vous pouvez par exemple l\'attacher à la bare de tâche ou la mettre sur le bureau.', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Divider(),
              Card(color: Colors.orange,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.firefoxBrowser, color: Colors.white,),
                          ),
                          Text("Firefox", style: TextStyle(color: Colors.white),)
                        ],))),
              Padding(child: Text('1. Ouvrez "about:config"', textAlign: TextAlign.center,),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('2. Définissez "browser.ssb.enabled" à true', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('3. Recommencez Firefox et ouvrez à nouveau ce site', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('4. Cliquez sur les trois points dans la barre d\'URL', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('5. Cliquez sur "Site Specific Browser"', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
              Padding(child: Text('6. Vous avez désormais accès à l\'app, vous pouvez par exemple l\'attacher à la bare de tâche ou la mettre sur le bureau.', textAlign: TextAlign.center),padding: const EdgeInsets.all(8.0),),
            ],
          ),
        )
    );
  }

  _launchURL(String url) async {
    await launch(url);
  }
}