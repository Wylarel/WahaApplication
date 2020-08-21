import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'storage.dart';

class WebStorage implements Storage {
  Future<String> storeFile(String path, var file) async {
    var ref = fb.storage().ref(path);
    var uploadTask = ref.put(file);
    await uploadTask.future;
    var dlUrl = await ref.getDownloadURL();
    print("File uploaded !");
    return dlUrl.toString();
  }
}
Storage getStorage() => WebStorage();