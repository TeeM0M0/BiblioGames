class Jeu {
  int _id;
  String _nom;
  int _idJeuAPI;
  String _urlIMG;
  Jeu(this._id, this._nom,this._idJeuAPI,this._urlIMG);

  int getId() {
    return this._id;
  }

  int getIdAPI() {
    return this._idJeuAPI;
  }

  String getNom() {
    return this._nom;
  }

  String getIMG() {
    return this._urlIMG;
  }
}
