import 'clipboard.dart';
import 'package:clippy/browser.dart' as clippy;

class WebClipboard implements Clipboard {
  Future<void> copyText(String text) async {
    await clippy.write(text);
  }
}
Clipboard getClipboard() => WebClipboard();