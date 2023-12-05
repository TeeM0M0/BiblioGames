class Etagere {
  int _id;
  String _nom;
  int _biblothequeID;

  Etagere(this._id, this._nom, this._biblothequeID);

  int getId() {
    return this._id;
  }

  String getNom() {
    return this._nom;
  }

  int getIdBibliotheque() {
    return this._biblothequeID;
  }
}
