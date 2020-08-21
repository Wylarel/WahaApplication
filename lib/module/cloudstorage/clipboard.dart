import 'mobile_clipboard.dart' if (dart.library.html) 'web_clipboard.dart';

abstract class Clipboard {
  Future<void> copyText(String text);

  factory Clipboard() => getClipboard();
}