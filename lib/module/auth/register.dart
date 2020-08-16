import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Projects/Flutter/WahaApplication/lib/module/auth/home.dart';
import 'package:waha/routes/Routes.dart';

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
    if (value.length < 8) {
      return 'Le mot de passe doit contenir plus de 8 charactères';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inscription"),
        ),
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
                    validator: (value) {
                      return value.length < 3 ? "Veuillez entrer un nom valide.": null;
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nom de famille*', hintText: "Dupont"),
                      controller: lastNameInputController,
                      validator: (value) {
                        return value.length < 3 ? "Veuillez entrer un nom valide.": null;
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: "jean.dupont@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Mot de passe*', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirmation du mot de passe*', hintText: "********"),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                    child: RaisedButton(
                      child: Text("S'inscrire"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_registerFormKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((authResult) => Firestore.instance
                                    .collection("users")
                                    .document(authResult.user.uid)
                                    .setData({
                                      "uid": authResult.user.uid,
                                      "fname": firstNameInputController.text,
                                      "surname": lastNameInputController.text,
                                      "email": emailInputController.text,
                                    })
                                    .then((result) => {
                                          Navigator.pushReplacementNamed(context, Routes.news),
                                          firstNameInputController.clear(),
                                          lastNameInputController.clear(),
                                          emailInputController.clear(),
                                          pwdInputController.clear(),
                                          confirmPwdInputController.clear()
                                        })
                                    .catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Erreur"),
                                    content: Text("Les mot de passe ne correspondent pas, veuillez réessayer."),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ),
                  Text("Vous avez déjà un compte ?"),
                  FlatButton(
                    child: Text("Connectez-vous ici !"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}
