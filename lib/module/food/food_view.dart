import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/module/food/restaurant_list.dart';
import 'package:waha/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waha/widget/load.dart';


Restaurant selectedRestaurant;


class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Commander un repas"),
          backgroundColor: getPink(),
        ),
        drawer: AppDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SmsCommandWidget(),
            ),
            Expanded(child: ExpansionTileSample(),),
          ],
        ),
    );
  }
}

class SmsCommandWidget extends StatefulWidget {
  @override
  _SmsCommandWidgetState createState() => _SmsCommandWidgetState();
}

class _SmsCommandWidgetState extends State<SmsCommandWidget> {
  final GlobalKey<FormState> _commandFormKey = GlobalKey<FormState>();
  TextEditingController commandInputController;
  TextEditingController hourInputController;

  @override
  initState() {
    commandInputController = new TextEditingController();
    hourInputController = new TextEditingController();
    super.initState();
  }

  String commandValidator(String value) {
    if (value.length < 3) {
      return 'Veuillez entrer une commande valide';
    } else {
      return null;
    }
  }
  String hourValidator(String value) {
    if (value.length <= 0) {
      return 'Veuillez entrer une heure';
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Form(
      key: _commandFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton<Restaurant>(
            isExpanded: true,
            hint:  Text("Sandwicherie"),
            value: selectedRestaurant,
            onChanged: (Restaurant Value) {
              setState(() {
                selectedRestaurant = Value;
              });
            },
            items: smsRestaurants.map((Restaurant restaurant) {
              return  DropdownMenuItem<Restaurant>(
                value: restaurant,
                child: Row(
                  children: <Widget>[
                    restaurant.icon,
                    SizedBox(width: 10,),
                    Text(
                      restaurant.name,
                      style:  TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Commande*',
                hintText: "Sandwich thon-mayo avec crudité"),
            controller: commandInputController,
            keyboardType: TextInputType.text,
            validator: commandValidator,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Heure*', hintText: "12h00"),
            controller: hourInputController,
            keyboardType: TextInputType.datetime,
            validator: hourValidator,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
            child: RaisedButton(
              child: Text("Valider"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if (_commandFormKey.currentState.validate()) {
                  print("Commande Validée");
                  _sendSms(selectedRestaurant.phone, commandInputController.text, hourInputController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _sendSms(String dest, String command, String hour) async {
  String message = "[Commande Automatique]\n\nBonjour,\n\nj'aimerais commander un(e) $command pour aujourd'hui à $hour.\n\nMerci à vous et bonne journée !";
  await launch("sms:$dest?body=$message");
}

class Restaurant {
  const Restaurant(this.name,this.icon, this.phone);
  final String name;
  final FaIcon icon;
  final String phone;
}

List<Restaurant> smsRestaurants = <Restaurant>[
  const Restaurant('Hmmm', FaIcon(FontAwesomeIcons.breadSlice), "+32499839073"),
];