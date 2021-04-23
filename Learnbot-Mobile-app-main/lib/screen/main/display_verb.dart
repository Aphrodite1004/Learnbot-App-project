import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/display_verb_controller.dart';
import 'package:leanrbot/screen/main/display_video.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:leanrbot/screen/main/favorite_verb.dart';
import 'package:leanrbot/settings/settings6.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_flip_view/flutter_flip_view.dart';

Display_verb_controller _con;
int selected_lang;
String engs_name;
int item_count = 0;

class DisplayVerb extends StatefulWidget {
  DisplayVerb(int lang_index, String eng_name) {
    selected_lang = lang_index;
    engs_name = eng_name;
  }

  @override
  _DisplayVerb createState() => _DisplayVerb();
}
const String testDevice = 'YOUR_DEVICE_ID';
class _DisplayVerb extends StateMVC<DisplayVerb> with  TickerProviderStateMixin{
  AnimationController animation;
  Animation<double> _fadeInFadeOut;
  AnimationController _animationController;
  Animation<double> _curvedAnimation;

  bool hidden_verb = false;

  static String ids = Config.iapIds[selected_lang];
  static String allids = Config.ios_ip;
  static String andids = Config.iapAndroid[selected_lang];
  static String allandids = Config.and_ip;
  String _platformVersion = 'Unknown';
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  _DisplayVerb() : super(Display_verb_controller(selected_lang, engs_name)) {
    _con = controller;
  }

  int selected_i = -1;
  int selected_j = -1;

  int selected_ii = -1;
  int selected_jj = -1;

