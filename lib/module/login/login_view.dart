import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginInput("Email", "Entez votre email"),
        LoginInput("Mot de passe", "Entrez votre mot de passe"),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: FlatButton(
            color: Colors.pink,
            textColor: Colors.white,
            child: Text("Se connecter"),
            onPressed: () => print("lala"),
          ),
        ),
      ],
    );
  }
}

class LoginInput extends StatelessWidget {
  final String label;
  final String hint;

  const LoginInput(this.label, this.hint);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
