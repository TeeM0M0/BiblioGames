import 'package:bibliogame/class/database/db.dart';
import 'package:flutter/material.dart';
import 'package:bibliogame/MyHomePage.dart';
import 'package:bibliogame/gameInfo.dart';
import 'package:flutter/services.dart';
import 'MesBibliotheques.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  DatabaseHelper.printTablesContents();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeerMaker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Accueil'),
      routes: <String, WidgetBuilder>{
        '/accueil': (BuildContext context) =>  Acceuil(),
        '/gameInfo': (BuildContext context) =>  GameInfo(),
        '/MesBibliotheques': (BuildContext context) =>  MesBibliotheques(),
      },
    );
  }
}
