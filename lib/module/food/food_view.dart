import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Commander un repas"),
          backgroundColor: Colors.pink,
        ),
        drawer: AppDrawer(),
        body: ListView(
          children: <Widget>[
            _createDrawerFoodItem(faicon: FontAwesomeIcons.breadSlice, text: "La Pause Gourmande", link: "tel:042220722"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.breadSlice, text: "Mmmhhh", link: "sms:0499839073"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.breadSlice, text: "Au Croc", link: "tel:042773201"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.breadSlice, text: "Le Bi'Stronome", link: "tel:042502825"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.breadSlice, text: "Point chaud", enabled: false),
            Divider(),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.fish, text: "Sushi Fuji", link: "tel:043794576"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.fish, text: "Sushi King", link: "tel:042782268"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.fish, text: "Sushi Maison", link: "https://sushimaison.shop/menu/"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.fish, text: "Sushi Délice", link: "http://www.sushidelice4000.be/product.php"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.fish, text: "Yukinii", link: "tel:042502652"),
            Divider(),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "Pizzico", link: "tel:043607875"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "Little Italy Pizzeria", link: "tel:042505042"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "La Toscana", link: "tel:0465184707"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "Pizzeria Pugliese", link: "tel:042221479"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "Loria Calogero", link: "tel:042230592"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.pizzaSlice, text: "Jackson's original pizza", link: "tel:043713244"),
            Divider(),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.hamburger, text: "The Huggy's Bar", link: "https://huggysbar.com/fr/reservation/"),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.hamburger, text: "Huggy's Dog", enabled: false),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.hamburger, text: "Wokman", enabled: false),
            _createDrawerFoodItem(faicon: FontAwesomeIcons.hamburger, text: "Ô Tacos", enabled: false),
          ]
        )
    );
  }

  Widget _createDrawerFoodItem(
      {IconData icon, IconData faicon, String text, bool enabled = true, String link}) {
    return Opacity(
      opacity: enabled ? 1.0 : .5,
      child: ListTile(
        title: Row(
          children: <Widget>[
              if(icon != null)
                Icon(icon),
              if(faicon != null)
                FaIcon(faicon),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(text),
              )
          ],
        ),
      onTap: enabled ? () => _launchURL(link) : () => Fluttertoast.showToast(
          msg: "Vous ne pouvez pas commander pour cet endroit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
        ),
      )
    );
  }

  _launchURL(String url) async {
    await launch(url);
  }
}