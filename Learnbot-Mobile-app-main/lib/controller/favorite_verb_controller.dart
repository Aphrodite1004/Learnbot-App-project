

import 'package:flutter/material.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/Select_verb_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:io';

class Favoirte_verb_controller extends ControllerMVC{

  int first_lang = 0;
  List<Select_Verb_Model> verb_list, search_list, allverb_list;
  TextEditingController newverbcontroller;

  Favoirte_verb_controller(int selected_lang){
    newverbcontroller = TextEditingController();
    first_lang = selected_lang;
    verb_list = List();
    search_list = List();
    allverb_list = List();
    set_select_verb_list();
    getall_verbs();
  }

  void set_select_verb_list() async{
    var dbHelper = Config.databasehelper;
    List temp = await dbHelper.getFavoriteVerbs(first_lang);
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
        if(verb_list[i].nativ.toLowerCase().contains(value.toLowerCase())){
          search_list.add(verb_list[i]);
        }
      }
    }
    setState((){

    });
  }

  void removeverb(Select_Verb_Model search_lists) async {
    var dbHelper = Config.databasehelper;
    await dbHelper.removefavorite(first_lang, search_lists.english);
    List temp = await dbHelper.getFavoriteVerbs(first_lang);
    verb_list = temp;
    setState((){
      search_list = temp;
    });
  }

  List<Select_Verb_Model> getfavoriteverbs(String pattern) {
    List<Select_Verb_Model> matches = List();
    matches.addAll(allverb_list);

    matches.retainWhere((s) => s.nativ.toLowerCase().contains(pattern.toLowerCase()));
    return matches;
  }

  Future<void> getall_verbs() async {
    var dbHelper = Config.databasehelper;

    _SubscriptionState(Platform.isIOS ? Config.iapIds[first_lang]: Config.iapAndroid[first_lang]).then((value) {
      dbHelper.getallVerbs(first_lang, value).then((value){
        allverb_list = value;
      });
    });

  }

  bool checkvalidate(String values) {
    bool return_data = false;
    for(int i = 0; i < allverb_list.length ; i++){
      if(allverb_list[i].nativ == values){
        return_data = true;
      }
    }
    return return_data;
  }

  void addfavoriteverb() async{
    var dbHelper = Config.databasehelper;
    await dbHelper.addfavorite(first_lang, newverbcontroller.text);
    List temp = await dbHelper.getFavoriteVerbs(first_lang);
    verb_list = temp;
    setState((){
      search_list = temp;
    });
  }
  Future<bool> _SubscriptionState(String iapId) async {
    try {
      bool result = await SubcsriptionStatus.subscriptionStatus(
          iapId, const Duration(days: 30), const Duration(days: 0));
      return result;
    } catch (_) {
      return false;
    }
  }
}