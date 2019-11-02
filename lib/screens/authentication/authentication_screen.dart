import 'package:intelliTAG/screens/authentication/templates.dart';
import 'package:intelliTAG/utility/format.dart';
import 'package:intelliTAG/utility/transition.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isLoginButtonClicked = false;
  bool _isRegisterButtonClicked = false;
  bool _isForgotPasswordClicked = false;

  void createNewLoginTemplate() {
    setState(() {
      _isLoginButtonClicked = true;
      _isRegisterButtonClicked = false;
      _isForgotPasswordClicked = false;
    });
  }

  void createNewRegisterTemplate() {
    setState(() {
      _isRegisterButtonClicked = true;
      _isLoginButtonClicked = false;
      _isForgotPasswordClicked = false;
    });
  }

  void createNewForgotPasswordTemplate() {
    setState(() {
      _isForgotPasswordClicked = true;
      _isLoginButtonClicked = false;
      _isRegisterButtonClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(children: [
          new Column(children: [
            Spacer(flex: 1),
            Flexible(
                flex: 4,
                child: Align(
                  alignment: Alignment(0.0, -0.6),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                        'assets/logos/FuturistAcademyIcon.png',
                        fit: BoxFit.contain),
                  ),
                )),
            Text(
              "intelliTAG",
              style: new TextStyle(
                fontFamily: 'Lato',
                fontSize: Sizer.getTextSize(screenWidth, screenHeight, 45),
                color: Colors.white
              ),
            ),
            Spacer(flex: 2),
            Flexible(
                flex: 4,
                child: Container(
                    child: Column(children: [
                      Container(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.08,
                          child: new RaisedButton(
                            child: Text('Sign In',
                                style: new TextStyle(
                                  fontSize: Sizer.getTextSize(
                                      screenWidth, screenHeight, 20),
                                )),
                            textColor: Colors.black,
                            color: Colors.white.withOpacity(0.9),
                            onPressed: createNewLoginTemplate,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          )),
                      Container(
                        height: 15,
                      ),
                      Container(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.08,
                          child: new RaisedButton(
                              child: Text('Sign Up',
                                  style: new TextStyle(
                                    fontSize: Sizer.getTextSize(
                                        screenWidth, screenHeight, 20),
                                  )),
                              textColor: Colors.white,
                              color: Colors.black.withOpacity(0.7),
                              onPressed: () => Navigator.push(context,
                                  NoTransition(builder: (context) => new RegisterTemplate())),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      FlatButton(
                        textColor: Colors.white,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize:
                            Sizer.getTextSize(screenWidth, screenHeight, 16),
                          ),
                        ),
                        onPressed: createNewForgotPasswordTemplate,
                      )
                    ]))),
          ]),
          if (_isLoginButtonClicked)
            Stack(children: [
              GestureDetector(
                child: Container(
                  color: Colors.black45,
                  width: screenWidth,
                  height: screenHeight,
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _isLoginButtonClicked = false;
                  });
                },
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      child: Container(
                        child: new LoginTemplate(),
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                ),
              )
            ]),
          if (_isForgotPasswordClicked)
            Stack(
              children: <Widget>[
                GestureDetector(
                  child: Container(color: Colors.black45),
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _isForgotPasswordClicked = false;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Container(
                          child: ForgotPasswordTemplate(),
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                        ),
                      )),
                ),
              ],
            )
        ]));
  }
}