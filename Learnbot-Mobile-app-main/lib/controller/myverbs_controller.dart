

import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/Select_verb_model.dart';
import 'package:leanrbot/model/myverb_model.dart';
import 'package:leanrbot/screen/myverbs/add_new_verb.dart';
import 'package:leanrbot/screen/myverbs/myverbs.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class my_verb_controller extends ControllerMVC{

  int first_lang = 0;
  List<MyVerb_Model> verb_list, search_list;
  TextEditingController newverbcontroller;

  my_verb_controller(int selected_lang){

    newverbcontroller = TextEditingController();
    first_lang = selected_lang;
    verb_list = List();
    search_list = List();
    set_select_verb_list();
  }

  void set_select_verb_list() async{
    var dbHelper = Config.databasehelper;
    List temp = await dbHelper.getmyVerbs(first_lang);
    verb_list = temp;
    setState((){
      search_list = temp;
    });
  }

  void search(String value) {
    search_list = List();
    if(value.length == 0){
      search_list.addAll(verb_list);
    } else{
      for(var i = 0; i < verb_list.length; i++){
        if(verb_list[i].infinitiv_text.toLowerCase().contains(value.toLowerCase())){
          search_list.add(verb_list[i]);
        }
      }
    }
    setState((){

    });
  }

  void removeverb(MyVerb_Model search_lists) async {
    var dbHelper = Config.databasehelper;
    await dbHelper.removemyverb(first_lang, search_lists.infinitiv_text);
    List temp = await dbHelper.getmyVerbs(first_lang);
    verb_list = temp;
    setState((){
      search_list = temp;
    });
  }


  bool checkvalidate(String values) {
    bool return_data = false;
    for(int i = 0; i < verb_list.length ; i++){
      if(verb_list[i].infinitiv_text.toLowerCase() == values.toLowerCase()){
        return_data = true;
      }
    }
    return return_data;
  }

  void addmyverb() async{
    var dbHelper = Config.databasehelper;
    await dbHelper.addmyverb(first_lang, newverbcontroller.text);
    List temp = await dbHelper.getmyVerbs(first_lang);
    verb_list = temp;
    setState((){
      search_list = temp;
    });
    Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new AddVerb(first_lang, newverbcontroller.text)));
  }

}