import 'package:flutter/material.dart';
import 'package:bibliogame/MyHomePage.dart';
import 'package:flutter/services.dart';
import 'gameInfo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiblioGames',
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
        '/acceuil': (BuildContext context) => Acceuil(),
        '/gameInfo': (BuildContext context) => GameInfo(),
      },
    );
  }
}
