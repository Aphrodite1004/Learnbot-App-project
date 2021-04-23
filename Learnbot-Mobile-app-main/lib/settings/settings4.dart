import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:url_launcher/url_launcher.dart';



class Settings4 extends StatefulWidget {

  @override
  _Settings4 createState() => _Settings4();
}

class _Settings4 extends State<Settings4> {

  
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
                    'Blended Learning',
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
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      ListTile(
                        title:  Text(
                          "SCHOOLS",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange,
                              fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold, ),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """Suitable for children and adults alike, our products provide language teachers with the flexibility they desire in class. If they prefer more traditional products and methods, they can use our books and board games. If it’s digital, then they can choose from our apps, online verb tables or software for whiteboards. Or even better, combined for a full blended learning approach.""",
                            style: TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                        )
                      ),
                      ListTile(
                        title: Text(
                          "HOMESCHOOLING",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """The closing of schools in many countries all over the world due to COVID-19 forced millions of children to continue their education at home. Our range of products guarantees children and adults can continue learning new languages at home; either independently with our apps, online verb tables or by playing our exciting board games with the family.""",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                        )
                      ),
                      ListTile(
                        title: Text(
                          "ON THE GO",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """Why lose time when you can make the most of it? With LearnBots apps and books, you can keep learning wherever you are. On the way to school,during a business trip or while on holidays.Keep moving, but wherever you are, keep learning with the LearnBots.""",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                        )
                      ),
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
