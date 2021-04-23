import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/select_verb_controller.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/favorite_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:leanrbot/screen/main/setting.dart';
import 'package:leanrbot/screen/myverbs/myverbs.dart';
import 'package:leanrbot/settings/settings6.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

int select_lang;
Select_verb_controller _con;

class SelectVerb extends StatefulWidget {


  SelectVerb(int lang){
    select_lang = lang;
  }

  @override
  _SelectVerb createState() => _SelectVerb();
}

class _SelectVerb extends StateMVC<SelectVerb> {

  _SelectVerb() : super(Select_verb_controller(select_lang)) {
    _con = controller;
  }
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;


  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  bool userSubscribed;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
          print('connected: $connected');
        });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
          print('purchase-updated: $productItem');
        });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          print('purchase-error: $purchaseError');
        });

  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    // TODO: implement build
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: colorStyle.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: mediaquery.padding.top + 10,
            ),
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${Config.flag_name[_con.first_lang]}  Verbs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  alignment: Alignment.center,
                ),
                Positioned(
                  right: 10,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/assets_icons_prev.png',
                          width: 40,
                        ),
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        showDialog(
          context: context,
          builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Buy Full Version'),
                            content: Text('Unlock all verbs for the selected language'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => Settings6(select_lang)));
                                },
                                child: Text('OK'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/robot.png',
                          width: 40,
                        ),
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30, left: 10, top: 10, right: 10),
              child:new Theme(
                data: new ThemeData(
                  primaryColor: Colors.white,
                  primaryColorDark: Colors.white,
                ),
                child: new  TextField(
                  decoration: InputDecoration(
                      border:  new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                          color: Colors.white
                      ),
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white38,
                      filled: true,
                      prefixIcon:Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                  ),
                  onChanged: (value){
                    _con.search(value);
                  },
                ),
              ),

            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 50),
                      child: _con.search_list != null ? ListView.separated(
                        itemCount: _con.search_list.length,
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: (){
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new DisplayVerb(_con.first_lang, _con.search_list[index].english)));
                            },
                            title: Text(_con.search_list[index].nativ,
                            textAlign: TextAlign.center,),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1.0,
                          color: Colors.black,
                        ),
                      ) : Container(),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Container(
                        width: mediaquery.size.width,
                        padding: EdgeInsets.only( right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => new SelectLanguage(_con, null)));
                                },
                                fillColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/flags/" + Config.flag_images[_con.first_lang]),
                                    radius: 18,
                                  ),
                                ),
                                shape: CircleBorder(),
                                elevation: 2.0,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                          new FavoriteVerb(null,
                                              _con.first_lang)));
                                },
                                fillColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black54,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.favorite,
                                      color: Colors.black54,
                                      size: 30,),
                                    radius: 18,
                                  ),
                                ),
                                shape: CircleBorder(),
                                elevation: 2.0,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => new MyVerbs(_con.first_lang, _con.second_lang)));
                                },
                                fillColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black54,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.add_box,
                                      color: Colors.black54,
                                      size: 30,),
                                    radius: 18,
                                  ),
                                ),
                                shape: CircleBorder(),
                                elevation: 2.0,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => new Setting(_con.first_lang, _con)));
                                },
                                fillColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black54,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.settings,
                                      color: Colors.black54,
                                      size: 30,),
                                    radius: 18,
                                  ),
                                ),
                                shape: CircleBorder(),
                                elevation: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
