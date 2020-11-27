// import 'package:tokoterserah/fitness_app/traning/training_screen.dart';
import 'dart:convert';

import 'package:tokoterserah/event/animation/spinner.dart';
import 'package:tokoterserah/model/register_model.dart';
import 'package:tokoterserah/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// PopResult
class PopWithResults<T> {
  /// poped from this page
  final String fromPage;

  /// pop until this page
  final String toPage;

  /// results
  final Map<String, T> results;

  /// constructor
  PopWithResults(
      {@required this.fromPage, @required this.toPage, this.results});
}

class RegisterScreenII extends StatefulWidget {
  @override
  _RegisterScreenIIState createState() => _RegisterScreenIIState();
}

class _RegisterScreenIIState extends State<RegisterScreenII>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  var isLoading = false;

  TextEditingController namaInput = new TextEditingController();
  String msgNama;

  String _gendeRadioButton; //Initial definition of radio button value
  String msgJenisKelamin;

  TextEditingController emailInput = new TextEditingController();

  UserModel userModel;
  String messageEmail;
  bool emailDisabled = false;
  final myformat = DateFormat("yyyy-MM-dd");

  DateTime selectedDate = DateTime.now();
  TextEditingController tglLahirInput = new TextEditingController();
  String msgTL;

  TextEditingController passwordInput = new TextEditingController();
  FaIcon seePass = FaIcon(FontAwesomeIcons.eye);
  bool occuText = true;
  String msgPass;

  void radioButtonChanges(String value) {
    setState(() {
      setState(() {
        _gendeRadioButton = value;
      });
      debugPrint(_gendeRadioButton); //Debug the choice in console
    });
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        curve: Curves.bounceIn, parent: animationController.view));
    animationController.forward();
  }

  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    emailInput.text = arguments['email'];
    setState(() {});
    final sizeu = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Daftar',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
            child: Stack(
          children: <Widget>[
            Container(
                width: sizeu.width,
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5,
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    // side: BorderSide(color: Colors.red)
                  ),
                  onPressed: () {
                    seePass = FaIcon(FontAwesomeIcons.eye);
                    occuText = true;
                    isLoading = true;
                    setState(() {});

                    RegisterModel.register(
                            namaInput.text,
                            emailInput.text,
                            passwordInput.text,
                            '',
                            _gendeRadioButton,
                            tglLahirInput.text)
                        .then((value) {
                      isLoading = false;

                      if (value.error) {
                        // var colError=jsonDecode(value.data)['message'];

                        // print(jsonDecode(jsonDecode(value.data)['message']).toString());
                        msgNama = jsonDecode(
                                jsonDecode(value.data)['message'])['name']
                            .toString();
                        msgJenisKelamin = jsonDecode(
                                jsonDecode(value.data)['message'])['gender']
                            .toString();
                        msgTL =
                            jsonDecode(jsonDecode(value.data)['message'])['dob']
                                .toString();
                        messageEmail = jsonDecode(
                                jsonDecode(value.data)['message'])['email']
                            .toString();
                        msgPass = jsonDecode(
                                jsonDecode(value.data)['message'])['password']
                            .toString();

                        msgNama = msgNama == 'null' ? null : msgNama;
                        messageEmail =
                            messageEmail == 'null' ? null : messageEmail;
                        msgJenisKelamin =
                            msgJenisKelamin == 'null' ? null : msgJenisKelamin;
                        msgTL = msgTL == 'null' ? null : msgTL;
                        msgPass = msgPass == 'null' ? null : msgPass;

                        setState(() {});
                      } else {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    });
                    setState(() {});
                  },
                  child: (!isLoading
                      ? Text(
                          'Daftar Sekarang',
                          style: TextStyle(color: Colors.white),
                        )
                      : Spinner(
                          icon: FontAwesomeIcons.spinner, color: Colors.white)),
                  color: Colors.green,
                )),
            (isLoading
                ? Container(
                    height: 60,
                    color: Colors.grey.withOpacity(.3),
                  )
                : Text(
                    'loading holder',
                    style: TextStyle(fontSize: 0),
                  ))
          ],
        )),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                children: <Widget>[
//nama
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                    width: sizeu.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Nama',
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
                              onSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: defaultInput('Masukkan Nama', false)),
                        ),
                        hintMsg(msgNama),
                      ],
                    ),
                  ),

                  //email
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: sizeu.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Email',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          width: sizeu.width - 30,
                          height: 40,
                          child: TextField(
                              enabled: false,
                              textAlign: TextAlign.left,
                              controller: emailInput,
                              onChanged: (text) {
                                setState(() {});
                              },
                              onSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: defaultInput('Masukkan Email', true)),
                        ),
                        hintMsg(messageEmail),
                      ],
                    ),
                  ),

                  //gender
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: sizeu.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Jenis Kelamin',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold))),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _gendeRadioButton = 'pria';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(right: 5),
                                width: (sizeu.width - 40) / 3,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Radio(
                                        activeColor: Colors.green,
                                        value: 'pria',
                                        groupValue: _gendeRadioButton,
                                        onChanged: radioButtonChanges,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        "Pria",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _gendeRadioButton = 'wanita';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(right: 5),
                                width: (sizeu.width - 40) / 3,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Radio(
                                        activeColor: Colors.green,
                                        value: 'wanita',
                                        groupValue: _gendeRadioButton,
                                        onChanged: radioButtonChanges,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        "Wanita",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _gendeRadioButton = 'lainnya';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                // margin: EdgeInsets.only(right:5),
                                width: (sizeu.width - 40) / 3,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Radio(
                                        activeColor: Colors.green,
                                        value: 'lainnya',
                                        groupValue: _gendeRadioButton,
                                        onChanged: radioButtonChanges,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        "Lainnya",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //message jenis kelamin
                        hintMsg(msgJenisKelamin),
                      ],
                    ),
                  ),
                  // tanggal lahir
                  Container(
                    width: sizeu.width,
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Tanggal Lahir',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          width: sizeu.width - 30,
                          height: 40,
                          child: InkWell(
                            onTap: () {
                              selectDate(
                                  context); // Call Function that has showDatePicker()
                            },
                            child: IgnorePointer(
                              child: SizedBox(
                                width: sizeu.width - 30,
                                height: 40,
                                child: TextFormField(
                                  controller: tglLahirInput,
                                  decoration: defaultInput(
                                      'Pilih Tanggal Lahir', false),
                                  onSaved: (String val) {},
                                ),
                              ),
                            ),
                          ),
                        ),
                        //message ttl
                        hintMsg(msgTL),
                      ],
                    ),
                  ),
                  //password
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                                  decoration:
                                      defaultInput('Masukkan Password', false)),
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
                                        seePass =
                                            FaIcon(FontAwesomeIcons.eyeSlash);
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
                ],
              ),
            ),
            (isLoading
                ? Container(
                    color: Colors.grey.withOpacity(.3),
                  )
                : Text(
                    'loading',
                    style: TextStyle(fontSize: 0),
                  )),
          ],
        ),
      ),
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
                onPrimary: Colors.white,
                surface: Colors.green[100],
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tglLahirInput.text = myformat.format(selectedDate);
      });
  }

  InputDecoration defaultInput(String hint, bool dis) {
    return new InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
