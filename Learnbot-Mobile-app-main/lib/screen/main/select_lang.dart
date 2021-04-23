import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/display_verb_controller.dart';
import 'package:leanrbot/controller/select_verb_controller.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_verb.dart';

Select_verb_controller _conselect;
Display_verb_controller _condisplay;

class SelectLanguage extends StatefulWidget {

  SelectLanguage(Select_verb_controller _select, Display_verb_controller _display){
    _conselect = _select;
    _condisplay = _display;
  }

  @override
  _SelectLanguage createState() => _SelectLanguage();
}

class _SelectLanguage extends State<SelectLanguage> {

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  static String ids = Config.iapIds[selected_lang];
  static String andids = Config.iapAndroid[selected_lang];

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
    return OrientationBuilder(
      builder: (context, orientation) {
        var _crossAxisSpacing = 10;
        var _screenWidth = mediaquery.size.width;
        var _crossAxisCount = orientation == Orientation.portrait ? 4: 8;
        var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
        var _aspectRatio = 0.8;
        return new Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: colorStyle.primaryColor),
            child: SingleChildScrollView(
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
                          'Select Language',
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
                        child:  SizedBox(
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
                        ),)
                    ],
                  ),
                  GridView.builder(
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10, bottom: 10),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: Config.flag_images.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => new SelectVerb(index)));
                                /*initPlatformState().then((value) {
                                  
                                  if(_conselect ==null && _condisplay == null){
                                    _SubscriptionState(Platform.isIOS ? Config.iapIds[index]: Config.iapAndroid[index]).then((value)  {
                                      print(value);
                                      if(value){
                                        Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => new SelectVerb(index)));
                                      } else{
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Free Mode'),
                                              content: Text('You are using the free mode'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                    Navigator.of(context).push(PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => new SelectVerb(index)));
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
                                  }*/
                                 /* if(_conselect != null){
                                    _SubscriptionState(Platform.isIOS ? Config.iapIds[index]: Config.iapAndroid[index]).then((value)  {
                                      print(value);
                                      if(value){
                                        Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => new SelectVerb(index)));
                                      } else{
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Free Mode'),
                                              content: Text('You are using the free mode'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                    Navigator.of(context).pop(false);
                                                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => new SelectVerb(index)));
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
                                  }
                                })*/

                              },
                              fillColor: Colors.white,
                              child:  CircleAvatar(
                                radius: (_width-20)/2,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/flags/" + Config.flag_images[index]),
                                  radius: (_width-20)/2 -2,
                                ),
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: AutoSizeText(
                                Config.flag_name[index],
                                style: TextStyle(
                                  color: Colors.white,
                                //  fontSize: 12
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                maxFontSize: 35,
                                minFontSize: 7,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
