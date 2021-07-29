import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/login/auth_login.dart';
import 'package:tokoterserah/model/login_model.dart';
import '../register/register_screen_i.dart';
import './form_login_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isConnect = true;
  bool isLoading = false;
  String tokenGoogle;
  String _authStatus = 'Unknown';

  Future<void> _getToken() async {
    setState(() {
      isConnect = true;
      isLoading = false;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        LoginModel.getTokenLogin().then((v) {
          isLoading = false;
          setState(() {});
          if (v.error) {
            loadNotice(context, v.data, true, 'OK', () {
              Navigator.pop(context);
            });
          } else {
            setState(() {
              tokenGoogle = v.data;
            });
            print(tokenGoogle);
          }
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      setState(() {});
    }
  }

  _loginGoogle(Map res) async {
    setState(() {
      isConnect = true;
      isLoading = false;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        LoginModel.loginGoogle(tokenGoogle, res).then((v) async {
          await _handleSignOut();

          isLoading = false;
          setState(() {});
          if (v.error) {
            loadNotice(context, v.data, true, 'OK', () {
              Navigator.pop(context);
            });
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false,
                arguments: {"after_login": true});
          }
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    
    super.initState();
    

  
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      setState(() {});

      if (account != null) {
        Map res = await setData(account);
        // await _handleSignOut();

        _loginGoogle(res);
      }
      //  loadNotice(context, account.toString()+'kosong', true, 'OK', () {
      //       Navigator.pop(context);
      //  });
    });
    _googleSignIn.signInSilently().then((account) async {
      if (account != null) {
        setState(() {});
        Map res = await setData(account);
        // await _handleSignOut();

        _loginGoogle(res);
      }
      //  loadNotice(context, account.toString()+'kosong', true, 'OK', () {
      //       Navigator.pop(context);
      //  });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _getToken());
  }

  setData(account) {
    return {
      'id': account.id,
      'email': account.email,
      'name': account.displayName,
      'ava': account.photoUrl,
      'provider': 'google'
    };
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    // var arguments=ModalRoute.of(context).settings.arguments;

    if (arguments != null) print(arguments);

    if (arguments != null ? arguments['after_regist'] : false) {
      arguments['after_regist'] = false;
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0)), //this right here
                child: Container(
                  height: 190,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(right: 8, bottom: 15),
                            child: FaIcon(
                              FontAwesomeIcons.times,
                              color: Colors.black54,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                              'Silakan cek email untuk mengaktivasi akun anda!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                        ),
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            height: 100,
                            child: Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                RaisedButton(
                                  child: Text(
                                    'OKE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            });
      });
    }

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context, jsonEncode({"load": true})),
        ),
        title: const Text(
          'Masuk',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Belum punya Akun? ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterScreenI()));
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, jsonEncode({"load": true}));
        },
        child: isLoading
            ? reqLoad()
            : Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      child: ListView(
                        children: <Widget>[
                          FormLoginView(),
                          DividerText(),
                          otherMethodButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget otherMethodButton() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 230 + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(sizeu.width / 10, 15, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 5),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                onPressed: () => _handleSignIn(context,'GOOGLE'),
                color: Color(0xFFF74933),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.google,
                      size: 18,
                      color: Colors.white,
                    ),
                    Text(
                      '  MASUK DENGAN GOOGLE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 15),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                onPressed: () => _handleSignIn(context,'APPLE'),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.apple,
                      size: 24,
                      color: Colors.black,
                    ),
                    Text(
                      '  MASUK DENGAN APPLE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              )),
          // Container(
          //     margin: EdgeInsets.only(top: 10),
          //     width: sizeu.width - sizeu.width / 5,
          //     height: 40,
          //     child: RaisedButton(
          //       onPressed: () {},
          //       color: Colors.white70,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           FaIcon(
          //             FontAwesomeIcons.apple,
          //             size: 20,
          //             color: Colors.black,
          //           ),
          //           Text(
          //             '  MASUK DENGAN APPLE',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold, color: Colors.black),
          //           ),
          //         ],
          //       ),
          //     )),
        ],
      ),
    );
  }

  Future<void> _handleSignIn(context, ops) async {
    try {
      switch (ops) {
        case 'GOOGLE':
          await _googleSignIn.signIn();

          break;
        case 'APPLE':
          var rand = new Random();
          var angka = rand.nextInt(5);

          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              clientId: 'com.app.tokoterserah',
              redirectUri: Uri.parse(
                'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
              ),
            ),
            // TODO: Remove these if you have no need for them
            nonce: 'example-nonce',
            state: 'example-state',
          );

          List<String> resApple = credential.toString().split(", ");

          print(resApple);

          if (resApple[3] == 'null') {
            return loadNotice(
                context, 'Untuk melanjutkan membutuhkan Email!', true, 'OK',
                () {
              Navigator.of(context).pop();
            });
          } else {
            Map<String, String> res = {
              'id': resApple[0].toString().split("(")[1],
              'email': resApple[3],
              'name': resApple[1] + ' ' + resApple[2],
              'ava': globalBaseUrl +
                  'images/faces/' +
                  (angka + 1).toString() +
                  '.jpg',
              'provider': 'Apple'
            };

            await _loginGoogle(res);
          }
          break;
        default:
      }
    } catch (error) {
      print(error.toString());
      //  loadNotice(context, error.toString()+'kosong', true, 'OK', () {
      //           Navigator.pop(error);
      //      });
    }
  }
}

class DividerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;

    return Container(
      child: Row(children: <Widget>[
        Expanded(child: Divider()),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              "ATAU",
              style: TextStyle(color: Colors.black54),
            )),
        Expanded(child: Divider()),
      ]),
    );
  }
}

Future<void> _handleSignOut() async {
  _googleSignIn.disconnect();
}

// end stack end
