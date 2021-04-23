import 'package:flutter/material.dart';
import 'package:leanrbot/component/style.dart';
import 'package:leanrbot/component/validator.dart';
import 'package:leanrbot/screen/intro/intro.dart';
import 'package:leanrbot/screen/login/login.dart';
import 'package:leanrbot/screen/login/signup.dart';
import 'package:leanrbot/service/authentification.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Signin extends StatefulWidget {
  Signin();
  @override
  _SigninState createState() => _SigninState();
}

/// Component UI
class _SigninState extends State<Signin> {
  _SigninState();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _pass;

  BaseAuth auth;
  String _userId = "";

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    auth = new Auth();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
       MediaQueryData mediaquery = MediaQuery.of(context);
        return new Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
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
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: orientation == Orientation.portrait?  100 : 20,
                    right:  MediaQuery.of(context).size.width/2 -175,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black26,
                                primaryColorDark: Colors.black26,
                              ),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please type an email';
                                  }
                                  if(input.isNotEmpty && !Validator.validateEmail(input)){
                                    return 'Please type an valid email';
                                  }
                                },
                                onSaved: (input) => _email = input,
                                style: new TextStyle(color: Colors.black),
                                textAlign: TextAlign.start,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                    border:  new OutlineInputBorder(
                                      borderSide: new BorderSide(color: colorStyle.inputcolor),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: colorStyle.inputcolor),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: colorStyle.inputcolor,
                                    hintText: 'Email ID',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,// You can use like this way or like the below line
                                        //borderRadius: new BorderRadius.circular(30.0),
                                        color: Colors.grey,
                                      ),
                                      child: Icon(
                                          Icons.email
                                      ),
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black26,
                                primaryColorDark: Colors.black26,
                              ),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please type an password';
                                  }
                                },
                                onSaved: (input) => _pass = input,
                                style: new TextStyle(color: Colors.black),
                                textAlign: TextAlign.start,
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                autocorrect: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                    border:  new OutlineInputBorder(
                                      borderSide: new BorderSide(color: colorStyle.inputcolor),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: colorStyle.inputcolor),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: colorStyle.inputcolor,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,// You can use like this way or like the below line
                                        //borderRadius: new BorderRadius.circular(30.0),
                                        color: Colors.grey,
                                      ),
                                      child: Icon(
                                          Icons.lock
                                      ),
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: RoundedLoadingButton(
                                width: 350,
                                height: 55,
                                color: Colors.grey,
                                controller: _btnController,
                                onPressed: (){
                                  signinauth();
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.grey,
                                onPressed: (){
                                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => new Signup()));
                                },
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              height: 55,
                            ),
                          ],
                        ),
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

  Future<void> signinauth() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      String userId = await auth.signIn(_email, _pass);
      if(userId != null){
        _btnController.success();
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new Intro()));
      } else{
        _btnController.reset();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content:Text('Please input correct email and password.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

      }

    } else{
     _btnController.reset();
    }
  }
}
