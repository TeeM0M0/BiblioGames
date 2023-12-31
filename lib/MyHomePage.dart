import 'package:bibliogame/class/games.dart';
import 'package:bibliogame/gameInfo.dart';
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
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Acceuil())));
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

class Acceuil extends StatefulWidget {
  @override
  _Acceuil createState() => _Acceuil();
}

//page d'acceuil avec un menu de navigation et deux boutons qui renvoit soit sur la page statistique ou personnalisé
class _Acceuil extends State<Acceuil> {
  List<Games> _games = [];
  int _page = 1;
  bool init = false;
  bool isLoading = true; // Nouvel état pour gérer le chargement
  ScrollController _scrollController = ScrollController();

  void chargement() async {
    _games = [];
    setState(() {
      isLoading = true; // Afficher le widget d'attente
    });

    _games = await listGames(_games, _page);

    setState(() {
      isLoading = false; // Cacher le widget d'attente
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      chargement();
      init = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('BiblioGames'),
        ),
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                size: 30,
                color: Colors.black,
              ))
        ],
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: EdgeInsets.all(8.0), // padding around the grid
              itemCount: _games.length, // total number of items
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/gameInfo');
                  },
                  child: Container(
                    child: Center(
                      child: Card(
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
                                _games[index].getImg(),
                                width: double.infinity,
                                height: 115,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_page > 1) {
                  _page--;
                  isLoading = true;
                  chargement();
                  _scrollController.jumpTo(0.0);
                }
              },
            ),
            Text('Page $_page'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (_page < 500) {
                  _page++;
                  isLoading = true;
                  chargement();
                  _scrollController.jumpTo(0.0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
