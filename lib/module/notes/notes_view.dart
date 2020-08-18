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
    FirebaseUser user = await _auth.currentUser();
    Firestore.instance.collection('notes').document(user.uid).collection("notes").document(currentNoteId).setData({"text": ""});
    print("Created note " + currentNoteId);
    Navigator.pushReplacementNamed(context, Routes.editnote);
  }
}

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  Map<String, String> noteMap = new Map<String, String>();
  bool hasLoadedNotes = false;

  Widget build(BuildContext context) {
    List<Widget> noteListWidgets = new List<Widget>();
    noteMap.forEach((key, value) {
      value = value.replaceAll("\n", "");
      if(value.length > 128) {
        value = value.substring(0, 128) + "...";
      }
      noteListWidgets.add(Card(child: ListTile(title: Text(value), onTap: () => openNote(key))));
    });

    if (noteListWidgets.length > 0) {
      return Center(
        child: ListView(
          children: noteListWidgets,
        ),
      );
    } else if (hasLoadedNotes) {
      return Center(
        child: Text("Vous n'avez pas encore créé de note !")
      );
    }
    else {
      return Center(
        child: Load(100),
      );
    }
  }

  void initState() {
    super.initState();
    print("Init state notes");
    Map<String, String> draftNoteMap = new Map<String, String>();
    FirebaseAuth.instance.currentUser().then((user) =>
        Firestore.instance.collection('notes').document(user.uid).collection(
            "notes").getDocuments().then(
                (querySnapshot) =>
                querySnapshot.documents.forEach(
                        (element) {
                      draftNoteMap.putIfAbsent(
                          element.documentID, () => element["text"]);
                    }
                )
        )
    ).then((value) => setState(() => {noteMap = draftNoteMap, hasLoadedNotes = true}));
  }

  void openNote(String id) {
    currentNoteId = id;
    Navigator.pushReplacementNamed(context, Routes.editnote);
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
    if (textToSave.replaceAll(" ", "") != "") {
      FirebaseAuth.instance.currentUser().then((user) =>
          Firestore.instance.collection('notes').document(user.uid).collection("notes").document(currentNoteId).setData({"text": textToSave})
      );
    } else {
      FirebaseAuth.instance.currentUser().then((user) =>
          Firestore.instance.collection('notes').document(user.uid).collection("notes").document(currentNoteId).delete()
      );
    }
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
    txt.text = "Chargement...";
    FirebaseAuth.instance.currentUser().then((user) =>
        Firestore.instance.collection('notes').document(user.uid).collection("notes").document(currentNoteId).get().then((snapshot) =>
            txt.text = snapshot.data["text"] != null ? snapshot.data["text"] : ""
        )
    );
  }
}