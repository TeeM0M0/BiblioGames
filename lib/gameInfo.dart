import 'package:bibliogame/function/load-gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:bibliogame/widget/navbar.dart';
import 'package:bibliogame/class/gameInfo.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bibliogame/class/database/db.dart';

class GameInfo extends StatefulWidget {
  @override
  _GameInfo createState() => _GameInfo();
}

class _GameInfo extends State<GameInfo> {
  List<GameInfoClass> _games = [];
  List<String> _nomBiblio= [];
  bool init = false;
  bool isLoading = true;

  void chargement(int id) async {
    setState(() {
      isLoading = true; // Afficher le widget d'attente
    });

    _nomBiblio= await DatabaseHelper.getBiblioNames();
    _games = await gameInfo(_games, id);

    setState(() {
      isLoading = false; // Cacher le widget d'attente
    });
  }

  void resetBiblio() async {
    _nomBiblio= await DatabaseHelper.getBiblioNames();
    setState(() {});
  }

  Widget createModal(BuildContext context, Function(String) onCreate) {
    TextEditingController textController = TextEditingController();

    return AlertDialog(
      title: Text("Nouvelle bibliothèque"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Nom de la bibliothèque'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String libraryName = textController.text;
              if (libraryName.isNotEmpty) {
                onCreate(libraryName);
                Navigator.pop(context); // Fermer le modal après la création
              }
            },
            child: Text("Créer"),
          ),
        ],
      ),
    );
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
        drawer: Navbar.drawer(context),
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
            child: SpeedDial(
              backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              onOpen: () => print('Speed Dial Opened'),
              onClose: () => print('Speed Dial Closed'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0),
              ),
              children: [
                SpeedDialChild(
                    label: "Nouvelle bibliothèque",
                    backgroundColor: Colors.green,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return createModal(context, (String bibliotheque) {
                            DatabaseHelper.newBiblioAndAddJeu(bibliotheque, _games[0].getNom(), idGame,_games[0].getImg());
                            resetBiblio();
                            print("Nouvelle bibliothèque créée : $bibliotheque");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Bibliothèque créée avec succès : $bibliotheque'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          });
                        },
                      );
                    }
                ),
                ..._nomBiblio.map((nom) => SpeedDialChild(
                  label: nom.toString(),
                  backgroundColor: Colors.blue,
                  onTap: () {
                    DatabaseHelper.addJeuBiblio(nom.toString(),_games[0].getNom(), idGame,_games[0].getImg());
                    resetBiblio();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Jeu ajouté à la bibliothèque'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ]));
  }
}
