import 'etagere.dart';

class Bibliotheque {
  int id;
  String nom;

  Bibliotheque(this.id, this.nom);

  int getId() {
    return this.id;
  }

  String getNom() {
    return this.nom;
  }

}
