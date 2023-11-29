import 'package:flutter/material.dart';
import 'dart:async';

class GameInfo extends StatefulWidget {
  @override
  _GameInfo createState() => _GameInfo();
}

class _GameInfo extends State<GameInfo> {
  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            Container(
              child: Center(
                child: Text("image du jeu"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("nom du jeu"),
                Column(
                  children: [],
                ),
                Column(
                  children: [],
                )
              ],
            )
          ],
        ));
  }
}
