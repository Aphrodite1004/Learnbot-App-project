import 'package:flutter/material.dart';
import 'package:leanrbot/screen/intro/intro.dart';
import 'package:leanrbot/screen/login/signin.dart';
import 'package:leanrbot/screen/login/signup.dart';
import 'package:leanrbot/service/authentification.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
/// Component UI
class _LoginScreenState extends State<LoginScreen> {

  BaseAuth auth;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  _LoginScreenState();
  @override

  /// Setting duration in splash screen
  /// To navigate layout chang

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    auth = new Auth();
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          print(_userId);
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        if(authStatus == AuthStatus.LOGGED_IN){
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new Intro()));
        }
      });
    });

  }
  Widget buildWaitingScreen() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
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
            child: authStatus == AuthStatus.NOT_DETERMINED ? buildWaitingScreen():Stack(
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
                              Navigator.of(context).pushReplacement(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new Signin()));
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                          height: 50,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.grey,
                            onPressed: (){
                              Navigator.of(context).pushReplacement(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new Signup()));
                            },
                            child: Text(
                              'Sign Up',
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
