import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/add_verb_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_view_indicator/page_view_indicator.dart';

Add_verb_controller _con;
int selected_lang;
String infinitv_text;
int item_count = 0;

class AddVerb extends StatefulWidget {
  AddVerb(int lang_index, String infiniv) {
    selected_lang = lang_index;
    infinitv_text = infiniv;
  }

  @override
  _AddVerb createState() => _AddVerb();
}

class _AddVerb extends StateMVC<AddVerb> with TickerProviderStateMixin {



  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  bool hidden_verb = false;

  _AddVerb()
      : super(Add_verb_controller(selected_lang, infinitv_text)) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if( selected_lang == 6 || selected_lang == 8 || selected_lang == 16 ){
      item_count = 5;
    } else{
      item_count = 6;
    }
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

  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    animation.dispose();
    super.dispose();
  }

  final pageIndexNotifier = ValueNotifier<int>(0);
  final _pageController = PageController();

  MediaQueryData mediaquery;

  @override
  Widget build(BuildContext context) {
    mediaquery = MediaQuery.of(context);

    // TODO: implement build
    return new Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      !_con.image_selected ? SingleChildScrollView(
                          child: Container(
                            width: mediaquery.size.width,
                            height: mediaquery.size.height / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  infinitv_text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 70,
                                  width: 70,
                                  child: FloatingActionButton(
                                      heroTag: UniqueKey(),
                                      splashColor: Colors.grey,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        _con.selectimage(context);
                                      }),
                                ),
                              ],
                            ),
                          )
                      ) :
                          Container(
                            child: Image.memory(
                              Uint8List.fromList(File(_con.image_path).readAsBytesSync()),
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.fill,
                            ),

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
                                  fontSize: 50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: mediaquery.padding.top,
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
                      ),
                      Visibility(
                        visible: _con.image_selected,
                        child: Positioned(
                          bottom: 20,
                          child: Container(
                            width: mediaquery.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    color: Colors.grey,
                                    onPressed: (){
                                      _con.selectimage(context);
                                    },
                                    child: Text(
                                      'Change Image',
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                ),
                                SizedBox(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    color: Colors.grey,
                                    onPressed: (){
                                      _con.deleteimage(context);
                                    },
                                    child: Text(
                                      'Remove Image',
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                )
                              ],
                            ),
                          )
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: RawMaterialButton(
                              onPressed: () {
                              },
                              fillColor: Colors.white,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/flags/" +
                                          Config.flag_images[
                                          _con.first_lang]),
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
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  hidden_verb = !hidden_verb;
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
                        return _getSlidefirst(index);
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
                                    _con.change_tempus(pageIndexNotifier.value - 1);
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
                                  if (pageIndexNotifier.value < item_count - 1) {
                                    _con.change_tempus(pageIndexNotifier.value + 1);
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
          )),
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
                              _con.pronoum_current[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 35,
                              minFontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Visibility(
                                visible: !hidden_verb,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25
                                    ),
                                    onChanged: (value){
                                      _con.updateverb(value, i, index);
                                    },
                                    focusNode: _con.myFocusNode[i][index],
                                    controller: _con.addverb_controller[i][index],
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding:
                                        EdgeInsets.only(left: 5, top: 5, bottom:5 ,right: 5),),
                                  ),
                                ))),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Image.asset('assets/images/tool/assets_icons_audio_play.png',
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

}
