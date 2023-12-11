import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'jeu.dart';

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
      version: 1,
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS bibliotheques (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT
          );
          '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS jeux (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            idJeuAPI INTEGER,
            urlIMG TEXT
          );
           '''
    );
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS bibliotheque_jeu (
            idBibliotheque INTEGER,
            idJeu INTEGER,
            FOREIGN KEY (idBibliotheque) REFERENCES bibliotheques (id),
            FOREIGN KEY (idJeu) REFERENCES jeux (id),
            PRIMARY KEY (idBibliotheque, idJeu)
          );
        '''
    );
    return db;
  }

  static Future<void> newBiblioAndAddJeu(String nomBibliotheque, String nomJeu, int idAPIJeu, String urlIMG) async {
    final db = await initDatabase();
    int idBibliotheque = await db.insert('bibliotheques', {'nom': nomBibliotheque});
    int idJeu = await db.insert('jeux', {'nom': nomJeu, 'idJeuAPI': idAPIJeu, 'urlIMG' : urlIMG});
    await db.insert('bibliotheque_jeu', {'idBibliotheque': idBibliotheque, 'idJeu': idJeu});
    print('La bibliothèque "$nomBibliotheque" a été créée, et le jeu "$nomJeu" a été ajouté à cette bibliothèque.');
  }

  static Future<void> addJeuBiblio(String nomBibliotheque, String nomJeu, int idAPIJeu, String urlIMG) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> biblioResult = await db.query(
      'bibliotheques',
      columns: ['id'],
      where: 'nom = ?',
      whereArgs: [nomBibliotheque],
    );
    if (biblioResult.isNotEmpty) {
      int idBibliotheque = biblioResult.first['id'];
      int idJeu = await db.insert('jeux', {'nom': nomJeu, 'idJeuAPI': idAPIJeu, 'urlIMG': urlIMG});
      await db.insert('bibliotheque_jeu', {'idBibliotheque': idBibliotheque, 'idJeu': idJeu});
      print('Le jeu "$nomJeu" a été ajouté à la bibliothèque "$nomBibliotheque".');
    } else {
      print('La bibliothèque "$nomBibliotheque" n\'existe pas.');
    }
  }

  static Future<void> dellJeuBiblio(String nomBibliotheque, String nomJeu) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> biblioResult = await db.query(
      'bibliotheques',
      columns: ['id'],
      where: 'nom = ?',
      whereArgs: [nomBibliotheque],
    );
    if (biblioResult.isNotEmpty) {
      int idBibliotheque = biblioResult.first['id'];
      List<Map<String, dynamic>> jeuResult = await db.query(
        'jeux',
        columns: ['id'],
        where: 'nom = ?',
        whereArgs: [nomJeu],
      );
      if (jeuResult.isNotEmpty) {
        int idJeu = jeuResult.first['id'];
        await db.delete(
          'bibliotheque_jeu',
          where: 'idBibliotheque = ? AND idJeu = ?',
          whereArgs: [idBibliotheque, idJeu],
        );
        print('Le jeu "$nomJeu" a été supprimé de la bibliothèque "$nomBibliotheque".');
      } else {
        print('Le jeu "$nomJeu" n\'existe pas.');
      }
    } else {
      print('La bibliothèque "$nomBibliotheque" n\'existe pas.');
    }
  }



  static Future<List<Jeu>> getJeuxBiblio(String nomBibliotheque) async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> biblioResult = await db.query('bibliotheques',
        where: 'nom = ?',
        whereArgs: [nomBibliotheque],
        limit: 1);
    if (biblioResult.isEmpty) {
      // La bibliothèque n'a pas été trouvée, vous pouvez gérer cela en conséquence
      return [];
    }
    int idBibliotheque = biblioResult[0]['id'];
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT *
    FROM jeux
    WHERE id IN (
      SELECT idJeu
      FROM bibliotheque_jeu
      WHERE idBibliotheque = ?
    )
  ''', [idBibliotheque]);
    List<Jeu> jeux = [];
    for (var jeu in result) {
      jeux.add(Jeu(jeu['id'], jeu['nom'], jeu['idJeuAPI'], jeu["urlIMG"]));
    }
    return jeux;
  }


  static Future<List<String>> getBiblioNames() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT nom
        FROM bibliotheques
        '''
      );
    List<String> bibliothequeNames = result.map<String>((map) => map['nom'] as String).toList();
    return bibliothequeNames;
  }


  // ancienne version
  // static Future<List<Jeu>> jeuxDeBibliothequeParNom(String nomBibliotheque) async {
  //   final db = await database;
  //
  //   // Utilisation d'une requête JOIN pour récupérer les jeux liés à la bibliothèque
  //   final List<Map<String, dynamic>> maps = await db.rawQuery('''
  //   SELECT jeux.id, jeux.nom, jeux.idJeuAPI
  //   FROM jeux
  //   JOIN collection_jeu ON jeux.id = collection_jeu.idJeu
  //   JOIN collections ON collection_jeu.idCollection = collections.id
  //   JOIN etagere_collection ON collections.id = etagere_collection.idCollection
  //   JOIN etageres ON etagere_collection.idEtagere = etageres.id
  //   JOIN bibliotheque_etagere ON etageres.id = bibliotheque_etagere.idEtagere
  //   JOIN bibliotheques ON bibliotheque_etagere.idBibliotheque = bibliotheques.id
  //   WHERE bibliotheques.nom = ?
  // ''', [nomBibliotheque]);
  //
  //   return List.generate(maps.length, (i) {
  //     return Jeu(
  //       maps[i]['id'],
  //       maps[i]['nom'],
  //       maps[i]['idJeuAPI'],
  //     );
  //   });
  // }
  //
  // Future<void> creerBibliothequeEtAjouterJeu(String nomBibliotheque, String nomJeu, int idAPIJeu) async {
  //   final db = await database;
  //
  //   // Créer une nouvelle bibliothèque
  //   int idBibliotheque = await db.insert('bibliotheques', {'nom': nomBibliotheque});
  //
  //   // Créer une nouvelle étagère liée à la bibliothèque
  //   int idEtagere = await db.insert('etageres', {'nom': 'Etagere de $nomBibliotheque'});
  //   await db.insert('bibliotheque_etagere', {'idBibliotheque': idBibliotheque, 'idEtagere': idEtagere});
  //
  //   // Créer une nouvelle collection liée à l'étagère
  //   int idCollection = await db.insert('collections', {'nom': 'Collection de $nomBibliotheque'});
  //   await db.insert('etagere_collection', {'idEtagere': idEtagere, 'idCollection': idCollection});
  //
  //   // Insérer un nouveau jeu
  //   int idJeu = await db.insert('jeux', {'nom': nomJeu, 'idJeuAPI': idAPIJeu});
  //
  //   // Associer le jeu à la collection
  //   await db.insert('collection_jeu', {'idCollection': idCollection, 'idJeu': idJeu});
  //
  //   print('La bibliothèque "$nomBibliotheque" a été créée, l\'étagère et la collection ont été ajoutées, et le jeu "$nomJeu" a été ajouté à cette collection.');
  // }

  static void printTablesContents() async {
    final db = await DatabaseHelper.database;
    if (db == null) {
      print("Erreur lors de l'ouverture de la base de données.");
      return;
    }
    final tableNames = ["bibliotheques","jeux", "bibliotheque_jeu"];
    for (final tableName in tableNames) {
      final List<Map<String, dynamic>> results = await db.query(tableName);
      print("Contenu de la table $tableName:");
      for (final row in results) {
        print(row);
      }
      print("----");
    }
  }
}
