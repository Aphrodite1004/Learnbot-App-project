import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class Intro extends StatefulWidget {
  Intro();
  @override
  _IntroState createState() => _IntroState();
}

/// Component UI
class _IntroState extends State<Intro> {

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {

        return new Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            /// Set Background image in splash screen layout (Click to open code)
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(orientation == Orientation.landscape ? 'assets/images/intro_landscape.png':'assets/images/intro_portrait.png'),
                  fit: BoxFit.fill,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
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
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new SelectLanguage(null, null)));
                              },
                              child: Text(
                                'Learn Verbs',
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
}
