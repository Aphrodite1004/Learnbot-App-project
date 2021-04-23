

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/Select_verb_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class Select_verb_controller extends ControllerMVC{

  int first_lang = 0, second_lang = 0;
  List<Select_Verb_Model> verb_list, search_list;


  Select_verb_controller(int selected_lang){
    first_lang = second_lang = selected_lang;
    verb_list = List();
    search_list = List();

    set_select_verb_list();
  }
  Future<bool> _SubscriptionState(String iapId) async {
    print(iapId);
    try {
      bool result = await SubcsriptionStatus.subscriptionStatus(
          iapId, const Duration(days: 30), const Duration(days: 0));
      return result;
    } catch (_) {
      return false;
    }
  }
  void set_select_verb_list() async{
      var dbHelper = Config.databasehelper;

      _SubscriptionState(Platform.isIOS ? Config.iapIds[first_lang]: Config.iapAndroid[first_lang]).then((value) {
        print(value);
        dbHelper.getselectedVerbs(first_lang, value).then((value) {
          verb_list = value;
          setState((){
            search_list = value;
          });
        });
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

  void setlanguage(int index) {
    first_lang = index;
    set_select_verb_list();
    setState((){

    });
  }

  void setsecondlanugage(int index) {
    second_lang = index;
  }


}