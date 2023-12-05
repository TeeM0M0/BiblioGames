import 'package:bibliogame/class/serialisation/bibliotheques.dart';
import 'package:bibliogame/class/serialisation/jeu.dart';
import 'package:bibliogame/function/load-gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:bibliogame/widget/navbar.dart';
import 'package:bibliogame/class/gameInfo.dart';

class GameInfo extends StatefulWidget {
  @override
  _GameInfo createState() => _GameInfo();
}

class _GameInfo extends State<GameInfo> {
  List<GameInfoClass> _games = [];
  bool init = false;
  bool isLoading = true;

  void chargement(int id) async {
    setState(() {
      isLoading = true; // Afficher le widget d'attente
    });

    _games = await gameInfo(_games, id);

    setState(() {
      isLoading = false; // Cacher le widget d'attente
    });
  }

  @override
  Widget build(BuildContext context) {
    final int idGame = ModalRoute.of(context)!.settings.arguments as int;
    if (init == false) {
      chargement(idGame);
      init = true;
    }
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: Navbar.appBar(context),
        drawer: Navbar.drawer(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      _games[0].getImg(), // Replace with your image URL
                      width: double.infinity,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(_games[0].getNom()),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Date de sortie : " + _games[0].getRelease())
                          ],
                        ),
                        Column(
                          children: [
                            Text("Metacritic : " +
                                _games[0].getMetacritic().toString())
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
              onPressed: () => {Navigator.pop(context)},
              child: Icon(Icons.arrow_back),
              heroTag: "return",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
              onPressed: () => {},
              child: Icon(Icons.add),
              heroTag: "add",
            ),
          ),
        ]));
  }
}
