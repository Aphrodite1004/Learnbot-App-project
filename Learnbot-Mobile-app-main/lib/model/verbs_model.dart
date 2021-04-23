class Verbs {
  String _lang;
  String _english;
  String _infinitiv_text;
  String _infinitiv_text_translit;
  int _idx;
  String _image;
  String _infinitiv_audio;
  List<String> _conj1_text = List(), _conj1_audio = List();
  List<String> _conj2_text = List(), _conj2_audio = List();
  List<String> _conj3_text = List(), _conj3_audio = List();
  List<String> _conj4_text = List(), _conj4_audio = List();
  List<String> _conj5_text = List(), _conj5_audio = List();
  List<String> _conj6_text = List(), _conj6_audio = List();

  String get lang => _lang;
  String get english => _english;
  String get infinitiv_text => _infinitiv_text;
  String get infinitv_text_translit => _infinitiv_text_translit;
  int get idx => _idx;
  String get image => _image;
  String get infinitiv_audio => _infinitiv_audio;
  List get conj1_text => _conj1_text;
  List get conj1_audio => _conj1_audio;
  List get conj2_text => _conj2_text;
  List get conj2_audio => _conj2_audio;
  List get conj3_text => _conj3_text;
  List get conj3_audio => _conj3_audio;
  List get conj4_text => _conj4_text;
  List get conj4_audio => _conj4_audio;
  List get conj5_text => _conj5_text;
  List get conj5_audio => _conj5_audio;
  List get conj6_text => _conj6_text;
  List get conj6_audio => _conj6_audio;

  Verbs.fromMap(Map<String, dynamic> obj) {
    this._lang = obj['lang'];
    this._english = obj['english'];
    this._infinitiv_text = obj['infinitiv_text'];
    this._infinitiv_text_translit = obj['infinitiv_text_translit'];
    this._idx = obj['idx'];
    this._image = obj['image_768x1024'];
    this._infinitiv_audio = obj['infinitiv_audio'];
    for(int i = 0; i < 6; i++){
      this._conj1_text.add(obj['conj' + (i+1).toString() + '_text']);
      this._conj1_audio.add(obj['conj' + (i+1).toString() + '_audio']);
      this._conj2_text.add(obj['conj' + (i+7).toString() + '_text']);
      this._conj2_audio.add(obj['conj' + (i+7).toString() + '_audio']);
      this._conj3_text.add(obj['conj' + (i+13).toString() + '_text']);
      this._conj3_audio.add(obj['conj' + (i+13).toString() + '_audio']);
      this._conj4_text.add(obj['conj' + (i+19).toString() + '_text']);
      this._conj4_audio.add(obj['conj' + (i+19).toString() + '_audio']);
      this._conj5_text.add(obj['conj' + (i+25).toString() + '_text']);
      this._conj5_audio.add(obj['conj' + (i+25).toString() + '_audio']);
      this._conj6_text.add(obj['conj' + (i+31).toString() + '_text']);
      this._conj6_audio.add(obj['conj' + (i+31).toString() + '_audio']);
    }
  }
}
