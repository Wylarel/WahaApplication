import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'storage.dart';

class MobileStorage implements Storage {
  Future<String> storeFile(String path, var file) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    StorageUploadTask uploadTask = ref.putFile(file);
    await uploadTask.onComplete;
    dynamic dlUrl = await ref.getDownloadURL();
    print("File uploaded !");
    return dlUrl.toString();
  }
}
// we expose a method that constructs the MobileStorage
Storage getStorage() => MobileStorage();
