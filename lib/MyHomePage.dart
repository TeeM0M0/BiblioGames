import 'package:bibliogame/class/games.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bibliogame/function/load-games.dart';
import 'package:bibliogame/widget/navbar.dart';


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
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Acceuil())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(194, 195, 197, 5),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 200),
              child: const Text(
                "bibioGames",
                style: TextStyle(
                    fontFamily: 'Retro',
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          Center(
            child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Image.asset('Assets/loading.gif')),
          ),
        ],
      ),
    );
  }
}

class Acceuil extends StatefulWidget {
  @override
  _Acceuil createState() => _Acceuil();
}

//page d'acceuil avec un menu de navigation et deux boutons qui renvoit soit sur la page statistique ou personnalisé
class _Acceuil extends State<Acceuil> {
  List<Games> _games = [];
  int _page = 1;
  bool init = false;

  void chargement() async {
    _games = [];
    _games = await listGames(_games, _page);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      chargement();
      init = true;
    }
    return Scaffold(
        appBar: Navbar.appBar(context),
        drawer: Navbar.drawer(context),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
          ),
          padding: EdgeInsets.all(8.0), // padding around the grid
          itemCount: _games.length, // total number of items
          itemBuilder: (context, index) {
            return Container(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/gameInfo',
                      arguments: _games[index].getId());
                },
                child: Center(
                    child: Card(
                      color: const Color.fromRGBO(194, 195, 197, 5),
                  elevation: 4, // Change the elevation as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      // Image at the top
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: Image.network(
                          _games[index].getImg(), // Replace with your image URL
                          width: double.infinity,
                          height: 125,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _games[index].getNom(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(194, 195, 197, 5),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_page > 1) {
                    _page--;
                    chargement();
                  }
                },
              ),
              Text('Page $_page',
                  style: TextStyle(fontFamily: 'Retro', fontSize: 15)),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (_page < 500) {
                    _page++;
                    chargement();
                  }
                },
              ),
            ],
          ),
        ));
  }
}
