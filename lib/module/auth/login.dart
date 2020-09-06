import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:waha/module/cloudstorage/upload_download_view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:waha/widget/load.dart';

bool isConnected = false;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool landingWait = false;
  bool waitingForValidation = false;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
    landingWaitUpdate();
  }

  void landingWaitUpdate() async {
    print("Landing; checking if user is connected...");
    setState(() {
      landingWait = true;
    });
    await Future.delayed(const Duration(seconds: 2), () => "");
    if(!isConnected) {
      setState(() {
        landingWait = false;
      });
      print("User is not connected");
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'L\'email n\'est pas valide';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Le mot de passe doit contenir plus de 6 caractères';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: landingWait ? Center(child: Load(100)) : Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email*',
                    hintText: "Entrez votre email"),
                controller: emailInputController,
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Mot de passe*', hintText: "Entre votre mot de passe"),
                controller: pwdInputController,
                autofillHints: [AutofillHints.password],
                obscureText: true,
                validator: pwdValidator,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: waitingForValidation ? Load(100) : RaisedButton(
                  child: Text("Se connecter"),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    loginUser();
                  },
                ),
              ),
              Column(
                children: [
                  Text("Vous n'avez pas encore de compte ?"),
                  Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: [
                        FlatButton(
                          color: Theme.of(context).cardColor,
                          child: Text("Télécharger un fichier en invité",
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DownloadPage(isGuest: true,)));
                          },
                        ),
                        SizedBox(width: 10.0,),
                        FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text("S'inscrire",
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.pushNamed(context, "/register");
                          },
                        ),
                      ]
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    if (_loginFormKey.currentState.validate()) {
      setState(() {waitingForValidation = true;});
      FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        UserCredential authResult = await _auth.signInWithEmailAndPassword(
            email: emailInputController.text,
            password: pwdInputController.text
        );
      }
      catch(platformExceptionToFirebaseAuthException) {
        print("Wrong credentials");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Une erreur s\'est produite',
          desc: 'Vérifiez votre mot de passe ou adresse email. Si le problème persiste, pensez à vérifier que vous avez une connexion internet active.',
          btnCancelText: "Rééssayer",
          btnCancelOnPress: () {pwdInputController.text = "";},
        ).show();
        setState(() {waitingForValidation = false;});
        return;
      }
      Navigator.pushNamed(context, "/splash");
    }
  }
}
