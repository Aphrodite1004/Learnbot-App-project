import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/controller/select_verb_controller.dart';
import 'package:leanrbot/screen/main/display_verb.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/screen/main/select_tranlate_language.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leanrbot/settings/settings1.dart';
import 'package:leanrbot/settings/settings2.dart';
import 'package:leanrbot/settings/settings3.dart';
import 'package:leanrbot/settings/settings4.dart';
import 'package:leanrbot/settings/settings5.dart';
import 'package:leanrbot/settings/settings6.dart';
import 'package:leanrbot/settings/settings10.dart';
import 'package:leanrbot/settings/settings11.dart';
import 'package:leanrbot/settings/settings12.dart';
import 'package:leanrbot/settings/settings13.dart';
import 'package:leanrbot/settings/settings14.dart';

int select_lang;
Select_verb_controller _con;

class Setting extends StatefulWidget {
  Setting(int lang, Select_verb_controller con) {
    select_lang = lang;
    _con = con;
  }

  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {
  List<String> setting_list = [
    'LearnBots',
    'How the app works',
    'About Us',
    'Blended Learning',
    'Restore (Full)',
    'Buy Full Version',
    'More Great Apps',
    'Share with a Friend',
    'Email Support',
    'Books',
    'Games',
    'Digital',
    'Free Resources'
  ];

  List<String> setting_img = [
    'LB',
    'book',
    'point',
    'learn',
    'full',
    'pay',
    'box',
    'friend',
    'email',
    'books',
    'tv',
    'digital',
    'free'
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    // TODO: implement build
    return Scaffold(
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
                    'Settings',
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
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 50),
                      child: ListView.separated(
                        itemCount: setting_list.length,
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings1()),
                                  );
                                  break;
                                case 1:
                                  launch("https://vimeo.com/455743598");
                                  break;
                                case 2:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings3()),
                                  );
                                  break;
                                case 3:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings4()),
                                  );
                                  break;
                                case 4:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings5(select_lang)),
                                  );
                                  break;
                                case 5:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings6(select_lang)),
                                  );
                                  break;
                                case 6:
                                  launch("https://www.iedutainments.com/apps/");
                                  break;
                                case 7:
                                  Share.share(
                                      'check out this new app is best learning app on the market', //Replace with your dynamic link and msg for invite users
                                      subject: 'Look what I made!');
                                  break;
                                case 8:
                                  final Uri _emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: 'info@iedutainments.com',
                                      queryParameters: {
                                        'subject': 'LearnBots Support'
                                      }
                                  );
                                  launch(_emailLaunchUri.toString());
                                  break;
                                case 9:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings11()),
                                  );
                                  break;
                                case 10:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings_12()),
                                  );
                                  break;
                                case 11:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings13()),
                                  );
                                  break;
                                case 12:
                                  launch("https://www.iedutainments.com/free-resources/");
                                  break;
                              }
                            },
                            leading: SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                'assets/images/icon/' +
                                    setting_img[index] +
                                    '.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(setting_list[index]),
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
                          child: GestureDetector(
                            onTap: () {
                              launch("https://www.iedutainments.com/");
                            },
                            child: Text(
                              'www.iedutainments.com',
                              style: TextStyle(color: colorStyle.primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          )),
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
