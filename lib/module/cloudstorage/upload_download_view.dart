import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:confetti/confetti.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waha/widget/load.dart';

import 'storage.dart';
import 'clipboard.dart' as cb;
import 'package:file_picker/file_picker.dart' if (dart.library.html) 'package:file_picker_web/file_picker_web.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Envoyer un fichier", true),
        drawer: AppDrawer(),
        body: FilePickingWidget(),
    );
  }
}

class FilePickingWidget extends StatefulWidget {
  @override
  _FilePickingWidgetState createState() => _FilePickingWidgetState();
}

class _FilePickingWidgetState extends State<FilePickingWidget> {
  var filePicked;
  String fileCode = "";
  bool uploaded = false;
  DropzoneViewController dropzoneController;
  ConfettiController confettiController;
  Color dropzoneColor = Colors.transparent;

  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fileCode != "" ? Container() : MaterialButton(
                color: Theme.of(context).primaryColor, textColor: Colors.white,
                child: Text(
                  filePicked == null ? 'Choisir un fichier' : _getFileName(
                      filePicked),
                  textAlign: TextAlign.center,),
                onPressed: () {
                  startPicker();
                },
              ),
              filePicked != null || !kIsWeb ? Container() : Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 25.0),
                child: Container(
                  height: 100.0,
                  width: 200.0,
                  child: Stack(
                      children: [DropzoneView(
                        operation: DragOperation.copy,
                        cursor: CursorType.grab,
                        onCreated: (ctrl) => setState(() {dropzoneController = ctrl; dropzoneColor = Theme.of(context).primaryColor;}),
                        onError: (ev) =>
                            setState(() {
                              dropzoneColor = Theme.of(context).primaryColor;
                            }),
                        onHover: () =>
                            setState(() {
                              dropzoneColor = Theme.of(context).accentColor;
                            }),
                        onDrop: (ev) =>
                            setState(() {
                              dropzoneColor = Theme.of(context).primaryColor;
                              filePicked = ev;
                            }),
                        onLeave: () =>
                            setState(() {
                              dropzoneColor = Theme.of(context).primaryColor;
                            }),
                      ),
                        DottedBorder(
                          color: dropzoneColor,
                          radius: Radius.circular(16),
                          dashPattern: [6, 3],
                          strokeWidth: 2,
                          child: Center(
                              child: Text("Ou glissez-déposez le ici")),
                        ),
                      ]
                  ),
                ),
              ),
              fileCode != "" ? Container() : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  filePicked == null ? Container() : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: MaterialButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text('Annuler'),
                      onPressed: () {
                        setState(() {
                          filePicked = null;
                        });
                      },
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).cardColor,
                    textColor: Colors.white,
                    child: Text('Envoyer'),
                    onPressed: filePicked == null ? null : () {
                      uploadFile(filePicked);
                    },
                  ),
                ],
              ),
              fileCode == "" ? Container() : Text(
                  "Voici votre code, utilisez le pour télécharger votre fichier de n'importe où. Attention, les fichiers ne sont stockés que 15 jours.",
                  textAlign: TextAlign.center
              ),
              fileCode == "" ? Container() : Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Stack(
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            formatCode(fileCode), textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor),
                          ),
                        ),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.copy),
                          tooltip: 'Copier dans le presse-papier',
                          onPressed: () {
                            _copyText(formatCode(fileCode), context);
                          },
                        )
                      ]
                  ),
                    Center(
                      child: ConfettiWidget(
                        confettiController: confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple
                        ], // manually specify the colors to be used
                      ),
                    ),
                  ]
                ),
              ),
              fileCode == "" || !uploaded ? Container() : MaterialButton(
                color: Theme.of(context).primaryColor, textColor: Colors.white,
                child: Text('Envoyer un autre fichier'),
                onPressed: () =>
                    setState(() {
                      filePicked = null;
                      fileCode = "";
                      uploaded = false;
                    }),
              ),
              fileCode == "" || uploaded ? Container() : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Upload..."),
              ),
              fileCode == "" || uploaded ? Container() : Load(100),
            ]
        ),
      ),
    );
  }

  void initState() {
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  void startPicker() async {
    var file = await FilePicker.getFile();

    setState(() {filePicked = file;});
  }

  void uploadFile(var file) async {
    var rng = new Random();
    String fileName = _getFileName(file);

    print(fileName);

    setState(() {
      fileCode = "${rng.nextInt(900000) + 100000}";
      uploaded = false;
    });

    Storage storage = new Storage();
    String dlUrl = await storage.storeFile("$fileCode/$fileName", file);
    FirebaseFirestore.instance.collection('cloud').doc(fileCode).set({"dl": dlUrl, "date": new DateTime.now().toString(), "path": "$fileCode/$fileName"});
    setState(() {uploaded = true;});
    confettiController.play();
  }

  String formatCode(String s) {
    var start = 0;
    final strings = <String>[];
    while (start < s.length) {
      final end = start + 2;
      strings.add(s.substring(start, end));
      start = end;
    }
    return strings.join(' ');
  }
}


