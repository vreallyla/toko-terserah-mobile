import 'dart:convert';

import 'package:best_flutter_ui_templates/event/animation/spinner.dart';
import 'package:best_flutter_ui_templates/model/register_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../login/login_screen.dart';
import 'package:best_flutter_ui_templates/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// For changing the language
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

bool isLoading = false;

class RegisterScreenI extends StatefulWidget {
  const RegisterScreenI({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _RegisterScreenIState createState() => _RegisterScreenIState();
}

class _RegisterScreenIState extends State<RegisterScreenI> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

    Future<bool> _onWillPop() async {
      Navigator.pop(context, jsonEncode({"load": true}));
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.grey[200],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () =>
                  Navigator.pop(context, jsonEncode({"load": true}))),
          title: const Text(
            'Daftar',
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
                    'Punya Akun? ',
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
                                  LoginScreen()));
                    },
                    child: Text(
                      'Masuk Sekarang',
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
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  child: ListView(
                    children: <Widget>[
                      // OtherMethodButton(),
                      // DividerText(),
                      Padding(padding: EdgeInsets.only(top:10)),
                      FormRegister(),
                    ],
                  ),
                ),
                (isLoading
                    ? Container(
                        color: Colors.grey.withOpacity(0.3),
                      )
                    : Text(
                        'loading disapear',
                        style:
                            TextStyle(color: Colors.transparent, fontSize: 0),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  TextEditingController emailInput = new TextEditingController();
  UserModel userModel;
  String messageEmail;
  bool emailDisabled = false;
  final format = DateFormat("yyyy-MM-dd");
  // var isLoading = false;

  TextEditingController passwordInput = new TextEditingController();
  FaIcon seePass = FaIcon(FontAwesomeIcons.eye);
  bool occuText = true;
  String msgPass;

  TextEditingController namaInput = new TextEditingController();
  String msgNama;

  TextEditingController usernameInput = new TextEditingController();
  String msgusername;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      // height: 150 + (messageEmail != null ? 13 : 0) + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(sizeu.width / 10, 10, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //nama
          Container(
            // padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
            padding: EdgeInsets.only(bottom: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Nama Lengkap',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: TextField(
                      // enabled: false,
                      textAlign: TextAlign.left,
                      controller: namaInput,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan Nama', false)),
                ),
                hintMsg(msgNama),
              ],
            ),
          ),

          //email
          Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Email',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold))),
              SizedBox(
                width: sizeu.width - sizeu.width / 5,
                height: 40,
                child: TextField(
                  enabled: emailDisabled ? false : true,
                  textAlign: TextAlign.left,
                  controller: emailInput,
                  // controller: ,
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1),
                    ),
                    hintText: 'Masukkan Email',
                    fillColor: emailDisabled
                        ? Colors.grey.withOpacity(.3)
                        : Colors.white,
                    filled: true,
                  ),
                ),
              ),
              //message email
              hintMsg(messageEmail),
            ],
          ),
          //nama
          Container(
            // padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
            padding: EdgeInsets.only(bottom: 5, top: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Username',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: TextField(
                      // enabled: false,
                      textAlign: TextAlign.left,
                      controller: usernameInput,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan Username', false)),
                ),
                hintMsg(msgusername),
              ],
            ),
          ),

          //password
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Password',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: Stack(
                    children: [
                      TextField(
                          obscureText: occuText,
                          textAlign: TextAlign.left,
                          controller: passwordInput,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          decoration: defaultInput('Masukkan Password', false)),
                      Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 36,
                          child: IconButton(
                            icon: seePass,
                            tooltip: 'Lihat Password',
                            color: Colors.black38,
                            iconSize: 15,
                            onPressed: () {
                              if (occuText) {
                                seePass = FaIcon(FontAwesomeIcons.eyeSlash);
                                occuText = false;
                              } else {
                                seePass = FaIcon(FontAwesomeIcons.eye);
                                occuText = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //msg password
                hintMsg(msgPass),
              ],
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: 15),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  // side: BorderSide(color: Colors.red)
                ),
                onPressed: () {
                  isLoading = false;
                  // emailInput.text = 'vreallyla@gmail.com';
                  seePass = FaIcon(FontAwesomeIcons.eye);
                  occuText = true;
                  setState(() {});

                  RegisterModel.register(namaInput.text, emailInput.text,
                          passwordInput.text, usernameInput.text, '', ''
                          // _gendeRadioButton,
                          // tglLahirInput.text
                          )
                      .then((value) {
                    isLoading = false;

                    if (value.error) {
                      // var colError=jsonDecode(value.data)['message'];

                      // print(jsonDecode(jsonDecode(value.data)['message']).toString());
                      msgNama =
                          jsonDecode(jsonDecode(value.data)['message'])['name']
                              .toString();
                      msgusername = jsonDecode(
                              jsonDecode(value.data)['message'])['username']
                          .toString();
                      // msgJenisKelamin = jsonDecode(
                      //         jsonDecode(value.data)['message'])['gender']
                      //     .toString();
                      // msgTL =
                      //     jsonDecode(jsonDecode(value.data)['message'])['dob']
                      //         .toString();
                      messageEmail =
                          jsonDecode(jsonDecode(value.data)['message'])['email']
                              .toString();
                      msgPass = jsonDecode(
                              jsonDecode(value.data)['message'])['password']
                          .toString();

                      msgNama = msgNama == 'null' ? null : msgNama;
                      msgusername = msgNama == 'null' ? null : msgusername;
                      messageEmail =
                          messageEmail == 'null' ? null : messageEmail;
                      // msgJenisKelamin =
                      //     msgJenisKelamin == 'null' ? null : msgJenisKelamin;
                      // msgTL = msgTL == 'null' ? null : msgTL;
                      msgPass = msgPass == 'null' ? null : msgPass;

                      setState(() {});
                    } else {
                      Navigator.of(context).pushReplacementNamed('/login',
                          arguments: {'after_regist': true});
                    }
                  });
                  setState(() {});
                },
                color: Colors.green,
                child: (isLoading
                    ? Spinner(
                        icon: FontAwesomeIcons.spinner, color: Colors.white)
                    : Text('DAFTAR SEKARANG',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              )),
        ],
      ),
    );
  }
}

class DividerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(left: sizeu.width / 10, right: sizeu.width / 10),
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

class OtherMethodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      // height: 230 + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(sizeu.width / 10, 15, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     Container(
      //         margin: EdgeInsets.only(top: 10),
      //         width: (sizeu.width - ((sizeu.width / 10) * 2) - 10) / 2,
      //         height: 40,
      //         child: RaisedButton(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(4.0),
      //             // side: BorderSide(color: Colors.red)
      //           ),
      //           onPressed: () {},
      //           color: Color(0xFFF74933),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               FaIcon(
      //                 FontAwesomeIcons.google,
      //                 size: 15,
      //                 color: Colors.white,
      //               ),
      //               Text(
      //                 '  GOOGLE',
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold, color: Colors.white),
      //               ),
      //             ],
      //           ),
      //         )),
      //     Container(
      //         margin: EdgeInsets.only(top: 10, left: 10),
      //         width: (sizeu.width - ((sizeu.width / 10) * 2) - 10) / 2,
      //         height: 40,
      //         child: RaisedButton(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(4.0),
      //             // side: BorderSide(color: Colors.red)
      //           ),
      //           onPressed: () {},
      //           color: Colors.blue[600],
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               FaIcon(
      //                 FontAwesomeIcons.facebookF,
      //                 size: 15,
      //                 color: Colors.white,
      //               ),
      //               Text(
      //                 '  FACEBOOK',
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold, color: Colors.white),
      //               ),
      //             ],
      //           ),
      //         )),
      //   ],
      // ),
    
    );
  }

  Container hintMsg(String msg) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Text(
        (msg != null ? msg : ''),
        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: (msg != null ? 13 : 0)),
      ),
    );
  }
}

Container hintMsg(String msg) {
  return Container(
    padding: EdgeInsets.only(top: 4),
    child: Text(
      (msg != null ? msg : ''),
      style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: (msg != null ? 13 : 0)),
    ),
  );
}

InputDecoration defaultInput(String hint, bool dis) {
  return new InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 1),
    ),
    hintText: hint,
    fillColor: dis ? Colors.grey.withOpacity(.2) : Colors.white,
    filled: true,
  );
}

// end stack end
