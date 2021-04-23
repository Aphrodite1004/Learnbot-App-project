class Words {
  String _list;
  String _nativ;
  String _tempus1;
  String _tempus2;
  String _tempus3;
  String _tempus4;
  String _tempus5;
  String _tempus6;

  String _pronom1;
  String _pronom2;
  String _pronom3;
  String _pronom4;
  String _pronom5;
  String _pronom6;

//  Words(
//      this._list,
//      this._nativ,
//      this._tempus1,
//      this._tempus2,
//      this._tempus3,
//      this._tempus4,
//      this._tempus5,
//      this._tempus6,
//      this._pronom1,
//      this._pronom2,
//      this._pronom3,
//      this._pronom4,
//      this._pronom5,
//      this._pronom6);
//
//  Words.map(dynamic obj) {
//    this._list = obj['list'];
//    this._nativ = obj['nativ'];
//    this._tempus1 = obj['tempus1'];
//    this._tempus2 = obj['tempus2'];
//    this._tempus3 = obj['tempus3'];
//    this._tempus4 = obj['tempus4'];
//    this._tempus5 = obj['tempus5'];
//    this._tempus6 = obj['tempus6'];
//    this._pronom1 = obj['pronom1'];
//    this._pronom2 = obj['pronom2'];
//    this._pronom3 = obj['pronom3'];
//    this._pronom4 = obj['pronom4'];
//    this._pronom5 = obj['pronom5'];
//    this._pronom6 = obj['pronom6'];
//  }
//
  String get list => _list;
  String get nativ => _nativ;
  String get tempus1 => _tempus1;
  String get tempus2 => _tempus2;
  String get tempus3 => _tempus3;
  String get tempus4 => _tempus4;
  String get tempus5 => _tempus5;
  String get tempus6 => _tempus6;
  String get pronom1 => _pronom1;
  String get pronom2 => _pronom2;
  String get pronom3 => _pronom3;
  String get pronom4 => _pronom4;
  String get pronom5 => _pronom5;
  String get pronom6 => _pronom6;


  Words.fromMap(Map<String, dynamic> obj) {
    this._list = obj['list'];
    this._nativ = obj['nativ'];
    this._tempus1 = obj['tempus1'];
    this._tempus2 = obj['tempus2'];
    this._tempus3 = obj['tempus3'];
    this._tempus4 = obj['tempus4'];
    this._tempus5 = obj['tempus5'];
    this._tempus6 = obj['tempus6'];
    this._pronom1 = obj['pronom1'];
    this._pronom2 = obj['pronom2'];
    this._pronom3 = obj['pronom3'];
    this._pronom4 = obj['pronom4'];
    this._pronom5 = obj['pronom5'];
    this._pronom6 = obj['pronom6'];
  }
}