class DownloadPage extends StatelessWidget {
  final bool isGuest;

  const DownloadPage({Key key, this.isGuest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Recevoir un fichier", !isGuest),
        drawer: isGuest ? null : AppDrawer(),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("Entrez le code de téléchargement à 6 chiffres:"),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CodeInputWidget(),
                ),
              ]
          ),
        )
    );
  }
}


class CodeInputWidget extends StatefulWidget {
  @override
  _CodeInputWidgetState createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  String currentCode;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  Widget dialog = Container();

  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: PinCodeTextField(
        length: 6,
        obsecureText: false,
        textInputType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        errorAnimationController: errorController, // Pass it here
        controller: textEditingController,

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Colors.black87,
          inactiveColor: Theme.of(context).primaryColor,
        ),
        animationType: AnimationType.fade,
        animationDuration: Duration(milliseconds: 150),
        backgroundColor: Colors.transparent,

        onChanged: (String value) {},
        onCompleted: (String value) {checkCode(value);},

        appContext: context,

        textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
    );
  }

  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
    super.initState();
  }

  void checkCode(String code) async {
    print(code);
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('cloud').doc(code).get();
    if(documentSnapshot.data() != null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Nous avons trouvé votre fichier',
          desc: 'Voullez-vous le télécharger ?',
          btnCancelText: "Annuler",
          btnOkText: "Télécharger",
          btnCancelOnPress: () {},
          btnOkOnPress: () {downloadFile(documentSnapshot.data()["dl"]);},
        )..show();
    } else {
      print("File doesn't exist");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Nous n\'avons pas pu trouver votre fichier',
        desc: 'Veuillez vérifier le code et assurez-vous que le fichier n\'a pas été soumis il y a plus de 15 jours',
        btnCancelText: "Rééssayer",
        btnCancelOnPress: () {},
      )..show();
      errorController.add(ErrorAnimationType.shake);
    }
    textEditingController.text = "";
  }

  void downloadFile(String downloadUrl) async {
    if(kIsWeb)
      await launch(downloadUrl);
    else {
      Directory dlpath = await getExternalStorageDirectory();
      print(dlpath.path);
      final taskId = await FlutterDownloader.enqueue(
        url: downloadUrl,
        savedDir: dlpath.path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      print(taskId);
    }
  }
}

String _getFileName(var file) {
  if (kIsWeb) {
    print("I'm on web! Using File.name instead of File.path");
    return file.name;
  }
  else
    return file.path.split("/").last;
}

void _copyText(String text, BuildContext context) async {
  cb.Clipboard clipboard = new cb.Clipboard();
  clipboard.copyText(text);
  Fluttertoast.showToast(
      msg: "Code copié: $text",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[500],
      textColor: Colors.white,
      fontSize: 16.0
  );
}