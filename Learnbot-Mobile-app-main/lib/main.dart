import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leanrbot/screen/intro/intro.dart';
import 'package:leanrbot/screen/login/login.dart';
import 'package:leanrbot/screen/main/select_lang.dart';
import 'package:leanrbot/component/style.dart';

/// Run first apps open
void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  final Widget child;

  myApp({Key key, this.child}) : super(key: key);

  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  /// Create _themeBloc for double theme (Dark and White theme)
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// StreamBuilder for themeBloc
    return MaterialApp(
      title: 'Passion Power',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
      ),

      /// Move splash screen to onBoarding Layout
      /// Routes
      ///
      routes: <String, WidgetBuilder>{
        "onBoarding": (BuildContext context) =>
        new Intro()
      },
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState();
  @override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() {
    Navigator.of(context).pushReplacementNamed("onBoarding");
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }

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
               image: AssetImage(orientation == Orientation.landscape ? 'assets/images/landscape_splash.png':'assets/images/landingpage_splash.png'),
                fit: BoxFit.fill,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}
