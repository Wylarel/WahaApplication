import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Projects/Flutter/WahaApplication/lib/module/auth/home.dart';
import 'package:waha/routes/Routes.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email*',
                    hintText: "jean.dupont@gmail.com"),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: RaisedButton(
                  child: Text("Se connecter"),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_loginFormKey.currentState.validate()) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: emailInputController.text,
                          password: pwdInputController.text)
                          .then((authResult) =>
                          Firestore.instance
                              .collection("users")
                              .document(authResult.user.uid)
                              .get()
                              .then((DocumentSnapshot result) =>
                              Navigator.pushReplacementNamed(context, Routes.news))
                          .catchError((err) => print(err))
                      );
                    }
                  },
                ),
              ),
              Column(
                children: [
                  Text("Vous n'avez pas encore de compte ?"),
                  FlatButton(
                    child: Text("Inscrivez-vous ici!"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}