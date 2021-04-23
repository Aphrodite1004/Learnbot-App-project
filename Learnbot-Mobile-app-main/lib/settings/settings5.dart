import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

int select_index = 0;

class Settings5 extends StatefulWidget {
  Settings5(int select_lang){
    select_index = select_lang;
  }


  @override
  _Settings5 createState() => _Settings5();
}

class _Settings5 extends State<Settings5> {

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

    _getPurchases();
  }
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {

        return new Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            /// Set Background image in splash screen layout (Click to open code)
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(orientation == Orientation.landscape ? 'assets/images/landscape_splash.png':'assets/images/landingpage_splash.png'),
                  fit: BoxFit.fill,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 10,
                    top: MediaQuery.of(context).padding.top,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
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
                    bottom: orientation == Orientation.portrait?  100 : 20,
                    right: MediaQuery.of(context).size.width/2 -175,
                    child: Container(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Colors.grey,
                              onPressed: (){
                                if(_purchases.length != 0){
                                  showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    builder: (context, scrollController) => Material(
                                        child: SafeArea(
                                          top: false,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: _renderPurchases()),
                                        )),
                                  );
                                } else {
                                  AlertDialog(
                                    title: Text('Notification'),
                                    content: Text('No purchases for restore'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                }

                              },
                              child: Text(
                                'Restore Purchase',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                            ),
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        );
      },
    );
  }
  List<Widget> _renderPurchases() {
    List<Widget> widgets = this
        ._purchases
        .map((item) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                item.productId,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    ))
        .toList();
    return widgets;
  }
  Future _getPurchases() async {
    List<PurchasedItem> items =
    await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }
}
