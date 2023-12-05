class Collection {
  int _id;
  String _nom;
  int _etagereID;

  Collection(this._id, this._nom, this._etagereID);

  int getId() {
    return this._id;
  }

  String getNom() {
    return this._nom;
  }

  int getIdEtagere() {
    return this._etagereID;
  }
}
