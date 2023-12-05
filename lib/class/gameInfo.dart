class GameInfoClass {
  String _nom;
  String _img;
  String _description;
  String _release;
  int _metacreitic;
  List _platforme;
  List _dev;
  List _genre;

  GameInfoClass(this._nom, this._img, this._genre, this._dev, this._description,
      this._metacreitic, this._platforme, this._release);

  String getNom() {
    return this._nom;
  }

  String getImg() {
    return this._img;
  }

  String getRelease() {
    return this._release;
  }

  String getDescription() {
    return this._description;
  }

  int getMetacritic() {
    return this._metacreitic;
  }

  List getPlatforme() {
    return this._platforme;
  }

  List getDev() {
    return this._dev;
  }

  List getGenre() {
    return this._genre;
  }
}
