import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/display_verb_controller.dart';
import 'package:leanrbot/controller/favorite_verb_controller.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

Favoirte_verb_controller _con;

Display_verb_controller con;

int first_lang;



class FavoriteVerb extends StatefulWidget {

  FavoriteVerb(cons,first_langs){
    con = cons;
    first_lang = first_langs;
  }

  @override
  _FavoriteVerb createState() => _FavoriteVerb();
}

class _FavoriteVerb extends StateMVC<FavoriteVerb> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FavoriteVerb() : super(Favoirte_verb_controller(first_lang)) {
    _con = controller;
  }
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  final List<String> _productLists = Platform.isAndroid
      ? [
    'com.iedutainmentsa.german',
    'com.iedutainmentsa.spanish',
    'com.iedutainmentsa.english',
    'com.iedutainmentsa.italian',
    'com.iedutainmentsa.french',
    'com.iedutainmentsa.portuguse',
    'com.iedutainmentsa.russian',
    'com.iedutainmentsa.greek',
    'com.iedutainmentsa.polish',
    'com.iedutainmentsa.norwegan',
    'com.iedutainmentsa.welsh',
    'com.iedutainmentsa.scottish',
    'com.iedutainmentsa.romanian',
    'com.iedutainmentsa.dutch',
    'com.iedutainmentsa.swedish',
    'com.iedutainmentsa.finnish',
    'com.iedutainmentsa.slovak',
    'com.iedutainmentsa.catalan',
    'com.iedutainmentsa.danish',
    'com.iedutainmentsa.galician',
    'com.iedutainmentsa.valencian',
    'com.iedutainmentsa.esperanto',
  ]
      : ['com.onemonth.vpn'];

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
                    'Favourite  Verbs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
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
                      )
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
                        child: ListView.separated(
                          itemCount: _con.search_list.length,
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onLongPress: (){
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Remove'),
                                      content: Text('Do you want to remove this verb from the favourite list?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text('No'),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            _con.removeverb(_con.search_list[index]);
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                if(con != null) con.controller.dispose();
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new DisplayVerb(first_lang, _con.search_list[index].english)));
                              },
                              leading: Icon(Icons.favorite,
                                color: Colors.black,
                              ),
                              title: Text(_con.search_list[index].nativ,),
                              trailing: IconButton(
                                onPressed: (){
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Remove'),
                                        content: Text(' Do you want to remove this verb from the favourite list?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('No'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              _con.removeverb(_con.search_list[index]);
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete_forever, color: Colors.black,),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 1.0,
                            color: Colors.black,
                          ),
                        ),
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
//                                    Navigator.of(context).push(PageRouteBuilder(
//                                        pageBuilder: (_, __, ___) => new SelectLanguage(null, widget.con)));
                                  },
                                  fillColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/flags/" + Config.flag_images[first_lang]),
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
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Enter new verb'),
                                          content:Form(
                                            key: _formKey,
                                            child: TypeAheadFormField(
                                              textFieldConfiguration: TextFieldConfiguration(
                                                decoration: InputDecoration(
                                                  labelText: 'new verb',
                                                  fillColor: Colors.black12,
                                                  filled: true,),
                                                onChanged: (value) {},
                                                controller: _con.newverbcontroller,
                                              ),
                                              hideOnLoading: true,
                                              noItemsFoundBuilder: (context) {
                                                return null;
                                              },
                                              errorBuilder: (context, error) {
                                                return Container();
                                              },
                                              suggestionsCallback: (pattern) {
                                                return _con.getfavoriteverbs(pattern);
                                              },
                                              itemBuilder: (context, suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion.nativ),
                                                );
                                              },
                                              transitionBuilder: (context, suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected: (suggestion) {
                                                _con.newverbcontroller.text = suggestion.nativ;
                                              },
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please type verb';
                                                }
                                                print(_con.checkvalidate(value));
                                                if(!_con.checkvalidate(value)){
                                                  return 'Please type correct verb';
                                                }
                                              },
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('No'),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                if (this._formKey.currentState.validate()) {
                                                  _con.addfavoriteverb();
                                                  Navigator.of(context).pop(false);
                                                }
                                              },
                                              child: Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  fillColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black54,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.add,
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
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  fillColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black54,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.home,
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
