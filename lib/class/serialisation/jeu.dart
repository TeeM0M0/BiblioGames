class Jeu {
  int _id;
  String _nom;
  int _collectionId;

  Jeu(this._id, this._nom, this._collectionId);

  int getId() {
    return this._id;
  }

  String getNom() {
    return this._nom;
  }

  int getIdCollection() {
    return this._collectionId;
  }
}
