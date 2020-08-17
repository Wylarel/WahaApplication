import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/routes/Routes.dart';
import 'package:waha/widget/drawer.dart';
import 'dart:math';

import 'package:waha/widget/load.dart';


String currentNoteId;
var txt = TextEditingController();


class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: getPink(),
      ),
      drawer: AppDrawer(),
      body: NoteListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newNote(context);
        },
        child: Icon(Icons.add),
        backgroundColor: getPink(),
      ),
    );
  }

  void newNote(BuildContext context) async {
    currentNoteId = String.fromCharCodes(new List.generate(32,(index){return new Random().nextInt(33)+89;}));

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    _firestore.collection('notes').document(user.uid).setData({currentNoteId: ""});

    print("Created note " + currentNoteId);
    Navigator.pushReplacementNamed(context, Routes.editnote);
  }
}

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  Widget build(BuildContext context) {
    return Center(
      child: Load(100),
    );
  }

  void initState() {
    super.initState();
    print("Init state notes");
  }
}

class EditNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var editNoteFieldWidget = new EditNoteFieldWidget();
    return Scaffold(
        appBar: AppBar(
            title: Text("Modifier une note"),
            backgroundColor: getPink(),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  saveNote(context, txt.text);
                },
              ),
            ]),
        body: editNoteFieldWidget,
    );
  }

  void saveNote(BuildContext context, String textToSave) async
  {
    Firestore.instance.collection('notes').document("user").setData({currentNoteId: textToSave});
    Navigator.pushReplacementNamed(context, Routes.notes);
  }
}

class EditNoteFieldWidget extends StatefulWidget {
  @override
  _EditNoteFieldWidgetState createState() => _EditNoteFieldWidgetState();
}

class _EditNoteFieldWidgetState extends State<EditNoteFieldWidget> {
  Widget build(BuildContext context) {
    return Container(
      height: 2400.0,
      child: TextField(
        maxLines: 1000000,
        controller: txt,
        decoration: InputDecoration(
          hintText: "Ecrivez votre note ici puis sauvegardez en utilisant le boutton en haut à droite.",
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void initState() {
    super.initState();
  }

  void setTextFieldText() async {
    // Firestore.instance.collection('notes').document().get().then((QuerySnapshot snapshot) => txt.text = snapshot.documents.);
  }
}