  bool eu_flag = false;

  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-7389710780633161/4381620648",
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show(
              anchorType: AnchorType.top
            );
          }
        });
  }


  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    if (selected_lang == 6 || selected_lang == 8 || selected_lang == 16) {
      item_count = 5;
    } else {
      item_count = 6;
    }
    if( selected_lang == 6 || selected_lang == 8 || selected_lang == 10 || selected_lang == 11 || selected_lang == 13 || selected_lang == 16 || selected_lang == 21 || selected_lang == 19){
      eu_flag = false;
    } else{
      eu_flag = true;
    }
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      }
    });
    animation.forward();

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
    _SubscriptionState().then((value) {
    /* if ( !value ) {
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
                        builder: (context) => Settings6(selected_lang)));
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
      }*/
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    animation.dispose();
    super.dispose();
    if (_con.controller != null) {
      _con.controller.dispose();
    }
    myBanner.dispose();
  }
  void _flip(bool reverse) {
    if (_animationController.isAnimating) return;
    if (reverse) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  final pageIndexNotifier = ValueNotifier<int>(0);
  final _pageController = PageController();

  MediaQueryData mediaquery;

  @override
  Widget build(BuildContext context) {
    mediaquery = MediaQuery.of(context);

    // TODO: implement build
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_con.controller != null && orientation == Orientation.landscape) {
          if (_con.controller.value.isPlaying) {
            _con.controller.seekTo(_con.controller.value.duration);
          }
        }
        if(orientation == Orientation.portrait){
          selected_ii = -1;
          selected_jj = -1;
        }
        if(orientation == Orientation.landscape){
          selected_i = -1;
          selected_j = -1;
        }
        return new Scaffold(
          body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: orientation == Orientation.portrait
                      ? colorStyle.primaryColor
                      : Colors.white),
              child: orientation == Orientation.portrait
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black,
                            child: Stack(
                              children: <Widget>[
                                Visibility(
                                  visible: !_con.play_video,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: _con.image_path.length == 0
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Image.file(
                                            File(_con.image_path),
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                                Visibility(
                                  visible: _con.play_video,
                                  child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: _con.controller != null
                                          ? (_con.controller.value.initialized
                                              ? VideoPlayer(_con.controller)
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ))
                                          : Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(
                                      top: mediaquery.padding.top),
                                  child: FadeTransition(
                                    opacity: _fadeInFadeOut,
                                    child: Container(
                                      child: Text(
                                        _con.tempus_value,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 1,
                                  top: mediaquery.padding.top,
                                  bottom: 90,
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
                                          color: Colors.black54,
                                        ),
                                      ),
                                      shape: CircleBorder(),
                                      elevation: 2.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: eu_flag ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          _flip(!_con.change_lang_flag);
                                          _con.change_flag();
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/flags/" +
                                                    (!_con.change_lang_flag ? Config.flag_images[_con.first_lang] : Config.flag_images[_con.second_lang])),
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
                                          if (_con.controller != null) {
                                            if (_con
                                                .controller.value.isPlaying) {
                                              _con.controller.seekTo(_con
                                                  .controller.value.duration);
                                            }
                                          }
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                  new SelectTranslateLanguage(
                                                      _con, null)));
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(
                                              "assets/images/tool/assets_icons_star.png"),
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
                                          setState(() {
                                            hidden_verb = !hidden_verb;
                                            selected_i = -1;
                                            selected_j = -1;
                                            selected_ii = -1;
                                            selected_jj = -1;
                                          });
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              hidden_verb
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
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
                                          if (_con.controller != null) {
                                            if(_con.controller.value != null){
                                              if (_con.controller.value.duration
                                                  .inSeconds ==
                                                  _con.controller.value.position
                                                      .inSeconds) {
                                                setState(() {
                                                  _con.play_video = true;
                                                  _con.controller
                                                      .seekTo(Duration.zero);
                                                  _con.controller.play();
                                                });
                                              }
                                              if (!_con
                                                  .controller.value.isPlaying) {
                                                setState(() {
                                                  _con.play_video = true;
                                                  _con.controller.play();
                                                });
                                              }
                                            }
                                          }
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
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
                                          if (_con.controller != null) {
                                            if (_con
                                                .controller.value.isPlaying) {
                                              _con.controller.seekTo(_con
                                                  .controller.value.duration);
                                            }
                                          }
                                          _con
                                              .addingfavoriteverb()
                                              .then((value) {
                                            Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                    new FavoriteVerb(_con,
                                                        _con.first_lang)));
                                          });
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.black54,
                                            ),
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
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon( Icons.menu,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
                                            radius: 18,
                                          ),
                                        ),
                                        shape: CircleBorder(),
                                        elevation: 2.0,
                                      ),
                                    ),
                                  ],
                                ): Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          _flip(!_con.change_lang_flag);
                                          _con.change_flag();
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/flags/" + (!_con.change_lang_flag ? Config.flag_images[_con.first_lang] : Config.flag_images[_con.second_lang])),
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
                                          setState(() {
                                            hidden_verb = !hidden_verb;
                                            selected_i = -1;
                                            selected_j = -1;
                                            selected_ii = -1;
                                            selected_jj = -1;
                                          });
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              hidden_verb
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
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
                                          if (_con.controller != null && _con.controller.value.initialized) {
                                            if(_con.controller.value != null){
                                              if (_con.controller.value.duration
                                                  .inSeconds ==
                                                  _con.controller.value.position
                                                      .inSeconds) {
                                                setState(() {
                                                  _con.play_video = true;
                                                  _con.controller
                                                      .seekTo(Duration.zero);
                                                  _con.controller.play();
                                                });
                                              }
                                              if (!_con
                                                  .controller.value.isPlaying) {
                                                setState(() {
                                                  _con.play_video = true;
                                                  _con.controller.play();
                                                });
                                              }
                                            }
                                          }
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
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
                                          if (_con.controller != null) {
                                            if (_con
                                                .controller.value.isPlaying) {
                                              _con.controller.seekTo(_con
                                                  .controller.value.duration);
                                            }
                                          }
                                          _con
                                              .addingfavoriteverb()
                                              .then((value) {
                                            Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                    new FavoriteVerb(_con,
                                                        _con.first_lang)));
                                          });
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.black54,
                                            ),
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
                                        },
                                        fillColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon( Icons.menu,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
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
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: mediaquery.size.height / 2,
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              PageView.builder(
                                onPageChanged: (index) => {
                                  animation.forward(),
                                  pageIndexNotifier.value = index,
                                  _con.change_tempus(index),
                                },
                                itemCount: item_count,
                                controller: _pageController,
                                itemBuilder: (context, index) {
                                  return FlipView(
                                      front: _getSlidefirst(index),
                                      back: _getSlidesecond(index),
                                      animationController: _curvedAnimation);
                                },
                              ),
                              Positioned(
                                  bottom: 10,
                                  child: Container(
                                    width: mediaquery.size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Icon(
                                            Icons.arrow_left,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            if (pageIndexNotifier.value > 0) {
                                              _con.change_tempus(
                                                  pageIndexNotifier.value - 1);
                                              _pageController.jumpToPage(
                                                  pageIndexNotifier.value - 1);
                                            }
                                          },
                                        ),
                                        pagination(),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.arrow_right,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            if (pageIndexNotifier.value <
                                                item_count - 1) {
                                              _con.change_tempus(
                                                  pageIndexNotifier.value + 1);
                                              _pageController.jumpToPage(
                                                  pageIndexNotifier.value + 1);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: mediaquery.padding.top),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 60,
                                          right: 60,
                                        ),
                                        child: eu_flag ? Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  _flip(!_con.change_lang_flag);
                                                  _con.change_flag();
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.black,
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "assets/images/flags/" +(!_con.change_lang_flag ? Config.flag_images[_con.first_lang] : Config.flag_images[_con.second_lang])),
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
                                                          pageBuilder: (_, __,
                                                              ___) =>
                                                          new SelectTranslateLanguage(
                                                              _con, null)));
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.black,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/tool/assets_icons_star.png"),
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
                                                  setState(() {
                                                    hidden_verb = !hidden_verb;
                                                    selected_i = -1;
                                                    selected_j = -1;
                                                    selected_ii = -1;
                                                    selected_jj = -1;
                                                  });
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      hidden_verb
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.black54,
                                                      size: 30,
                                                    ),
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
                                                  if (_con.video_path != null &&
                                                      _con.image_path != null) {
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (_, __,
                                                                ___) =>
                                                            new DisplayVideo(
                                                                _con.video_path,
                                                                _con.image_path,
                                                                _con.infitiv_text)));
                                                  }
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.black54,
                                                      size: 30,
                                                    ),
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
                                                  _con
                                                      .addingfavoriteverb()
                                                      .then((value) {
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (_, __,
                                                                ___) =>
                                                            new FavoriteVerb(
                                                                _con,
                                                                _con.first_lang)));
                                                  });
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.black54,
                                                    ),
                                                    radius: 18,
                                                  ),
                                                ),
                                                shape: CircleBorder(),
                                                elevation: 2.0,
                                              ),
                                            ),
                                          ],
                                        ):Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  _flip(!_con.change_lang_flag);
                                                  _con.change_flag();
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.black,
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "assets/images/flags/" +(!_con.change_lang_flag ? Config.flag_images[_con.first_lang] : Config.flag_images[_con.second_lang])),
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
                                                  setState(() {
                                                    hidden_verb = !hidden_verb;
                                                    selected_i = -1;
                                                    selected_j = -1;
                                                    selected_ii = -1;
                                                    selected_jj = -1;
                                                  });
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      hidden_verb
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.black54,
                                                      size: 30,
                                                    ),
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
                                                  if (_con.video_path != null &&
                                                      _con.image_path != null) {
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (_, __,
                                                                ___) =>
                                                            new DisplayVideo(
                                                                _con.video_path,
                                                                _con.image_path,
                                                                _con.infitiv_text)));
                                                  }
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.black54,
                                                      size: 30,
                                                    ),
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
                                                  _con
                                                      .addingfavoriteverb()
                                                      .then((value) {
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (_, __,
                                                                ___) =>
                                                            new FavoriteVerb(
                                                                _con,
                                                                _con.first_lang)));
                                                  });
                                                },
                                                fillColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                  Colors.black54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.black54,
                                                    ),
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
                                    ],
                                  ),
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
                                          color: Colors.black54,
                                        ),
                                      ),
                                      shape: CircleBorder(),
                                      elevation: 2.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 7,
                              child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: FlipView(
                                      front: _getlandscapefirst(),
                                      back: _getlandscapesecond(),
                                      animationController: _curvedAnimation))),
                        ],
                      ),
                    )),
        );
      },
    );
  }

  PageViewIndicator pagination() {
    return PageViewIndicator(
      pageIndexNotifier: pageIndexNotifier,
      length: item_count,
      indicatorPadding: EdgeInsets.only(left: 2, right: 2),
      normalBuilder: (animationController, index) => GestureDetector(
        child: Circle(
          size: 12.0,
          color: Colors.white,
        ),
        onTap: () {
          _con.change_tempus(index);
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
          scale: CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
          child: Icon(
            Icons.panorama_fish_eye,
            color: Colors.white,
          )),
    );
  }

  Widget _getSlidefirst(int i) {
    return new Container(
        padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
        color: colorStyle.colortheme[i],
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            for (int index = 0; index < 6; index++)
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    _con.playaudio(i, index);
                    selected_i = i;
                    selected_j = index;
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5))),
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              _con.pronoum_first[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              minFontSize: 15,
                              maxFontSize: 35,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: (i == selected_i && index == selected_j)?
                            Visibility(
                                visible: true,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    _con.verb_data_first[i][index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                    maxFontSize: 35,
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ))
                            :Visibility(
                                visible: !hidden_verb,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    _con.verb_data_first[i][index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                    maxFontSize: 35,
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ))
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                !_con.audio_flags[i][index]
                                    ? 'assets/images/tool/assets_icons_audio_play.png'
                                    : 'assets/images/tool/assets_icons_audio_playing.png',
                                height: 35,
                                fit: BoxFit.fitHeight,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )
          ],
        ));
  }
  Widget _getSlidesecond(int i) {
    return new Container(
        padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
        color: colorStyle.colortheme[i],
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            for (int index = 0; index < 6; index++)
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    _con.playaudio(i, index);
                    selected_i = i;
                    selected_j = index;
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5))),
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              _con.pronoum_second[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              minFontSize: 15,
                              maxFontSize: 35,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: (i == selected_i && index == selected_j)?
                            Visibility(
                                visible: true,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    _con.verb_data_second[i][index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                    maxFontSize: 35,
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ))
                            :Visibility(
                                visible: !hidden_verb,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    _con.verb_data_second[i][index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                    maxFontSize: 35,
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ))
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                !_con.audio_flags[i][index]
                                    ? 'assets/images/tool/assets_icons_audio_play.png'
                                    : 'assets/images/tool/assets_icons_audio_playing.png',
                                height: 35,
                                fit: BoxFit.fitHeight,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )
          ],
        ));
  }

  Widget _getlandscapefirst() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 80,
                    child: Image.asset(
                      'assets/images/tool/assets_icons_audio_play.png',
                      height: 35,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                for (int j = 0; j < item_count; j++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        _con.tempus_data_fist[j],
                        style: TextStyle(color: Colors.black, 
                        //fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                        maxFontSize: 30,
                        minFontSize: 5,
                        maxLines: 3,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (var title in _con.pronoum_first)
                          Expanded(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  title,
                                  style: TextStyle(
                                      color: Colors.black, 
                                      //fontSize: 15
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  minFontSize: 5,
                                  maxFontSize: 30,
                                )),
                          )
                      ],
                    ),
                  ),
                ),
                for (int i = 0; i < item_count; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: <Widget>[
                          for (int j = 0; j < 6; j++)
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    _con.playaudio(i, j);
                                    selected_ii = i;
                                    selected_jj = j;
                                    setState(() {});
                                  },
                                  child: Container(
                                      color: colorStyle.colortheme[i],
                                      margin: EdgeInsets.all(1),
                                      padding: EdgeInsets.all(5),
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child:(selected_ii == i && selected_jj == j)? Visibility(
                                        visible: true,
                                        child: AutoSizeText(
                                          _con.verb_data_first[i][j],
                                          style: TextStyle(
                                              color: Colors.black,
                                              //fontSize: 15
                                              ),
                                          textAlign: TextAlign.center,
                                          maxFontSize: 30,
                                          minFontSize: 5,
                                          maxLines: 3,
                                        ),
                                      ): Visibility(
                                        visible: !hidden_verb,
                                        child: AutoSizeText(
                                          _con.verb_data_first[i][j],
                                          style: TextStyle(
                                              color: Colors.black,
                                              //fontSize: 15
                                              ),
                                          textAlign: TextAlign.center,
                                          maxFontSize: 30,
                                          minFontSize: 5,
                                          maxLines: 3,
                                        ),
                                      )
                                  ),
                                ))
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget _getlandscapesecond() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 80,
                    child: Image.asset(
                      'assets/images/tool/assets_icons_audio_play.png',
                      height: 35,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                for (int j = 0; j < item_count; j++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        _con.tempus_data_second[j],
                        style: TextStyle(color: Colors.black,
                        //fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                        maxFontSize: 30,
                        minFontSize: 5,
                        maxLines: 3,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (var title in _con.pronoum_second)
                          Expanded(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      //fontSize: 15
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  minFontSize: 5,
                                  maxFontSize: 30,
                                )),
                          )
                      ],
                    ),
                  ),
                ),
                for (int i = 0; i < item_count; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: <Widget>[
                          for (int j = 0; j < 6; j++)
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    _con.playaudio(i, j);
                                    selected_ii = i;
                                    selected_jj = j;
                                    setState(() {});
                                  },
                                  child: Container(
                                      color: colorStyle.colortheme[i],
                                      margin: EdgeInsets.all(1),
                                      padding: EdgeInsets.all(5),
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child:(selected_ii == i && selected_jj == j)? Visibility(
                                        visible: true,
                                        child: AutoSizeText(
                                          _con.verb_data_second[i][j],
                                          style: TextStyle(
                                              color: Colors.black,
                                              //fontSize: 15
                                              ),
                                          textAlign: TextAlign.center,
                                          maxFontSize: 30,
                                          minFontSize: 5,
                                          maxLines: 3,
                                        ),
                                      ): Visibility(
                                        visible: !hidden_verb,
                                        child: AutoSizeText(
                                          _con.verb_data_second[i][j],
                                          style: TextStyle(
                                              color: Colors.black,
                                              //fontSize: 15
                                              ),
                                          textAlign: TextAlign.center,
                                          maxFontSize: 30,
                                          minFontSize: 5,
                                          maxLines: 3,
                                        ),
                                      )
                                  ),
                                ))
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
  Future<bool> _SubscriptionState() async {
    bool result1;
    try{
      result1 = await SubcsriptionStatus.subscriptionStatus(
          Platform.isIOS ? ids : andids, const Duration(days: 30), const Duration(days: 0));
    } catch(_){
      result1 = false;
    }
    if(result1) return true;
    //android ca-app-pub-7389710780633161~2110680526
    //IOS ca-app-pub-7389710780633161/1947028993
    //Android ca-app-pub-7389710780633161/4381620648
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-7389710780633161~2110680526");
    myBanner = buildBannerAd()..load();
    try {
      bool result = await SubcsriptionStatus.subscriptionStatus(
          Platform.isIOS ? ids : andids, const Duration(days: 30), const Duration(days: 0));
      return result;
    } catch (_) {
      return false;
    }
  }
}
