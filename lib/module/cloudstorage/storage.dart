import 'mobile_storage.dart' if (dart.library.html) 'web_storage.dart';

abstract class Storage {
  Future<String> storeFile(String path, var file);

  factory Storage() => getStorage();
}