import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waha/widget/load.dart';
import 'module/calculator/calculator_view.dart';
import 'module/cloudstorage/upload_download_view.dart';
import 'module/downloadapp/downloadappdesktop_view.dart';
import 'module/periodictable/periodictable_view.dart';
import 'package:waha/routes/Routes.dart';
import 'data/colors.dart';
import 'module/auth/register.dart';
import 'module/auth/splash.dart';
import 'module/auth/login.dart';
import 'module/bugreport/bugreport_view.dart';
import 'module/food/food_view.dart';
import 'module/news/news_view.dart';
import 'module/notes/notes_view.dart';
import 'module/schedule/schedule_view.dart';
import 'module/downloadapp/downloadapp_view.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(App(savedThemeMode: savedThemeMode));
}


class App extends StatelessWidget {
  final savedThemeMode;
  const App({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text("L'application n'est pas accessible, réessayez plus tard");
        if (snapshot.connectionState == ConnectionState.done)
          {
            print("FlutterFire loaded");
            return MyApp(savedThemeMode: savedThemeMode,);
          }
        print("FlutterFire loading");
        return Load(100);
      },
    );
  }
}


class MyApp extends StatelessWidget {
  final savedThemeMode;
  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(),
        primaryColor: getPink(),
        accentColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
        accentColor: getPink(),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
          title: 'Waha',
          theme: theme,
          darkTheme: darkTheme,
          home: SplashPage(),
          routes: <String, WidgetBuilder>{
            Routes.splash: (context) => SplashPage(),
            Routes.login: (context) => LoginPage(),
            Routes.register: (context) => RegisterPage(),
            Routes.news: (context) => NewsPage(),
            Routes.schedule: (context) => SchedulePage(),
            Routes.notes: (context) => NotesPage(),
            Routes.editnote: (context) => EditNotePage(),
            Routes.periodictable: (context) => PeriodicTablePage(),
            Routes.calculator: (context) => CalculatorPage(),
            Routes.cloudupload: (context) => UploadPage(),
            Routes.clouddownload: (context) => DownloadPage(),
            Routes.food: (context) => FoodPage(),
            Routes.bugreport: (context) => BugreportPage(),
            Routes.downloadapp: (context) => DownloadAppPage(),
            Routes.downloadappdesktop: (context) => DownloadAppDesktopPage(),
          }),
    );
  }
}