import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/appbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waha/widget/load.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  bool acceptRGPD = false;
  bool waiting = false;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'L\'email est invalide';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Le mot de passe doit contenir plus de 6 charactères';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Inscription", false),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Prénom*', hintText: "Jean"),
                        controller: firstNameInputController,
                        autofillHints: [
                          AutofillHints.givenName,
                          AutofillHints.name
                        ],
                        validator: (value) {
                          return value.length < 3
                              ? "Veuillez entrer un nom valide."
                              : null;
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Nom de famille*', hintText: "Dupont"),
                          controller: lastNameInputController,
                          autofillHints: [AutofillHints.familyName],
                          validator: (value) {
                            return value.length < 3
                                ? "Veuillez entrer un nom valide."
                                : null;
                          }),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email*',
                            hintText: "jean.dupont@gmail.com"),
                        controller: emailInputController,
                        autofillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Mot de passe*', hintText: "********"),
                        controller: pwdInputController,
                        autofillHints: [AutofillHints.newPassword],
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Confirmation du mot de passe*',
                            hintText: "********"),
                        controller: confirmPwdInputController,
                        autofillHints: [AutofillHints.newPassword],
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SwitchListTile(
                          activeColor: Theme
                              .of(context)
                              .primaryColor,
                          title: Text(
                              "J'accepte l'utilisation de mes données à des fins de personnalisation de l'experience utilisateur.",
                              style: TextStyle(fontSize: 12.0)),
                          value: acceptRGPD,
                          onChanged: (bool value) {
                            setState(() {
                              acceptRGPD = value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                        child: waiting ? Load(100) : RaisedButton(
                            child: Text("S'inscrire"),
                            color: Theme
                                .of(context)
                                .primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              registerUser();
                            }
                        ),
                      ),
                      Text("Vous avez déjà un compte ?"),
                      FlatButton(
                        child: Text("Connectez-vous ici !",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ))));
  }

  void registerUser() async {
    setState(() {
      waiting = true;
    });
    if (_registerFormKey.currentState.validate()) {
      if (pwdInputController.text != confirmPwdInputController.text) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: Text("Erreur"),
            content: Text(
                "Les mot de passe ne correspondent pas, veuillez réessayer."),
            actions: <Widget>[ FlatButton(child: Text("Ok"), onPressed: () {
              Navigator.of(context).pop();
            },)
            ],);
        });
        setState(() {
          waiting = false;
        });
        pwdInputController.clear();
        confirmPwdInputController.clear();
        return;
      }
      if (!acceptRGPD) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: Text("Erreur"),
            content: Text(
                "Vous devez accepter l'utilisation de vos données pour vous inscrire."),
            actions: <Widget>[ FlatButton(child: Text("Ok"), onPressed: () {
              Navigator.of(context).pop();
            },)
            ],);
        });
        setState(() {
          waiting = false;
        });
        return;
      }
      try {
        var authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInputController.text,password: pwdInputController.text);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          "uid": authResult.user.uid,
          "fname": firstNameInputController.text,
          "surname": lastNameInputController.text,
          "email": emailInputController.text,
        });
      }
      catch(platformExceptionToFirebaseAuthException) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: Text("Erreur"),
            content: Text(
                "Une erreur s'est produite, veuillez vérifier qu'un compte n'existe pas déjà avec cette adresse mail ou rééssayez plus tard."),
            actions: <Widget>[ FlatButton(child: Text("Ok"), onPressed: () {
              Navigator.of(context).pop();
            },)
            ],);
        });
        setState(() {
          waiting = false;
        });
        return;
      }
      firstNameInputController.clear();
      lastNameInputController.clear();
      emailInputController.clear();
      pwdInputController.clear();
      confirmPwdInputController.clear();
      _saveDeviceToken();
    }
  }
}

/// Get the token, save it to the database for current user
_saveDeviceToken() async {
  // Get the current user
  // String uid = uid;
  User user = FirebaseAuth.instance.currentUser;

  // Get the token for this device
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken = await _fcm.getToken();

  // Save it to Firestore
  if (fcmToken != null) {
    var tokens = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tokens')
        .doc(fcmToken);

    await tokens.set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}