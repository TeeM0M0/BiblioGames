import 'package:flutter/material.dart';
import 'package:bibliogame/widget/navbar.dart';
import 'package:bibliogame/class/database/db.dart';
import 'package:bibliogame/class/database/jeu.dart';

class MesBibliotheques extends StatefulWidget {
  @override
  _MesBibliotheques createState() => _MesBibliotheques();
}

class _MesBibliotheques extends State<MesBibliotheques> {
  List<String> _nomBiblio = [];
  bool init = false;
  bool isLoading = true;

  void chargement() async {
    setState(() {
      isLoading = true; // Afficher le widget d'attente
    });

    _nomBiblio = await DatabaseHelper.getBiblioNames();

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
                children: _nomBiblio.asMap().entries.map((entry) {
                  String nomBiblio = entry.value;
                  return FutureBuilder(
                    future: DatabaseHelper.getJeuxBiblio(nomBiblio),
                    builder: (context, Jeux) {
                      if (Jeux.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (Jeux.hasError) {
                        return Text('Erreur : ${Jeux.error}');
                      } else {
                        List<Jeu> jeux = Jeux.data as List<Jeu>;

                        if (jeux.isEmpty) {
                          return Column(
                            children: [
                              Center(child:Text(
                                nomBiblio,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),),
                              Center(child: Text('Aucun jeu dans cette bibliothèque.') ,)
                             ,
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                nomBiblio,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.6,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: jeux.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Jeu jeu = jeux[index];

                                    return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/gameInfo',
                                              arguments: jeu.getIdAPI());
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              margin: EdgeInsets.all(8),
                                              child: Card(
                                                color: const Color.fromRGBO(
                                                    194, 195, 197, 5),
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                15.0),
                                                        topRight:
                                                            Radius.circular(
                                                                15.0),
                                                      ),
                                                      child: Image.network(
                                                        jeu.getIMG(),
                                                        width: double.infinity,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(10)),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          jeu.getNom(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    DatabaseHelper
                                                        .dellJeuBiblio(
                                                            nomBiblio,
                                                            jeu.getNom());
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1.5),
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }
}
