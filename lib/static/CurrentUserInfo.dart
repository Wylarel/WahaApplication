import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUserInfo {
  static String uid;
  static String fname;
  static String surname;
  static String displayName;

  static void genFromUid(String _uid) async {
    uid = _uid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.doc('users/' + uid).get();
    fname = documentSnapshot.data()["fname"];
    surname = documentSnapshot.data()["surname"];
    displayName = "$fname $surname";
    print("Generating user info from uid | fname: $fname - surname: $surname - displayName: $displayName");
  }
}