import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/display_verb_controller.dart';
import 'package:leanrbot/controller/favorite_verb_controller.dart';
import 'package:leanrbot/controller/myverbs_controller.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:leanrbot/screen/myverbs/add_new_verb.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

my_verb_controller _con;


int first_lang;
int second_lang;


class MyVerbs extends StatefulWidget {

  MyVerbs(first_langs, second_langs){
    first_lang = first_langs;
    second_lang = second_langs;
  }

  @override
  _MyVerbs createState() => _MyVerbs();
}

class _MyVerbs extends StateMVC<MyVerbs> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _MyVerbs() : super(my_verb_controller(first_lang)) {
    _con = controller;
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
                    'My  Verbs',
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
            Padding(
              padding: EdgeInsets.all(5),
                  child: Text(
                    """Upload your own verbs,
conjugations and even pictures!""",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                       fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                        padding: EdgeInsets.only(top: 8, bottom: 8),
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
                                    content: Text('Do you want to remove this verb from My Verbs list?'),
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
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new AddVerb(_con.first_lang, _con.search_list[index].infinitiv_text)));
                            },
                            title: Text(_con.search_list[index].infinitiv_text,
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              onPressed: (){
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Remove'),
                                      content: Text('Do you want to remove this verb from My Verbs list?'),
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
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Enter new verb'),
                                        content:Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'new verb',
                                              fillColor: Colors.black12,
                                              filled: true,),
                                            onChanged: (value) {},
                                            controller: _con.newverbcontroller,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please type verb';
                                              }
                                              print(_con.checkvalidate(value));
                                              if(_con.checkvalidate(value)){
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
                                                _con.addmyverb();
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
