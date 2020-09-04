import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:waha/widget/load.dart';


String currentNoteId;
var txt = TextEditingController();


class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Notes", true),
      drawer: AppDrawer(),
      body: NoteListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newNote(context);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void newNote(BuildContext context) async {
    currentNoteId = String.fromCharCodes(new List.generate(32,(index){return new Random().nextInt(33)+89;}));

    FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").doc(currentNoteId).set({"text": ""});
    print("Created note " + currentNoteId);
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditNotePage()));
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
      value = value.replaceAll(" \n", " ").replaceAll("\n ", " ").replaceAll("\n", " ");
      if(value.length > 200) {
        value = value.substring(0, 200) + "...";
      }
      noteListWidgets.add(Card(child: ListTile(
        title:Text(value),
        onTap: () => openNote(key),
        onLongPress: () => AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Confirmer la suppression',
          desc: 'Êtes-vous sûr de vouloir supprimer cette note ? Vous ne pourez pas la réstaurer.',
          btnCancelText: "Annuler",
          btnOkText: "Supprimer",
          btnCancelOnPress: () {},
          btnOkOnPress: () {deleteNote(key);},
        )..show())
      ));
    });

    if (noteListWidgets.length > 0) {
      noteListWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Pour supprimer une note, appuyez longuement dessus", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
      ));
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => updateNoteList(),
          child: ListView(
            children: noteListWidgets,
          ),
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
    updateNoteList();
  }

  void openNote(String id) {
    currentNoteId = id;
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditNotePage()));
  }

  void deleteNote(String id) {
    currentNoteId = id;
    FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").doc(currentNoteId).delete();
    updateNoteList();
  }

  Future<void> updateNoteList() async
  {
    Map<String, String> draftNoteMap = new Map<String, String>();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").get();
    querySnapshot.docs.forEach((element) {
          draftNoteMap.putIfAbsent(
              element.id, () => element.data()["text"]);
        });
    setState(() => {noteMap = draftNoteMap, hasLoadedNotes = true});
  }
}

class EditNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var editNoteFieldWidget = new EditNoteFieldWidget();
    return Scaffold(
      appBar: AppBar(
          title: Text("Modifier une note"),
          automaticallyImplyLeading: false,
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
    if (textToSave.replaceAll(" ", "") != "")
      FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").doc(currentNoteId).set({"text": textToSave});
    else
      FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").doc(currentNoteId).delete();

    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: NotesPage()));
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
          hintText: "Ecrivez votre note ici",
          fillColor: Colors.transparent,
          filled: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    txt.text = "Chargement...";
    FirebaseFirestore.instance.collection('notes').doc(FirebaseAuth.instance.currentUser.uid).collection("notes").doc(currentNoteId).get().then((snapshot) =>
            txt.text = snapshot.data()["text"] != null ? snapshot.data()["text"] : ""
    );
  }
}