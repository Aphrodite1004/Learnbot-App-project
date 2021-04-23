import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:url_launcher/url_launcher.dart';



class Settings11 extends StatefulWidget {

  @override
  _Settings11 createState() => _Settings11();
}

class _Settings11 extends State<Settings11> {

  
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {

        return new Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            /// Set Background image in splash screen layout (Click to open code)
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(orientation == Orientation.landscape ? 'assets/images/book1.png':'assets/images/book2.png'),
                  fit: BoxFit.fill,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 10,
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
                            launch("https://www.iedutainments.com/books/");
                              },
                              child: Text(
                                'View Books',
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
