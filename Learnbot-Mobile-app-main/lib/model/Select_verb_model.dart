class Select_Verb_Model {
  String _english;
  String _nativ;
  int _favorite;

  String get english => _english;
  String get nativ => _nativ;
  int get favorite=> _favorite;

  Select_Verb_Model.fromMap(Map<String, dynamic> obj) {
    this._english = obj['english'];
    this._nativ = obj['infinitiv_text'];
    this._favorite = obj['favorite'];
  }
}
