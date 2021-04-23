import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:url_launcher/url_launcher.dart';



class Settings1 extends StatefulWidget {

  @override
  _Settings1 createState() => _Settings1();
}

class _Settings1 extends State<Settings1> {

  
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
                    'LearnBots',
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
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child:SingleChildScrollView(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        child: ListTile(
                          title: Text(
                            """LearnBots® apps and books seamlessly combine colour verb tables, interactive pictures and animations that have been downloaded over 5 million times,to make your experience of learning the verbs and their conjugations fast,fun and easy regardless of your age and ability.""",
                            style: TextStyle(
                                fontSize: 15,  color: Colors.black),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      ListTile(
                        title: Text(
                          "METHODOLOGY",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """The LearnBots methodology offers a more visual and engaging blended learning approach to learn the verbs of another language. Using our recognisable generic system children, adults and travellers find the LearnBots a highly visual, fun and engaging way to learn the verbs either at home, in class or on the go!""",
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
                            "APP OVERVIEW",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                          ),
                          subtitle: Padding(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: """LearnBots seamlessly combine colour verb tables, interactive pictures, animations and audio """,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: """by native speakers""",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: """ to make your experience of learning the verbs and their conjugations fast, fun and easy regardless of age and ability.""",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                          )
                      ),
                      ListTile(
                        title: Text(
                          "WHO IS THE APP FOR?",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """The app is a great resource for dyslexic learners, kids and grown-ups alike. Children can start to identify what a verb is and the way it changes with the subject of the sentence. Advanced learners can go on to learn the different tenses and improve their accuracy.""",
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
                          "TRANSLATION OPTION",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """Our multi-translation feature allows users to translate the conjugations from each verb into their native language. This feature gives users an immediate and clear understanding of the verb and tense they are learning. This feature is free and available for our most popular languages.""",
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
                          "ADD MORE VERBS TO THE APP",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """Once familiar with the app users are encouraged to add more verbs in the same style as the LearnBots. This free feature allows users to add new verbs, conjugations and even a picture!""",
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
                          "AUDIO",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle:Padding(
                          child:  Text(
                            """The audio for all languages in this app has been recorded by native speakers to make your experience of remembering the verbs and conjugations more complete.""",
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
                            "TEST YOUR ABILITY",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                          ),
                          subtitle: Padding(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: """We have added a """,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: """hide the conjugations""",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: """ feature which allows users to test their ability in remembering the conjugations. This feature enables users to guess the conjugation before they click on the associated empty colour box. Once a user clicks the empty box the correct text will appear together with its matching audio.""",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                          )
                      ),
                      ListTile(
                        title: Text(
                          "LEARNBOTS THE GAME",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: colorStyle.primaryColor),
                        ),
                        subtitle: Padding(
                          child: Text(
                            """As a bonus feature, this app gives users the full audio for all verbs used in our board games. If you are looking for a more immersive and exciting way to learn a language, then these games are for you! Check the board games availability in your country by going to the International link on our website.""",
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
              )
            )
          ],
        ),
      ),
    );
  }
}
