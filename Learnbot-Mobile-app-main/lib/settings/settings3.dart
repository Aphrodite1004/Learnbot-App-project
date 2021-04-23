import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:url_launcher/url_launcher.dart';



class Settings3 extends StatefulWidget {

  @override
  _Settings3 createState() => _Settings3();
}

class _Settings3 extends State<Settings3> {

  
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
                    'ABOUT US',
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
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                     Text(
                       """Rory Ryder founded iEdutainments in 2010 with a passion for developing language learning products that are innovative, educational and entertaining. This led him to build it from a tiny, self-funded initiative into what we are today, an educational company with a global reach.\n\n
These three principles continue to be the driving force behind each partnership and creation. We strive to enliven the learner’s senses with every product we develop. Today we partner with governments, international publishers, distributors and technology companies to bring further world-class language resources to teachers and students.\n\n
Our strong belief in blended learning made us create a whole ecosystem of products divided into three main categories: books, digital and traditional board games. Thinking outside the box has ensured that our products appeal to all learners, despite their age. Suitable for children and adults alike. They can be used at school, at home or on the go.""",
                       textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black),
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
