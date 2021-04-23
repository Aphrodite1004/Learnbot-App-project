import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:url_launcher/url_launcher.dart';



class Settings7 extends StatefulWidget {

  @override
  _Settings7 createState() => _Settings7();
}

class _Settings7 extends State<Settings7> {

  
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
                    'How the app works',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  alignment: Alignment.center,
                ),
                
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                     
                    ),
                    Positioned(
                      bottom: 10,
                      child: Container(
                        width: mediaquery.size.width,
                        child:GestureDetector(
                          onTap: (){
                            launch("https://www.iedutainments.com/");
                          },
                          child:  Text(
                            'www.iedutainments.com',
                            style: TextStyle(
                                color: colorStyle.primaryColor
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
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
