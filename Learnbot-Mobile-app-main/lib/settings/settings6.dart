import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

int select_index = 0;

class Settings6 extends StatefulWidget {
  Settings6(int select_lang){
    select_index = select_lang;
  }


  @override
  _Settings6 createState() => _Settings6();
}

class _Settings6 extends State<Settings6> {

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;
  static String ids;
  static String allids;
  static String andids;
  static String allandids;
  List<String> _productLists;
  List<String> _allproductLists;


  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<IAPItem> _allitems = [];
  List<PurchasedItem> _purchases = [];
  List<PurchasedItem> _allpurchases = [];
  bool userSubscribed;
  bool allverb;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    allinitPlatformState();
  }
  @override
  void dispose() async{
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }
  Future<void> initPlatformState() async {
   // print(select_index);
    ids = Config.iapIds[select_index];
    andids = Config.iapAndroid[select_index];
    _productLists = Platform.isAndroid
        ? [
      andids
    ]
        : [ids];

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

    _getProduct();
  }
  Future<void> allinitPlatformState() async {
    print(select_index);
    allids = Config.ios_ip;
    andids = Config.and_ip;
    _allproductLists = Platform.isAndroid
        ? [
      allandids
    ]
        : [allids];

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
          //print('connected: $connected');
        });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
          print('purchase-updated: $productItem');
        });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          print('purchase-error: $purchaseError');
        });

    _allgetProduct();
  }
  Widget build(BuildContext context) {
 MediaQueryData mediaquery = MediaQuery.of(context);
    return OrientationBuilder(
      builder: (context, orientation) {

        return new Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            /// Set Background image in splash screen layout (Click to open code)
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(orientation == Orientation.landscape ? 'assets/images/premium.png':'assets/images/premium.png'),
                  fit: BoxFit.fill,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 10,
                   // bottom: 500,
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
                  
                 //  bottom: 100.0 * MediaQuery.of(context).devicePixelRatio,
                    top: MediaQuery.of(context).size.height * 0.43,
                    right: -100,
                    child: Container(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Colors.amber[900],
                              onPressed: (){
                                //Create The Full version button
                                initPlatformState().then((value) {
                                  _SubscriptionState().then((value) {
                                    if ( !value ) {
                                      showCupertinoModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        builder: (context, scrollController) => Material(
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: _renderInApps()),
                                            )),
                                      );

                                    }
                                  });
                                });
                              },
                              child: Text(
                                'BUY NOW >',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                ),
                              ),
                            ),
                            height: 50,
                          ),
                          ],
                      ),
                    ),
                         ),
                         
                          Positioned(
                            right: -90,
                            bottom: 10,
                          child: Container(
                            width: 350,
                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Colors.amber[900],
                              onPressed: (){
                                //Create The Full version button
                                allinitPlatformState().then((value) {
                                  _allSubscriptionState().then((value) {
                                   if ( !value ) {
                                      showCupertinoModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        builder: (context, scrollController) => Material(
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: _allrenderInApps()),
                                            )),
                                      );

                                   }
                                  });
                                });
                              },
                              child: Text(
                                'SUBSCRIBE >',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                ),
                              ),
                            ),
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 40,
                      child: Container(
                           width: mediaquery.size.width,
                          child: GestureDetector(
                            onTap: () {
                              launch("https://www.freeprivacypolicy.com/privacy/view/e8cba42fd68bccc4452a4cfbee060a80");
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(color: Colors.black,  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Positioned(
                      top: 20,
                      child: Container(
                          width: mediaquery.size.width,
                          child: GestureDetector(
                            onTap: () {
                              launch("https://www.termsandconditionsgenerator.com/live.php?token=cfBHHrABkWoyvELjJ4txyYXM4sx2Z4E5");
                            },
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(color: Colors.black,  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                ],
              )
          ),
        );
      },
    );
  }
  List<Widget> _renderInApps() {
    List<Widget> widgets = this
        ._items
        .map((item) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            FlatButton(
              color: Colors.orange,
              onPressed: () {
                print("---------- Buy Item Button Pressed");
                this._requestPurchase(item);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48.0,
                      alignment: Alignment(-1.0, 0.0),
                      child: Text('Your are buying the full verb version', textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ))
        .toList();
    return widgets;
  }
  List<Widget> _allrenderInApps() {
    List<Widget> widgets = this
        ._allitems
        .map((item) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            FlatButton(
              color: Colors.orange,
              //child: Text('FlatButton'),
              onPressed: () {
                print("---------- Buy Item Button Pressed");
                this._requestPurchase(item);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48.0,
                      alignment: Alignment(-1.0, 0.0),
                      child: Text('Your are buying one month of premium version', textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ))
        .toList();
    return widgets;
  }
  Future<bool> _SubscriptionState() async {
    try {
      bool result = await SubcsriptionStatus.subscriptionStatus(
          Platform.isIOS ? ids : andids, const Duration(days: 30), const Duration(days: 0));
      return result;
    } catch (_) {
      return false;
    }
  }
  Future<bool> _allSubscriptionState() async {
    try {
      bool result = await SubcsriptionStatus.subscriptionStatus(
          Platform.isIOS ? allids : allandids, const Duration(days: 30), const Duration(days: 0));
      return result;
    } catch (_) {
      return false;
    }
  }
  Future<void> _requestPurchase(IAPItem item) async {
    try {
      PurchasedItem purchasedItem;
      FlutterInappPurchase.instance
          .requestPurchase(item.productId)
          .then((value) async {
        purchasedItem = value;
        String msg = await FlutterInappPurchase.instance.consumeAllItems;
        //print('consumeAllItems: $msg');
      });
    } catch (e) {
      PlatformException p = e as PlatformException;
      //print(p.code);
      //print(p.message);
      //print(p.details);
    }
  }

  Future _getProduct() async {
    print(_productLists);
    // for android
      //List<IAPItem> items =
     // await FlutterInappPurchase.instance.getProducts(_productLists);
    // for IOs
      List<IAPItem> items =
      await FlutterInappPurchase.instance.getProducts(_productLists);
      print(ids);
    //ios
    List<IAPItem> iaaa= [];
    for (var item in items) {
    print('${item.toString()}');
    if(item.productId == ids){
      iaaa.add(item);
     }
    }
//
    //android
   // List<IAPItem> iaaa= [];
    //for (var item in items) {
    //print('${item.toString()}');
    //if(item.productId == andids){
     //   iaaa.add(item);
      //}
  // }
    setState(() {
      this._items = iaaa;
      this._purchases = [];
    });
  }
  Future _allgetProduct() async {
    print(_productLists);
    // for android
    //List<IAPItem> items =
    //await FlutterInappPurchase.instance.getProducts(_productLists);
    // for IOs
    List<IAPItem> items =
    await FlutterInappPurchase.instance.getProducts(_allproductLists);
    print(ids);
    //ios
    List<IAPItem> iaaa= [];
    for (var item in items) {
     // print('${item.toString()}');
      if(item.productId == allids){
       iaaa.add(item);
     }
    }
//
    //android
  // List<IAPItem> iaaa= [];
  //  for (var item in items) {
   //  print('${item.toString()}');
    // if(item.productId == allandids){
     // iaaa.add(item);
   // }
  //}
    setState(() {
      this._allitems = iaaa;
      this._allpurchases = [];
    });
  }
}
