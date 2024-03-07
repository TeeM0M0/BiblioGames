import 'package:flutter/material.dart';

class Navbar {

  static PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title:Center(child: const Text('BiblioGames', style: TextStyle(fontFamily: 'Retro'))),
      backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
      actions: [
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              size: 30,
              color: const Color.fromRGBO(194, 195, 197, 5),
            ))
      ],
    );
  }

  static Widget drawer(BuildContext context) {
    return Drawer(
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
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Center(
            child: ListTile(
              title: const Text(
                'Accueil',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/accueil');
              },
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
                Navigator.pushNamed(context, '/MesBibliotheques');
              },
            ),
          ),
        ],
      ),
    );
  }


}
