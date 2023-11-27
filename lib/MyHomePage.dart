import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bibliogame/function/load-games.dart';

//permet la création du splashscreen au lancement de l'application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  SplashScreenState createState() => SplashScreenState();
}

//splashscreen de 3 secondes avec le logo et un CircularProgressIndicator qui renvoie sur la page d'acceuil
class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Acceuil())));
    listGames([], 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 200),
              child: const Text("bibioGames"),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 350.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//page d'acceuil avec un menu de navigation et deux boutons qui renvoit soit sur la page statistique ou personnalisé
class Acceuil extends StatelessWidget {
  const Acceuil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioGames'),
        backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Center(
              child: DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.grey),
                ),
              ),
            ),
            Center(
              child: ListTile(
                title: const Text(
                  'Mes bibliothèques',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  null;
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [Text("BiblioGames")],
          ),
        ),
      ),
    );
  }
}
