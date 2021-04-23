import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/display_verb_controller.dart';
import 'package:leanrbot/controller/select_verb_controller.dart';

class SelectTranslateLanguage extends StatefulWidget {
  Display_verb_controller con;
  Select_verb_controller conselect;

  SelectTranslateLanguage(this.con, this.conselect);

  @override
  _SelectTranslateLanguage createState() => _SelectTranslateLanguage();
}

class _SelectTranslateLanguage extends State<SelectTranslateLanguage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    // TODO: implement build
    return new Scaffold(
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
                    'Translate Language',
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
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Translate all the conjugations into any of the \nLanguages below.',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.white,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/assets_icons_selectlang_listtop.png',
                      fit: BoxFit.fitHeight,
                      height: 40,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: Config.second_flag_name.length,
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: (){
                              if(widget.con != null){
                                widget.con.setsecondlanguage(Config.flag_name.indexOf(Config.second_flag_name[index]));
                                Navigator.of(context).pop();
                              }
                              if(widget.conselect != null){
                                widget.conselect.setsecondlanugage(Config.flag_name.indexOf(Config.second_flag_name[index]));
                                Navigator.of(context).pop();
                              }
                            },
                            leading:  SizedBox(
                              width: 30,
                              height: 30,
                              child: RawMaterialButton(
                                fillColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundImage: AssetImage('assets/images/flags/' + Config.second_flag_images[index]),
                                  ) ,
                                ),
                                shape: CircleBorder(),
                                elevation: 2.0,
                              ),
                            ),
                            title: Text(Config.second_flag_name[index]),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
