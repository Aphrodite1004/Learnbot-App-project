class MyVerb_Model {
  String _lang;
  String _infinitiv_text;
  List<String> _conj1_text = List();
  List<String> _conj2_text = List();
  List<String> _conj3_text = List();
  List<String> _conj4_text = List();
  List<String> _conj5_text = List();
  List<String> _conj6_text = List();

  String get lang => _lang;
  String get infinitiv_text => _infinitiv_text;
  List get conj1_text => _conj1_text;
  List get conj2_text => _conj2_text;
  List get conj3_text => _conj3_text;
  List get conj4_text => _conj4_text;
  List get conj5_text => _conj5_text;
  List get conj6_text => _conj6_text;

  MyVerb_Model.fromMap(Map<String, dynamic> obj) {
    this._lang = obj['lang'];
    this._infinitiv_text = obj['infinitiv_text'];
    for(int i = 0; i < 6; i++){
      this._conj1_text.add(obj['conj' + (i+1).toString() + '_text']);
      this._conj2_text.add(obj['conj' + (i+7).toString() + '_text']);
      this._conj3_text.add(obj['conj' + (i+13).toString() + '_text']);
      this._conj4_text.add(obj['conj' + (i+19).toString() + '_text']);
      this._conj5_text.add(obj['conj' + (i+25).toString() + '_text']);
      this._conj6_text.add(obj['conj' + (i+31).toString() + '_text']);
    }
  }
}
