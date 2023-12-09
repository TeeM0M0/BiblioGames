import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'bibliotheques.dart';
import 'etagere.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'retro_database.db'),
      onCreate: (db, version) {
      },
      version: 2,
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS etageres (
            id INTEGER PRIMARY KEY,
            nom TEXT
          );
          '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS bibliotheques (
            id INTEGER PRIMARY KEY,
            nom TEXT
          );
          '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS collections (
            id INTEGER PRIMARY KEY,
            nom TEXT
          );
          '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS jeux (
            id INTEGER PRIMARY KEY,
            nom TEXT,
            idJeuAPI INTEGER
          );
           '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS bibliotheque_etagere (
            idBibliotheque INTEGER,
            idEtagere INTEGER,
            FOREIGN KEY (idBibliotheque) REFERENCES bibliotheques(id),
            FOREIGN KEY (idEtagere) REFERENCES etageres(id),
            PRIMARY KEY (idBibliotheque, idEtagere)
          );
          '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS etagere_collection (
            idEtagere INTEGER,
            idCollection INTEGER,
            FOREIGN KEY (idEtagere) REFERENCES etageres(id),
            FOREIGN KEY (idCollection) REFERENCES collections(id),
            PRIMARY KEY (idEtagere, idCollection)
          );
           '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS collection_jeu (
            idCollection INTEGER,
            idJeu INTEGER,
            FOREIGN KEY (idCollection) REFERENCES collections(id),
            FOREIGN KEY (idJeu) REFERENCES jeux(id),
            PRIMARY KEY (idCollection, idJeu)
          );
          '''
    );
    return db;
  }

  static Future<void> insertBibliotheque(Bibliotheque bibliotheque) async {
    final db = await database;
    await db.insert(
      'bibliotheques',
      bibliotheque.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertBibliothequeEtagere(int idBibliotheque, int idEtagere) async {
    final db = await database;
    await db.insert(
      'bibliotheque_etagere',
      {'idBibliotheque': idBibliotheque, 'idEtagere': idEtagere},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Bibliotheque>> bibliotheques() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bibliotheques');
    return List.generate(maps.length, (i) {
      return Bibliotheque(
        maps[i]['id'],
        maps[i]['nom'],
      );
    });
  }

  static Future<List<Etagere>> etageresOfBibliotheque(int idBibliotheque) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT etageres.id, etageres.nom
      FROM etageres
      INNER JOIN bibliotheque_etagere ON etageres.id = bibliotheque_etagere.idEtagere
      WHERE bibliotheque_etagere.idBibliotheque = ?
    ''', [idBibliotheque]);

    return List.generate(maps.length, (i) {
      return Etagere(
        maps[i]['id'],
        maps[i]['nom'],
      );
    });
  }

  static void printTablesContents() async {
    final db = await DatabaseHelper.database;

    if (db == null) {
      print("Erreur lors de l'ouverture de la base de données.");
      return;
    }

    final tableNames = ["etageres", "bibliotheques", "collections", "jeux", "bibliotheque_etagere", "etagere_collection", "collection_jeu"];

    for (final tableName in tableNames) {
      final List<Map<String, dynamic>> results = await db.query(tableName);

      print("Contenu de la table $tableName:");
      for (final row in results) {
        print(row);
      }
      print("----");
    }
  }

// ... Autres méthodes pour la gestion d'Etagere
}
