class Games {
  int _id;
  String _nom;
  String _img;

  Games(this._id,this._nom, this._img);

  int getId() {
    return this._id;
  }

  String getNom() {
    return this._nom;
  }

  String getImg() {
    return this._img;
  }
}
