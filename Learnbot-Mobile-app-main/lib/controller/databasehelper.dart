import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/Select_verb_model.dart';
import 'package:leanrbot/model/myverb_model.dart';
import 'package:leanrbot/model/verbs_model.dart';
import 'package:leanrbot/model/words_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableverbs = 'verbs';

  final String tablewords = 'words';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'verbs.sqlite');

    File dbfile = new File(path);

    if(!dbfile.existsSync()) {
      ByteData data = await rootBundle.load("assets/verbs.sqlite");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    var db = await openDatabase(path, version: 1);
    return db;
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  Future<Words> getWords(int index) async{
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from words where lang='${Config.flag_name[index]}'");
    if(result.length > 0){
      return new Words.fromMap(result.first);
    }
    return null;
  }
  Future<Verbs> getVerbs(int index, String engs_name) async{
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from verbs where lang='${Config.flag_code[index]}' and english='${engs_name}'");
    if(result.length > 0){
      return new Verbs.fromMap(result.first);
    }
    return null;
  }
  Future<Words> getsecondWords(int index) async{
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from words where lang='${Config.second_flag_name[index]}'");
    if(result.length > 0){
      return new Words.fromMap(result.first);
    }
    return null;
  }
  Future<Verbs> getsecondVerbs(int index, String engs_name) async{
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from verbs where lang='${Config.second_flag_code[index]}' and english='${engs_name}'");
    if(result.length > 0){
      return new Verbs.fromMap(result.first);
    }
    return null;
  }


  Future<List<Select_Verb_Model>> getselectedVerbs(index, flag) async{
    List<Select_Verb_Model> retun_data = List();
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select english,infinitiv_text from verbs where lang='${Config.flag_code[index]}'");
    if(result.length > 0){
      if(flag){
        for(int i = 0; i < result.length; i++){
          Select_Verb_Model temp = Select_Verb_Model.fromMap(result[i]);
          retun_data.add(temp);
        }
      } else{
        for(int i = 0; i < result.length; i++){
          Select_Verb_Model temp = Select_Verb_Model.fromMap(result[i]);
          if(Config.free_list.contains(temp.english)){
            retun_data.add(temp);
          }
        }
      }
      retun_data.sort((a, b) => a.nativ.compareTo(b.nativ));
      return retun_data;

    }
    return null;
  }

  Future<List<Select_Verb_Model>> getFavoriteVerbs(int first_lang) async{
    List<Select_Verb_Model> retun_data = List();
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select english,infinitiv_text, favorite from verbs where lang='${Config.flag_code[first_lang]}' and favorite=1 ORDER BY infinitiv_text ASC");
    if(result.length > 0){
      for(int i = 0; i < result.length; i++){
        Select_Verb_Model temp = Select_Verb_Model.fromMap(result[i]);
        retun_data.add(temp);
      }
      return retun_data;
    }
    return List();
  }

  Future<void> removefavorite(int first_lang, String search_lists) async{
    var dbClient = await db;
    await dbClient.rawUpdate("update verbs set favorite =0 where lang='${Config.flag_code[first_lang]}' and english ='$search_lists'");
  }

  Future<List<Select_Verb_Model>> getallVerbs(int first_lang, bool flag) async{
    List<Select_Verb_Model> retun_data = List();
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select english,infinitiv_text, favorite from verbs where lang='${Config.flag_code[first_lang]}'");
    if(result.length > 0){
      if(flag){
        for(int i = 0; i < result.length; i++){
          Select_Verb_Model temp = Select_Verb_Model.fromMap(result[i]);
          retun_data.add(temp);
        }
      } else{
        for(int i = 0; i < result.length; i++){
          Select_Verb_Model temp = Select_Verb_Model.fromMap(result[i]);
          if(Config.free_list.contains(temp.english)){
            retun_data.add(temp);
          }
        }
      }

      retun_data.sort((a, b) => a.nativ.compareTo(b.nativ));
      return retun_data;

    }
    return List();
  }

  Future<void> addfavorite(int first_lang, String text) async{
    var dbClient = await db;
    await dbClient.rawUpdate("update verbs set favorite =1 where lang='${Config.flag_code[first_lang]}' and infinitiv_text ='$text'");
  }

  Future<List<MyVerb_Model>> getmyVerbs(int first_lang) async{
    List<MyVerb_Model> retun_data = List();
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from myverbs where lang='${Config.flag_code[first_lang]}' ORDER BY infinitiv_text ASC");
    if(result.length > 0){
      for(int i = 0; i < result.length; i++){
        MyVerb_Model temp = MyVerb_Model.fromMap(result[i]);
        retun_data.add(temp);
      }
      return retun_data;
    }
    return List();
  }
  Future<void> addmyverb(int first_lang, String text) async{
    var dbClient = await db;
    Map<String, dynamic> row = {
      'lang': Config.flag_code[first_lang],
      'infinitiv_text':text,
      'conj1_text':'',
      'conj2_text':'',
      'conj3_text':'',
      'conj4_text':'',
      'conj5_text':'',
      'conj6_text':'',
      'conj7_text':'',
      'conj8_text':'',
      'conj9_text':'',
      'conj10_text':'',
      'conj11_text':'',
      'conj12_text':'',
      'conj13_text':'',
      'conj14_text':'',
      'conj15_text':'',
      'conj16_text':'',
      'conj17_text':'',
      'conj18_text':'',
      'conj19_text':'',
      'conj20_text':'',
      'conj21_text':'',
      'conj22_text':'',
      'conj23_text':'',
      'conj24_text':'',
      'conj25_text':'',
      'conj26_text':'',
      'conj27_text':'',
      'conj28_text':'',
      'conj29_text':'',
      'conj30_text':'',
      'conj31_text':'',
      'conj32_text':'',
      'conj33_text':'',
      'conj34_text':'',
      'conj35_text':'',
      'conj36_text':'',
    };
    int id = await dbClient.insert('myverbs', row);
  }

  Future<void> removemyverb(int first_lang, String infinitiv_text) async{
    var dbClient = await db;
    await dbClient.rawDelete('DELETE FROM myverbs WHERE lang = ? and infinitiv_text = ?', [Config.flag_code[first_lang],infinitiv_text]);
  }

  Future<MyVerb_Model> getmycurrentVerbs(int first_lang, String infinitv_text) async{
    MyVerb_Model retun_data = null;
    var dbclient = await db;
    List<Map> result = await dbclient.rawQuery("select * from myverbs where lang='${Config.flag_code[first_lang]}' and infinitiv_text='${infinitv_text}'");
    if(result.length > 0){
      for(int i = 0; i < result.length; i++){
        retun_data = MyVerb_Model.fromMap(result[0]);
      }
      return retun_data;
    }
    return null;
  }
  Future<void> updatemyverb(int first_lang, String infinitv_text, String string, String value) async{
    var dbClient = await db;
    await dbClient.rawUpdate("update myverbs set conj${string}_text ='${value}' where lang='${Config.flag_code[first_lang]}' and  infinitiv_text='${infinitv_text}'");
  }
}