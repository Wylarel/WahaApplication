import 'clipboard.dart';
import 'package:clipboard/clipboard.dart';

class MobileClipboard implements Clipboard {
  Future<void> copyText(String text) async {
    await FlutterClipboard.copy(text);
  }
}
Clipboard getClipboard() => MobileClipboard();
